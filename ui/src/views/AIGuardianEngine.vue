<template>
  <div class="ai-root-light">
    <!-- 步骤1：选择动物样本或上传图片 -->
    <transition name="fade">
      <div v-if="currentStep === 'select'" class="select-upload-wrap">
        <div class="subtitle">请选择一个动物样本或上传图片进行识别</div>
        <div class="card-center-flex">
          <div class="card-list">
            <div v-for="(item, idx) in samples" :key="item.id" class="card-item"
              :class="{selected: selectedAnimalIndex === idx && !uploadedImage}"
              @click="selectAnimal(idx)">
              <div class="card-img" :style="{ backgroundImage: `url('${item.cover}')` }"></div>
              <div class="card-info">
                <div class="card-name">{{ item.name }}</div>
                <div class="card-desc">{{ item.desc }}</div>
              </div>
            </div>
            <!-- 上传卡片 -->
            <div class="card-item upload-card" :class="{selected: uploadedImage}" @click="triggerUpload">
              <div class="card-img upload-img-bg">
                <svg v-if="!uploadedImage" class="upload-plus" viewBox="0 0 64 64" width="56" height="56">
                  <line x1="32" y1="14" x2="32" y2="50" stroke="#b2b2b2" stroke-width="6" stroke-linecap="round"/>
                  <line x1="14" y1="32" x2="50" y2="32" stroke="#b2b2b2" stroke-width="6" stroke-linecap="round"/>
                </svg>
                <img v-if="uploadedImage" :src="uploadedImage" class="upload-preview-img" />
                <input id="file-upload" ref="fileInput" type="file" accept="image/*" @change="onFileChange" style="display:none;" />
              </div>
              <div class="card-info">
                <div class="card-name">上传图片</div>
                <div class="card-desc">支持jpg/png</div>
              </div>
              <button v-if="uploadedImage" class="clear-upload-btn" @click.stop="clearUpload">移除图片</button>
            </div>
          </div>
        </div>
        <button class="start-btn" :disabled="!canStart" @click="startAnalysis">开始识别</button>
      </div>
    </transition>
    <!-- 步骤2：识别动画 -->
    <transition name="modal-fade">
      <div v-if="currentStep === 'analyzing'" class="modal-overlay">
        <div class="modal-content">
          <div class="modal-img-wrap">
            <img :src="displayImage" class="modal-img" />
            <div class="scan-line" :style="{ top: scanLineTop + 'px' }" v-if="currentStep === 'analyzing'"></div>
          </div>
          <div class="modal-status">
            <div v-for="(msg, idx) in statusMessages" :key="idx" class="modal-status-text" v-show="currentStatusIndex >= idx">
              {{ msg }}
            </div>
          </div>
        </div>
      </div>
    </transition>
    <!-- 步骤3：结果展示 -->
    <transition name="slide-fade">
      <div v-if="currentStep === 'result'" class="result-wrap">
        <div class="info-card-light">
          <img :src="displayImage" class="info-img-light" />
          <div class="info-content-light">
            <div class="info-row-light"><span>ID:</span><span class="info-value-light">{{ resultAnimal.id }}</span></div>
            <div class="info-row-light"><span>物种:</span><span class="info-value-light">{{ resultAnimal.species }}</span></div>
            <div class="info-row-light"><span>预估年龄:</span><span class="info-value-light">{{ resultAnimal.age }}</span></div>
            <div class="info-row-light">
              <span>健康状况:</span>
              <span class="pill-light">{{ resultAnimal.health }}</span>
            </div>
          </div>
        </div>
        <div class="map-card-light">
          <div class="map-title-light">活动轨迹地图</div>
          <div class="map-placeholder-light">地图占位</div>
        </div>
        <button class="back-btn" @click="goBack" style="margin-top: 32px;">重新识别</button>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, nextTick, watch } from 'vue'
// 动态引入dotlottie-player
if (typeof window !== 'undefined' && !window.__dotlottie_player_loaded) {
  const script = document.createElement('script');
  script.type = 'module';
  script.src = 'https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs';
  document.head.appendChild(script);
  window.__dotlottie_player_loaded = true;
}
const samples = ref([
  { name: '东北虎', desc: '日间高清', image: 'https://placehold.co/160x160/1a1a1a/ffffff?text=Tiger', cover: new URL('@/assets/Picture/AI识别/东北虎.jpg', import.meta.url).href, id: 'CN-TGR-003', species: '东北虎', age: '5岁', health: '健康' },
  { name: '雪豹', desc: '夜间红外图像', image: 'https://placehold.co/160x160/2a2a2a/ffffff?text=Leopard', cover: new URL('@/assets/Picture/AI识别/雪豹.jpg', import.meta.url).href, id: 'CN-PNU-014', species: '雪豹', age: '3岁', health: '亚健康' },
  { name: '大熊猫', desc: '部分被遮挡', image: 'https://placehold.co/160x160/3a3a3a/ffffff?text=Panda', cover: new URL('@/assets/Picture/AI识别/大熊猫.jpg', import.meta.url).href, id: 'CN-AML-088', species: '大熊猫', age: '8岁', health: '需关注' }
])
const currentStep = ref('select') // 'select' | 'analyzing' | 'result'
const selectedAnimalIndex = ref(null)
const uploadedImage = ref(null)
const fileInput = ref(null)
const scanLineTop = ref(0)
const statusMessages = ["初始化...", "提取特征...", "姿态分析...", "识别成功！"]
const currentStatusIndex = ref(0)
let scanTimer = null
let statusTimer = null

const resultAnimal = computed(() => {
  if (selectedAnimalIndex.value !== null) {
    return samples.value[selectedAnimalIndex.value]
  }
  // 上传图片时默认返回东北虎
  return samples.value[0]
})

const canStart = computed(() => selectedAnimalIndex.value !== null || uploadedImage.value)
const displayImage = computed(() => {
  if (uploadedImage.value) return uploadedImage.value
  if (selectedAnimalIndex.value !== null) return samples.value[selectedAnimalIndex.value].image
  return ''
})

function selectAnimal(idx) {
  selectedAnimalIndex.value = idx
  uploadedImage.value = null
}
function triggerUpload() {
  if (fileInput.value) fileInput.value.value = '';
  fileInput.value && fileInput.value.click()
}
function onFileChange(e) {
  const file = e.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = (ev) => {
      uploadedImage.value = ev.target.result
      selectedAnimalIndex.value = null
    }
    reader.readAsDataURL(file)
  }
}
function clearUpload() {
  uploadedImage.value = null
}
function startAnalysis() {
  currentStep.value = 'analyzing'
  scanLineTop.value = 0
  currentStatusIndex.value = 0
  scanTimer = setInterval(() => {
    scanLineTop.value += 4
    if (scanLineTop.value >= 148) scanLineTop.value = 0
  }, 30)
  statusTimer = setTimeout(showNextStatus, 800)
}
function showNextStatus() {
  if (currentStatusIndex.value < statusMessages.length - 1) {
    currentStatusIndex.value++
    statusTimer = setTimeout(showNextStatus, 1200)
  } else {
    setTimeout(() => {
      currentStep.value = 'result'
      clearInterval(scanTimer)
    }, 1200)
  }
}
function goBack() {
  selectedAnimalIndex.value = null
  uploadedImage.value = null
  currentStep.value = 'select'
  clearInterval(scanTimer)
  clearTimeout(statusTimer)
}
</script>

<style scoped>
.ai-root-light {
  width: 100vw;
  min-height: 100vh;
  background: #F8F9FA;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-family: 'Inter', 'Noto Sans SC', Arial, sans-serif;
  position: relative;
}
.select-upload-wrap {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #F8F9FA;
}
.subtitle {
  font-size: 1.08rem;
  font-weight: 400;
  color: #6C757D;
  margin-bottom: 32px;
  letter-spacing: 0.5px;
}
.card-center-flex {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.card-list {
  display: flex;
  gap: 40px;
  flex-wrap: wrap;
  justify-content: center;
  align-items: flex-end;
}
.card-item {
  width: 220px;
  height: 270px;
  background: #fff;
  border-radius: 22px;
  box-shadow: 0 4px 18px rgba(0,0,0,0.07);
  display: flex;
  flex-direction: column;
  align-items: stretch;
  cursor: pointer;
  transition: box-shadow 0.25s, border 0.25s, transform 0.25s;
  border: 2px solid transparent;
  position: relative;
  overflow: hidden;
}
.card-item:hover {
  transform: scale(1.03) translateY(-6px);
  box-shadow: 0 12px 32px rgba(0,0,0,0.16);
  z-index: 2;
}
.card-item.selected {
  border: 3px solid #6EE7B7;
  box-shadow: 0 16px 36px rgba(110,231,183,0.18);
}
.card-img {
  height: 160px;
  width: 100%;
  background-size: cover;
  background-position: center;
  border-top-left-radius: 22px;
  border-top-right-radius: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}
.upload-card .card-img.upload-img-bg {
  background: #e9ecef;
  display: flex;
  align-items: center;
  justify-content: center;
}
.upload-plus {
  display: block;
  margin: 0 auto;
}
.upload-preview-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 0;
}
.card-info {
  background: #fff;
  border-bottom-left-radius: 22px;
  border-bottom-right-radius: 22px;
  padding: 22px 0 14px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  justify-content: center;
}
.card-name {
  font-size: 1.13rem;
  font-weight: 700;
  color: #212529;
  margin-bottom: 6px;
  letter-spacing: 0.5px;
}
.card-desc {
  font-size: 0.98rem;
  font-weight: 400;
  color: #adb5bd;
  letter-spacing: 0.2px;
}
.clear-upload-btn {
  background: #fff;
  color: #6EE7B7;
  font-size: 0.98rem;
  font-weight: bold;
  border: 1.5px solid #6EE7B7;
  border-radius: 999px;
  padding: 4px 18px;
  cursor: pointer;
  margin-top: 6px;
  transition: background 0.2s, color 0.2s;
  position: absolute;
  right: 14px;
  top: 14px;
  z-index: 3;
}
.clear-upload-btn:hover {
  background: #6EE7B7;
  color: #fff;
}
.start-btn {
  background: #6EE7B7;
  color: #212529;
  font-size: 1.18rem;
  font-weight: bold;
  border: none;
  border-radius: 999px;
  padding: 16px 48px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  cursor: pointer;
  transition: background 0.2s, box-shadow 0.2s;
  margin-top: 32px;
}
.start-btn:disabled {
  background: #b2f5ea;
  color: #adb5bd;
  cursor: not-allowed;
  box-shadow: none;
}
.start-btn:hover:enabled {
  background: #4fd1b2;
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
}
.back-btn {
  background: #fff;
  color: #6EE7B7;
  font-size: 1.08rem;
  font-weight: bold;
  border: 1.5px solid #6EE7B7;
  border-radius: 999px;
  padding: 8px 32px;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.back-btn:hover {
  background: #6EE7B7;
  color: #fff;
}
.result-wrap {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding-top: 80px;
  background: #F8F9FA;
}
.info-card-light {
  width: 90%;
  max-width: 600px;
  background: #fff;
  border-radius: 16px;
  border: 1px solid #E9ECEF;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  padding: 32px 40px;
  display: flex;
  align-items: center;
  gap: 40px;
  margin-bottom: 36px;
  opacity: 1;
  transition: opacity 0.5s, transform 0.5s;
}
.info-img-light {
  width: 120px;
  height: 120px;
  border-radius: 16px;
  object-fit: cover;
  background: #e9ecef;
  flex-shrink: 0;
}
.info-content-light {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.info-row-light {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #212529;
  font-size: 1.08rem;
}
.info-value-light {
  color: #212529;
  font-weight: 600;
}
.pill-light {
  background: #6EE7B7;
  color: #212529;
  border-radius: 999px;
  padding: 2px 18px;
  font-weight: bold;
  font-size: 1.02rem;
  margin-left: 4px;
}
.map-card-light {
  width: 90%;
  max-width: 600px;
  background: #fff;
  border-radius: 16px;
  border: 1px solid #E9ECEF;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  padding: 28px 40px;
  display: flex;
  flex-direction: column;
  gap: 18px;
}
.map-title-light {
  color: #6EE7B7;
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 8px;
}
.map-placeholder-light {
  width: 100%;
  height: 160px;
  background: #F1F3F5;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #adb5bd;
  font-size: 1.1rem;
}
/* Modal样式 */
.modal-overlay {
  position: fixed;
  z-index: 9999;
  left: 0; top: 0; right: 0; bottom: 0;
  background: rgba(33,37,41,0.75);
  display: flex;
  align-items: center;
  justify-content: center;
}
.modal-content {
  background: #fff;
  border-radius: 18px;
  padding: 48px 56px 36px 56px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.18);
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 340px;
}
.modal-img-wrap {
  position: relative;
  width: 160px;
  height: 160px;
  margin-bottom: 32px;
}
.modal-img {
  width: 160px;
  height: 160px;
  border-radius: 16px;
  object-fit: cover;
  background: #e9ecef;
  display: block;
}
.scan-line {
  position: absolute;
  left: 0;
  width: 100%;
  height: 12px;
  background: linear-gradient(180deg, rgba(110,231,183,0.18) 0%, #6EE7B7 60%, rgba(110,231,183,0.18) 100%);
  border-radius: 6px;
  box-shadow: 0 0 16px 2px #6EE7B7;
  pointer-events: none;
  transition: top 0.08s linear;
  opacity: 0.85;
}
.modal-status {
  margin-top: 18px;
  min-height: 32px;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.modal-status-text {
  color: #212529;
  font-size: 1.12rem;
  font-weight: 500;
  margin-bottom: 2px;
  letter-spacing: 1px;
  opacity: 1;
  transition: opacity 0.3s;
}
/* 动画 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
.slide-fade-enter-active {
  transition: all 0.7s cubic-bezier(.4,2,.6,1);
}
.slide-fade-enter-from {
  opacity: 0;
  transform: translateY(40px);
}
.slide-fade-leave-to {
  opacity: 0;
  transform: translateY(40px);
}
.modal-fade-enter-active, .modal-fade-leave-active {
  transition: opacity 0.4s;
}
.modal-fade-enter-from, .modal-fade-leave-to {
  opacity: 0;
}
</style> 