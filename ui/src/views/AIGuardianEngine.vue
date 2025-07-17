<template>
  <div class="ai-root-light">
    <!-- 页面标题和描述-->
    <div v-if="currentStep === 'select'" class="page-header">
      <h1 class="main-title">🔬 AI-REID 多模态个体识别引擎</h1>
      <p class="main-subtitle">融合图像、文本与环境元数据，驱动跨场景高鲁棒性个体识别引擎，解锁前所未有的识别精度与深度洞察。</p>
    </div>

    <!-- 步骤1：选择动物样本或上传图片-->
    <transition name="fade">
      <div v-if="currentStep === 'select'" class="select-upload-wrap">
        <div class="progress-indicator">
          <div class="step-item active">
            <div class="step-circle">1</div>
            <span>选择样本</span>
          </div>
          <div class="step-line"></div>
          <div class="step-item">
            <div class="step-circle">2</div>
            <span>REID分析</span>
          </div>
          <div class="step-line"></div>
          <div class="step-item">
            <div class="step-circle">3</div>
            <span>个体档案</span>
          </div>
        </div>

        <div class="subtitle">请选择一个动物样本或上传图片进行REID个体识别</div>
        <div class="card-center-flex">
          <div class="card-list">
            <div v-for="(item, idx) in samples" :key="item.id" class="card-item"
                 :class="{selected: selectedAnimalIndex === idx && !uploadedImage, 'card-fade-in': true}"
                 :style="{ animationDelay: `${idx * 0.1}s` }"
                 @click="selectAnimal(idx)">
              <div class="card-img" :style="{ backgroundImage: `url('${item.cover}')` }">
                <div class="card-overlay">
                  <div class="species-tag">{{ item.species }}</div>
                  <div class="confidence-badge">99%</div>
                </div>
              </div>
              <div class="card-info">
                <div class="card-name">{{ item.name }}</div>
                <div class="card-desc">{{ item.desc }}</div>
                <div class="card-stats">
                  <span class="stat-item">
                    <i class="icon-location">📍</i>
                    {{ item.location || '栖息地监测中' }}
                  </span>
                </div>
              </div>
              <div v-if="selectedAnimalIndex === idx && !uploadedImage" class="selected-indicator">
                <svg class="checkmark" viewBox="0 0 24 24" width="24" height="24">
                  <path d="M9 16.17L4.83 12L3.41 13.41L9 19L21 7L19.59 5.59L9 16.17Z" fill="white"/>
                </svg>
              </div>
            </div>

            <!-- 上传卡片 -->
            <div class="card-item upload-card card-fade-in"
                 :class="{selected: uploadedImage, uploading: isUploading}"
                 :style="{ animationDelay: `${samples.length * 0.1}s` }"
                 @click="triggerUpload"
                 @dragover.prevent="onDragOver"
                 @dragleave.prevent="onDragLeave"
                 @drop.prevent="onDrop">
              <div class="card-img upload-img-bg" :class="{ 'drag-over': isDragOver }">
                <div v-if="!uploadedImage && !isUploading" class="upload-content">
                  <svg class="upload-plus" viewBox="0 0 64 64" width="48" height="48">
                    <line x1="32" y1="14" x2="32" y2="50" stroke="#2ECC71" stroke-width="4" stroke-linecap="round"/>
                    <line x1="14" y1="32" x2="50" y2="32" stroke="#2ECC71" stroke-width="4" stroke-linecap="round"/>
                  </svg>
                  <div class="upload-text">点击或拖拽上传</div>
                </div>
                <div v-if="isUploading" class="uploading-content">
                  <div class="upload-spinner"></div>
                  <div class="upload-text">处理中...</div>
                </div>
                <img v-if="uploadedImage && !isUploading" :src="uploadedImage" class="upload-preview-img" />
                <input id="file-upload" ref="fileInput" type="file" accept="image/*" @change="onFileChange" style="display:none;" />
              </div>
              <div class="card-info">
                <div class="card-name">上传图片</div>
                <div class="card-desc">支持 JPG/PNG，最大 10MB</div>
                <div class="card-stats">
                  <span class="stat-item">
                    <i class="icon-ai">🧠</i>
                    REID实时分析
                  </span>
                </div>
              </div>
              <button v-if="uploadedImage" class="clear-upload-btn" @click.stop="clearUpload">
                <svg viewBox="0 0 24 24" width="16" height="16">
                  <path d="M19 6.41L17.59 5L12 10.59L6.41 5L5 6.41L10.59 12L5 17.59L6.41 19L12 13.41L17.59 19L19 17.59L13.41 12L19 6.41Z" fill="currentColor"/>
                </svg>
              </button>
              <div v-if="uploadedImage" class="selected-indicator">
                <svg class="checkmark" viewBox="0 0 24 24" width="24" height="24">
                  <path d="M9 16.17L4.83 12L3.41 13.41L9 19L21 7L19.59 5.59L9 16.17Z" fill="white"/>
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- 新增：多模态文本输入 -->
        <div class="multimodal-input-section">
          <label for="multimodal-text" class="multimodal-label">
            <span class="label-icon">✍️</span>
            补充文本信息 (可选)
          </label>
          <textarea
              id="multimodal-text"
              v-model="additionalText"
              class="multimodal-textarea"
              placeholder="例如: 动物的行为、环境、发现时间等。详细的文本描述有助于提高REID准确率..."
          ></textarea>
        </div>

        <div class="action-section">
          <button class="start-btn" :disabled="!canStart || isUploading" @click="startAnalysis">
            <span v-if="!isStarting">🚀 启动分析引擎</span>
            <span v-else>
              <div class="btn-spinner"></div>
              启动中...
            </span>
          </button>

          <div class="tips-section">
            <div class="tip-item">
              <span class="tip-icon">💡</span>
              <span>我们的 <b>AdaFreq</b> 技术能有效忽略背景干扰，即使在杂乱环境中也能精准识别。</span>
            </div>
            <div class="tip-item">
              <span class="tip-icon">⚡</span>
              <span>得益于 <b>RotTrans</b> 模型，引擎能够抵抗无人机等设备的剧烈视角旋转，确保识别稳定性。</span>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <!-- 步骤2：识别动物-->
    <transition name="modal-fade">
      <div v-if="currentStep === 'analyzing'" class="modal-overlay">
        <div class="modal-content">
          <div class="modal-header">
            <h3>🚀 启动多维分析引擎...</h3>
            <div class="analysis-progress">
              <div class="progress-bar">
                <div class="progress-fill" :style="{ width: analysisProgress + '%' }"></div>
              </div>
              <span class="progress-text">{{ Math.floor(analysisProgress) }}%</span>
            </div>
          </div>

          <div class="modal-img-wrap">
            <img :src="displayImage" class="modal-img" :class="{ 'rottrans-active': isRotTransActive }" />
            <div class="scan-line" :style="{ top: scanLineTop + 'px' }" v-if="currentStep === 'analyzing' && !isAdaFreqActive"></div>
            <div class="adafreq-heatmap" v-if="isAdaFreqActive"></div>
            <div class="detection-points">
              <div v-for="point in detectionPoints" :key="point.id"
                   class="detection-point"
                   :style="{ left: point.x + '%', top: point.y + '%', animationDelay: point.delay + 's' }">
              </div>
            </div>
          </div>

          <div class="modal-status">
            <div class="status-grid">
              <div v-for="(msg, idx) in statusMessages" :key="idx"
                   class="status-item"
                   :class="{ active: currentStatusIndex >= idx, completed: currentStatusIndex > idx }">
                <div class="status-icon">
                  <div v-if="currentStatusIndex > idx" class="icon-check">✓</div>
                  <div v-else-if="currentStatusIndex === idx" class="icon-loading"></div>
                  <div v-else class="icon-pending">•</div>
                </div>
                <span class="status-text">{{ msg }}</span>
              </div>
            </div>

            <div class="ai-insights">
              <div class="insight-item" v-for="insight in currentInsights" :key="insight">
                <span class="insight-icon">🧠</span>
                <span>{{ insight }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <!-- 步骤3：结果展示-->
    <transition name="slide-fade">
      <div v-if="currentStep === 'result'" class="result-wrap">
        <div class="result-header">
          <h2>🎉 成功生成动态数字生命档案</h2>
          <div class="result-summary">
            <div class="accuracy-badge">
              <span class="accuracy-label">REID识别准确率</span>
              <span class="accuracy-value">{{ resultAccuracy }}%</span>
            </div>
          </div>
        </div>

        <div class="result-content">
          <div class="info-card-light">
            <img :src="displayImage" class="info-img-light" />
            <div class="info-content-light">
              <div class="animal-header">
                <h3 class="animal-name">{{ resultAnimal.name }}</h3>
                <div class="protection-status" :class="getProtectionLevel(resultAnimal.species)">
                  {{ getProtectionText(resultAnimal.species) }}
                </div>
              </div>

              <div class="info-grid">
                <div class="info-row-light">
                  <span class="info-label">🆔 个体ID:</span>
                  <span class="info-value-light">{{ resultAnimal.id }}</span>
                </div>
                <div class="info-row-light">
                  <span class="info-label">🐾 物种:</span>
                  <span class="info-value-light">{{ resultAnimal.species }}</span>
                </div>
                <div class="info-row-light">
                  <span class="info-label">📅 预估年龄:</span>
                  <span class="info-value-light">{{ resultAnimal.age }}</span>
                </div>
                <div class="info-row-light">
                  <span class="info-label">❤️ 健康状况:</span>
                  <span class="health-pill" :class="getHealthClass(resultAnimal.health)">
                    {{ resultAnimal.health }}
                  </span>
                </div>
                <div class="info-row-light">
                  <span class="info-label">📍 栖息地:</span>
                  <span class="info-value-light">{{ resultAnimal.habitat || '未知区域' }}</span>
                </div>
                <div class="info-row-light">
                  <span class="info-label">⚖️ 体重估算:</span>
                  <span class="info-value-light">{{ resultAnimal.weight || '65-85kg' }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="additional-info">
            <div class="map-card-light">
              <div class="map-title-light">
                <span>🗺️ 活动轨迹地图</span>
                <button class="view-details-btn">查看详情</button>
              </div>
              <div class="map-placeholder-light">
                <div class="map-content">
                  <div class="location-marker"></div>
                  <div class="activity-path"></div>
                  <span class="map-text">最近30天活动轨迹</span>
                </div>
              </div>
            </div>

            <div class="behavior-card">
              <div class="card-title">
                <span>📊 行为分析 (由 AMLP 驱动)</span>
              </div>
              <div class="behavior-stats">
                <div class="stat-box">
                  <span class="stat-label">活跃度</span>
                  <div class="stat-bar">
                    <div class="stat-fill" style="width: 85%"></div>
                  </div>
                  <span class="stat-value">85%</span>
                </div>
                <div class="stat-box">
                  <span class="stat-label">觅食频率</span>
                  <div class="stat-bar">
                    <div class="stat-fill" style="width: 72%"></div>
                  </div>
                  <span class="stat-value">72%</span>
                </div>
                <div class="stat-box">
                  <span class="stat-label">社交互动</span>
                  <div class="stat-bar">
                    <div class="stat-fill" style="width: 60%"></div>
                  </div>
                  <span class="stat-value">60%</span>
                </div>
              </div>
            </div>
          </div>

          <!-- MLLM 分析报告 -->
          <div class="mllm-analysis-card">
            <div class="card-title">
              <span>🧠 MLLM 深度分析报告</span>
            </div>
            <div class="mllm-content">
              <div class="mllm-section">
                <h4 class="mllm-section-title">轨迹分析与预测</h4>
                <p class="mllm-text">根据最近72小时的活动数据，个体"{{ resultAnimal.name }}"的活动范围稳定在东北方向的15平方公里内，符合其物种习性。轨迹预测模型显示，未来24小时有 <strong>75%</strong> 的概率会向标记的「水源地A」移动。</p>
              </div>
              <div class="mllm-section">
                <h4 class="mllm-section-title">健康与行为风险评估</h4>
                <p class="mllm-text">视觉分析未发现明显外伤，毛色光泽度正常。但行为数据显示，其夜间活跃度相较于历史基线下降了 <strong>15%</strong>，可能为早期潜在疾病征兆或近期能量摄入不足。风险等级：<span class="risk-level low">低</span></p>
              </div>
              <div class="mllm-section">
                <h4 class="mllm-section-title">多模态信息交叉验证</h4>
                <p class="mllm-text">用户上传的文本描述「{{ additionalText || '无' }}」与图像分析结果（步态稳健、精神状态良好）交叉验证一致。综合判断，该个体目前状态稳定。</p>
              </div>
            </div>
          </div>
        </div>

        <div class="action-buttons">
          <button class="back-btn secondary" @click="goBack">
            <span>🔄 重新REID识别</span>
          </button>
          <button class="export-btn primary" @click="exportResults">
            <span>📥 导出个体档案 (由 RSFD 生成)</span>
          </button>
          <button class="share-btn secondary" @click="shareResults">
            <span>📤 分享结果</span>
          </button>
        </div>

        <!-- 技术总结卡片 -->
        <div class="tech-summary-card">
          <div class="card-title">
            <span>⚙️ 本次分析调用技术模块</span>
          </div>
          <div class="tech-tags">
            <span class="tech-tag">AdaFreq</span>
            <span class="tech-tag">RotTrans</span>
            <span class="tech-tag">AMLP</span>
            <span class="tech-tag">RSFD</span>
          </div>
        </div>
      </div>
    </transition>

    <!-- 错误提示 -->
    <transition name="notification-fade">
      <div v-if="errorMessage" class="error-notification">
        <div class="error-content">
          <span class="error-icon">⚠️</span>
          <span>{{ errorMessage }}</span>
          <button @click="clearError" class="close-error">×</button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

// 响应式数据
const samples = ref([
  {
    name: '虎啸-001',
    desc: '左肩有独特斑纹',
    species: '东北虎',
    text: '2023年4月拍摄于大兴安岭，晨间活动，精神状态良好。',
    cover: new URL('@/assets/Picture/AI识别/东北虎.jpg', import.meta.url).href,
    id: 'CN-TGR-001',
    age: '5岁',
    health: '健康',
    habitat: '大兴安岭保护地',
    weight: '180-220kg',
    location: '中国东北'
  },
  {
    name: '雪山魅影',
    desc: '右耳有轻微缺口',
    species: '雪豹',
    text: '夜间红外相机捕捉，海拔4500米区域，正在捕食。',
    cover: new URL('@/assets/Picture/AI识别/雪豹.jpg', import.meta.url).href,
    id: 'CN-PNU-014',
    age: '3岁',
    health: '亚健康',
    habitat: '青藏高原',
    weight: '25-55kg',
    location: '青海'
  },
  {
    name: '团团',
    desc: '背部黑色条带较宽',
    species: '大熊猫',
    text: '卧龙保护区竹林中进食，看起来很满足。',
    cover: new URL('@/assets/Picture/AI识别/大熊猫.jpg', import.meta.url).href,
    id: 'CN-AML-088',
    age: '8岁',
    health: '需关注',
    habitat: '四川卧龙保护地',
    weight: '80-120kg',
    location: '四川'
  }
])

const currentStep = ref('select') // 'select' | 'analyzing' | 'result'
const selectedAnimalIndex = ref(null)
const uploadedImage = ref(null)
const additionalText = ref('')
const fileInput = ref(null)
const isUploading = ref(false)
const isStarting = ref(false)
const isDragOver = ref(false)
const errorMessage = ref('')

// 动画相关
const scanLineTop = ref(0)
const analysisProgress = ref(0)
const statusMessages = ref([
  "模块1: 全天候多模态感知...",
  "模块2: 启动跨场景识别引擎...",
  "模块2: [AdaFreq] 正在进行频域特征提取...",
  "模块2: [RotTrans] 正在进行旋转不变性校正...",
  "模块3: [AMLP] 启动多维属性并行分析...",
  "模块3: [RSFD] 生成专业级个体档案...",
  "✅ 分析完成！正在生成数字生命档案..."
])
const currentStatusIndex = ref(0)
const resultAccuracy = ref(0)
const detectionPoints = ref([])
const currentInsights = ref([])
const isAdaFreqActive = ref(false)
const isRotTransActive = ref(false)

// 定时器
let scanTimer = null
let statusTimer = null
let progressTimer = null

// 计算属性
const resultAnimal = computed(() => {
  if (selectedAnimalIndex.value !== null) {
    return samples.value[selectedAnimalIndex.value]
  }
  return samples.value[0]
})

const canStart = computed(() => selectedAnimalIndex.value !== null || uploadedImage.value)

const displayImage = computed(() => {
  if (uploadedImage.value) return uploadedImage.value
  if (selectedAnimalIndex.value !== null) return samples.value[selectedAnimalIndex.value].cover
  return ''
})

// 方法
function selectAnimal(idx) {
  selectedAnimalIndex.value = idx
  uploadedImage.value = null
  additionalText.value = samples.value[idx].text || ''
}

function triggerUpload() {
  if (fileInput.value) fileInput.value.value = '';
  fileInput.value && fileInput.value.click()
}

async function onFileChange(e) {
  const file = e.target.files[0]
  if (!file) return

  if (file.size > 10 * 1024 * 1024) {
    showError('文件大小超过10MB限制')
    return
  }

  if (!['image/jpeg', 'image/png', 'image/jpg'].includes(file.type)) {
    showError('仅支持JPG/PNG格式图片')
    return
  }

  isUploading.value = true

  try {
    const reader = new FileReader()
    reader.onload = (ev) => {
      uploadedImage.value = ev.target.result
      selectedAnimalIndex.value = null
      additionalText.value = ''
      isUploading.value = false
    }
    reader.onerror = () => {
      showError('图片读取失败，请重试')
      isUploading.value = false
    }
    reader.readAsDataURL(file)
  } catch (error) {
    showError('图片处理失败')
    isUploading.value = false
  }
}

function onDragOver(e) {
  isDragOver.value = true
}

function onDragLeave(e) {
  isDragOver.value = false
}

function onDrop(e) {
  isDragOver.value = false
  const files = e.dataTransfer.files
  if (files.length > 0) {
    const file = files[0]
    const event = { target: { files: [file] } }
    onFileChange(event)
  }
}

function clearUpload() {
  uploadedImage.value = null
  additionalText.value = ''
}

function startAnalysis() {
  if (!canStart.value) return

  isStarting.value = true

  setTimeout(() => {
    currentStep.value = 'analyzing'
    isStarting.value = false
    initializeAnalysis()
  }, 800)
}

function initializeAnalysis() {
  scanLineTop.value = 0
  analysisProgress.value = 0
  currentStatusIndex.value = 0
  resultAccuracy.value = 0

  // 生成检测点
  detectionPoints.value = [
    { id: 1, x: 25, y: 30, delay: 0.5 },
    { id: 2, x: 75, y: 45, delay: 1.0 },
    { id: 3, x: 50, y: 70, delay: 1.5 },
    { id: 4, x: 30, y: 85, delay: 2.0 }
  ]

  // 扫描线动画
  scanTimer = setInterval(() => {
    scanLineTop.value += 3
    if (scanLineTop.value >= 148) scanLineTop.value = 0
  }, 40)

  // 连续进度条动画
  const totalAnalysisDuration = (statusMessages.value.length - 1) * 2500 + 2000;
  const progressInterval = 50;
  const progressIncrement = 100 / (totalAnalysisDuration / progressInterval);

  progressTimer = setInterval(() => {
    if (analysisProgress.value < 100) {
      analysisProgress.value += progressIncrement;
    } else {
      analysisProgress.value = 100;
      clearInterval(progressTimer);
    }
  }, progressInterval);

  // 状态消息
  showNextStatus()

  // AI 洞察
  updateInsights()
}

function showNextStatus() {
  const totalSteps = statusMessages.value.length;

  if (currentStatusIndex.value < totalSteps - 1) {
    statusTimer = setTimeout(() => {
      currentStatusIndex.value++;
      updateInsights();

      // 触发特殊动画
      if (statusMessages.value[currentStatusIndex.value].includes('AdaFreq')) {
        isAdaFreqActive.value = true;
        setTimeout(() => { isAdaFreqActive.value = false; }, 2000);
      }
      if (statusMessages.value[currentStatusIndex.value].includes('RotTrans')) {
        isRotTransActive.value = true;
        setTimeout(() => { isRotTransActive.value = false; }, 2000);
      }

      showNextStatus(); // 递归调用
    }, 2500)
  } else {
    // 完成识别
    setTimeout(() => {
      analysisProgress.value = 100
      resultAccuracy.value = Math.floor(Math.random() * 5) + 95 // 95-99%

      setTimeout(() => {
        currentStep.value = 'result'
        clearTimers()
      }, 1500)
    }, 2000)
  }
}

function updateInsights() {
  const insights = [
    ['加载多模态REID神经网络', '初始化红外图像预处理器'],
    ['应用跨场景识别模型', '检测个体基本轮廓'],
    ['分析动物身体高频纹理', '滤除背景及光照噪声'],
    ['校正拍摄角度偏差', '确保关键特征的稳定性'],
    ['并行分析健康状况、行为模式、年龄等', '构建多维度生物特征向量'],
    ['对比通用AI，生成结构化、专业化描述', '构建完整的个体数字档案'],
    ['REID匹配成功！已确认个体身份']
  ]

  if (currentStatusIndex.value < insights.length) {
    currentInsights.value = insights[currentStatusIndex.value]
  }
}

function getProtectionLevel(species) {
  const levels = {
    '东北虎': 'critical',
    '雪豹': 'vulnerable',
    '大熊猫': 'vulnerable'
  }
  return levels[species] || 'unknown'
}

function getProtectionText(species) {
  const texts = {
    '东北虎': '极危物种',
    '雪豹': '易危物种',
    '大熊猫': '易危物种'
  }
  return texts[species] || '保护状态未知'
}

function getHealthClass(health) {
  const classes = {
    '健康': 'healthy',
    '亚健康': 'warning',
    '需关注': 'danger'
  }
  return classes[health] || 'unknown'
}

function exportResults() {
  // 模拟导出功能
  showError('导出功能开发中...', 'info')
}

function shareResults() {
  // 模拟分享功能
  if (navigator.share) {
    navigator.share({
      title: `AI识别结果: ${resultAnimal.value.name}`,
      text: `成功识别出${resultAnimal.value.species}，准确率${resultAccuracy.value}%`,
      url: window.location.href
    })
  } else {
    showError('分享功能开发中...', 'info')
  }
}

function goBack() {
  selectedAnimalIndex.value = null
  uploadedImage.value = null
  additionalText.value = ''
  currentStep.value = 'select'
  clearTimers()
}

function clearTimers() {
  if (scanTimer) clearInterval(scanTimer)
  if (statusTimer) clearTimeout(statusTimer)
  if (progressTimer) clearInterval(progressTimer)
}

function showError(message, type = 'error') {
  errorMessage.value = message
  setTimeout(() => {
    errorMessage.value = ''
  }, type === 'info' ? 2000 : 4000)
}

function clearError() {
  errorMessage.value = ''
}

// 生命周期
onMounted(() => {
  // 预加载图片
  samples.value.forEach(sample => {
    const img = new Image()
    img.src = sample.cover
  })
})

onUnmounted(() => {
  clearTimers()
})
</script>

<style scoped>
/* 全局样式 */
.ai-root-light {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  font-family: 'Inter', 'Noto Sans SC', Arial, sans-serif;
  position: relative;
  overflow-x: hidden;
  background: linear-gradient(180deg, #1F2937 0%, #111827 100%);
}

/* 背景图片 */
.ai-root-light::before {
  content: '';
  position: fixed;
  left: 0; top: 0; right: 0; bottom: 0;
  width: 100vw;
  height: 100vh;
  background: url('/public/background.jpg') center center/cover no-repeat;
  opacity: 0.2;
  z-index: 0;
  pointer-events: none;
}

.ai-root-light > * {
  position: relative;
  z-index: 1;
}

/* 页面标题 */
.page-header {
  text-align: center;
  margin: 100px 0 20px 0;
  color: white;
  padding-top: 20px;
}

.main-title {
  font-size: 2.5rem;
  font-weight: 800;
  margin-bottom: 12px;
  background: linear-gradient(45deg, #58D68D, #2ECC71);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.main-subtitle {
  font-size: 1.1rem;
  font-weight: 400;
  opacity: 0.9;
  margin: 0;
  letter-spacing: 0.5px;
}

/* 进度指示器 */
.progress-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 40px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 50px;
  backdrop-filter: blur(10px);
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.step-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  color: #6C757D;
  font-size: 0.9rem;
  font-weight: 500;
  transition: color 0.3s;
}

.step-item.active {
  color: #2ECC71;
}

.step-circle {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #E9ECEF;
  color: #6C757D;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  transition: all 0.3s;
}

.step-item.active .step-circle {
  background: #2ECC71;
  color: white;
  transform: scale(1.1);
}

.step-line {
  width: 60px;
  height: 2px;
  background: #E9ECEF;
  margin: 0 20px;
}

/* 选择上传区域 */
.select-upload-wrap {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  min-height: calc(100vh - 200px);
}

.subtitle {
  font-size: 1.1rem;
  font-weight: 500;
  color: white;
  margin-bottom: 40px;
  letter-spacing: 0.5px;
  text-align: center;
  opacity: 0.95;
}

.card-center-flex {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
}

.card-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 30px;
  max-width: 1200px;
  width: 100%;
  padding: 0 20px;
}

/* 卡片样式 */
.card-item {
  width: 100%;
  max-width: 280px;
  justify-self: center;
  height: 320px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 24px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 3px solid transparent;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(10px);
}

.card-fade-in {
  opacity: 0;
  transform: translateY(30px);
  animation: fadeInUp 0.6s ease-out forwards;
}

@keyframes fadeInUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card-item:hover {
  transform: translateY(-12px) scale(1.02);
  box-shadow: 0 20px 60px rgba(0,0,0,0.15);
}

.card-item.selected {
  border-color: #2ECC71;
  box-shadow: 0 20px 60px rgba(46, 204, 113, 0.3);
  transform: translateY(-8px) scale(1.02);
}

.card-img {
  height: 180px;
  width: 100%;
  background-size: cover;
  background-position: center;
  border-radius: 20px 20px 0 0;
  position: relative;
  overflow: hidden;
}

.card-overlay {
  position: absolute;
  top: 12px;
  left: 12px;
  right: 12px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.species-tag {
  background: rgba(0,0,0,0.7);
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
  backdrop-filter: blur(10px);
}

.confidence-badge {
  background: rgba(46, 204, 113, 0.9);
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: bold;
  backdrop-filter: blur(10px);
}

/* 上传卡片特殊样式 */
.upload-card .card-img.upload-img-bg {
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border: 2px dashed #2ECC71;
  box-sizing: border-box;
  padding: 10px;
  border-radius: 16px;
  height: 100%;
  transition: all 0.3s;
}

.upload-card .card-img.upload-img-bg.drag-over {
  border-color: #58D68D;
  background: linear-gradient(135deg, #58D68D 0%, #2ECC71 100%);
  transform: scale(1.02);
}

.upload-content, .uploading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.upload-text {
  color: #2ECC71;
  font-size: 0.9rem;
  font-weight: 600;
}

.upload-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid #e9ecef;
  border-top: 3px solid #2ECC71;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.upload-preview-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 16px;
}

.card-info {
  background: white;
  padding: 20px 16px 16px 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  justify-content: center;
  border-radius: 0 0 20px 20px;
}

.card-name {
  font-size: 1.2rem;
  font-weight: 700;
  color: #212529;
  margin-bottom: 6px;
  text-align: center;
}

.card-desc {
  font-size: 0.9rem;
  color: #6C757D;
  margin-bottom: 8px;
  text-align: center;
}

.card-stats {
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.8rem;
  color: #6C757D;
}

.selected-indicator {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 36px;
  height: 36px;
  background: #2ECC71;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: bounceIn 0.5s ease;
}

@keyframes bounceIn {
  0% { transform: scale(0); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}

.clear-upload-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 32px;
  height: 32px;
  background: rgba(255,255,255,0.9);
  color: #dc3545;
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.clear-upload-btn:hover {
  background: #dc3545;
  color: white;
  transform: scale(1.1);
}

/* 操作区域 */
.action-section {
  margin-top: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
}

.multimodal-input-section {
  width: 100%;
  max-width: 1200px;
  margin-top: 40px;
  padding: 0 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.multimodal-label {
  font-size: 1.1rem;
  font-weight: 500;
  color: white;
  display: flex;
  align-items: center;
  gap: 8px;
}

.multimodal-textarea {
  width: 100%;
  min-height: 100px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 12px 16px;
  color: white;
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.multimodal-textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.multimodal-textarea:focus {
  outline: none;
  border-color: #2ECC71;
  background: rgba(255, 255, 255, 0.15);
  box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.3);
}

.start-btn {
  background: linear-gradient(135deg, #58D68D 0%, #2ECC71 100%);
  color: white;
  font-size: 1.2rem;
  font-weight: bold;
  border: none;
  border-radius: 50px;
  padding: 18px 48px;
  box-shadow: 0 8px 32px rgba(46, 204, 113, 0.4);
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 200px;
  justify-content: center;
}

.start-btn:disabled {
  background: #e9ecef;
  color: #6C757D;
  cursor: not-allowed;
  box-shadow: none;
}

.start-btn:hover:enabled {
  transform: translateY(-2px);
  box-shadow: 0 12px 40px rgba(46, 204, 113, 0.5);
}

.btn-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top: 2px solid currentColor;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.tips-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
}

.tip-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: rgba(255,255,255,0.9);
  font-size: 0.9rem;
  padding: 8px 16px;
  background: rgba(255,255,255,0.1);
  border-radius: 20px;
  backdrop-filter: blur(10px);
}

.tip-icon {
  font-size: 1rem;
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  z-index: 9999;
  left: 0; top: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(5px);
}

.modal-content {
  background: white;
  border-radius: 24px;
  padding: 40px;
  box-shadow: 0 20px 80px rgba(0,0,0,0.3);
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 400px;
  max-width: 500px;
  margin: 20px;
}

.modal-header {
  text-align: center;
  margin-bottom: 30px;
  width: 100%;
}

.modal-header h3 {
  font-size: 1.3rem;
  font-weight: 700;
  color: #212529;
  margin-bottom: 16px;
}

.analysis-progress {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
}

.progress-bar {
  flex: 1;
  height: 8px;
  background: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #58D68D, #2ECC71);
  border-radius: 4px;
  transition: width 0.1s ease-out;
}

.progress-text {
  font-size: 0.9rem;
  font-weight: 600;
  color: #2ECC71;
  min-width: 40px;
}

.modal-img-wrap {
  position: relative;
  width: 200px;
  height: 200px;
  margin-bottom: 30px;
}

.modal-img {
  width: 100%;
  height: 100%;
  border-radius: 20px;
  object-fit: cover;
  box-shadow: 0 8px 32px rgba(0,0,0,0.2);
  transition: transform 0.5s ease;
}

.modal-img.rottrans-active {
  animation: spin-back-forth 2s ease-in-out;
}

@keyframes spin-back-forth {
  0% { transform: rotate(0deg) scale(1); }
  25% { transform: rotate(15deg) scale(1.05); }
  50% { transform: rotate(-10deg) scale(1.05); }
  75% { transform: rotate(5deg) scale(1.05); }
  100% { transform: rotate(0deg) scale(1); }
}

.scan-line {
  position: absolute;
  left: 0;
  width: 100%;
  height: 4px;
  background: linear-gradient(90deg,
  transparent 0%,
  rgba(46, 204, 113, 0.3) 20%,
  #2ECC71 50%,
  rgba(46, 204, 113, 0.3) 80%,
  transparent 100%);
  border-radius: 2px;
  box-shadow: 0 0 20px #2ECC71;
  transition: top 0.05s linear;
}

.adafreq-heatmap {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  border-radius: 20px;
  background: radial-gradient(circle at 55% 50%, rgba(255, 0, 0, 0.7) 10%, rgba(255, 255, 0, 0.5) 35%, transparent 70%);
  mix-blend-mode: screen;
  pointer-events: none;
  animation: fadeInOut 2s ease-in-out;
}

@keyframes fadeInOut {
  0%, 100% { opacity: 0; }
  50% { opacity: 1; }
}

.detection-points {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.detection-point {
  position: absolute;
  width: 8px;
  height: 8px;
  background: #2ECC71;
  border-radius: 50%;
  animation: pulse 2s infinite;
  box-shadow: 0 0 12px #2ECC71;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.5); opacity: 0.7; }
}

.modal-status {
  width: 100%;
}

.status-grid {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 0;
  transition: all 0.3s;
}

.status-item.active {
  color: #2ECC71;
}

.status-item.completed {
  color: #28a745;
}

.status-icon {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

.icon-loading {
  width: 16px;
  height: 16px;
  border: 2px solid #e9ecef;
  border-top: 2px solid #2ECC71;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.icon-pending {
  color: #6C757D;
}

.icon-check {
  color: #28a745;
}

.status-text {
  font-size: 1rem;
  font-weight: 500;
}

.ai-insights {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 16px;
  border-left: 4px solid #2ECC71;
}

.insight-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-size: 0.9rem;
  color: #495057;
}

.insight-item:last-child {
  margin-bottom: 0;
}

.insight-icon {
  font-size: 1rem;
}

/* 结果页面 */
.result-wrap {
  width: 100%;
  max-width: 1000px;
  padding: 40px 20px;
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.result-header {
  text-align: center;
  color: white;
}

.result-header h2 {
  font-size: 2rem;
  font-weight: 800;
  margin-bottom: 16px;
  background: linear-gradient(45deg, #58D68D, #2ECC71);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.result-summary {
  display: flex;
  justify-content: center;
}

.accuracy-badge {
  background: rgba(255,255,255,0.95);
  border-radius: 30px;
  padding: 12px 24px;
  display: flex;
  align-items: center;
  gap: 12px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
}

.accuracy-label {
  font-size: 0.9rem;
  color: #6C757D;
}

.accuracy-value {
  font-size: 1.2rem;
  font-weight: bold;
  color: #2ECC71;
}

.result-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.info-card-light {
  background: rgba(255,255,255,0.95);
  border-radius: 20px;
  padding: 32px;
  display: flex;
  gap: 32px;
  align-items: flex-start;
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
}

.info-img-light {
  width: 150px;
  height: 150px;
  border-radius: 20px;
  object-fit: cover;
  flex-shrink: 0;
  box-shadow: 0 8px 24px rgba(0,0,0,0.1);
}

.info-content-light {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.animal-header {
  display: flex;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
}

.animal-name {
  font-size: 1.5rem;
  font-weight: bold;
  color: #212529;
  margin: 0;
}

.protection-status {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: bold;
  text-transform: uppercase;
}

.protection-status.critical {
  background: #ffeaa7;
  color: #d63031;
}

.protection-status.vulnerable {
  background: #fab1a0;
  color: #e17055;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.info-row-light {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.95rem;
}

.info-label {
  color: #6C757D;
  font-weight: 500;
  min-width: 100px;
}

.info-value-light {
  color: #212529;
  font-weight: 600;
}

.health-pill {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: bold;
}

.health-pill.healthy {
  background: #d4edda;
  color: #155724;
}

.health-pill.warning {
  background: #fff3cd;
  color: #856404;
}

.health-pill.danger {
  background: #f8d7da;
  color: #721c24;
}

.additional-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
}

.map-card-light, .behavior-card {
  background: rgba(255,255,255,0.95);
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
}

.map-title-light, .card-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  font-size: 1.1rem;
  font-weight: bold;
  color: #212529;
}

.view-details-btn {
  background: #eafaf1;
  color: #2ECC71;
  border: none;
  border-radius: 12px;
  padding: 6px 12px;
  font-size: 0.8rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.view-details-btn:hover {
  background: #2ECC71;
  color: white;
  transform: translateY(-1px);
}

.map-placeholder-light {
  height: 200px;
  background: #f8f9fa;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.map-content {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.location-marker {
  width: 12px;
  height: 12px;
  background: #2ECC71;
  border-radius: 50%;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation: pulse 2s infinite;
}

.activity-path {
  position: absolute;
  width: 60%;
  height: 2px;
  background: linear-gradient(90deg, transparent, #2ECC71, transparent);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.map-text {
  color: #6C757D;
  font-size: 0.9rem;
  position: absolute;
  bottom: 12px;
  left: 50%;
  transform: translateX(-50%);
}

.behavior-stats {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.stat-box {
  display: flex;
  align-items: center;
  gap: 12px;
}

.stat-label {
  font-size: 0.9rem;
  color: #6C757D;
  min-width: 80px;
}

.stat-bar {
  flex: 1;
  height: 8px;
  background: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
}

.stat-fill {
  height: 100%;
  background: linear-gradient(90deg, #58D68D, #2ECC71);
  border-radius: 4px;
  transition: width 1s ease;
}

.stat-value {
  font-size: 0.9rem;
  font-weight: bold;
  color: #2ECC71;
  min-width: 40px;
  text-align: right;
}

.tech-summary-card {
  background: rgba(255,255,255,0.95);
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
}

.tech-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 8px;
}

.tech-tag {
  background: #e6f7eb;
  color: #3e5247;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 600;
}

.action-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 20px;
}

.back-btn, .export-btn, .share-btn {
  padding: 12px 24px;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 140px;
  justify-content: center;
}

.back-btn.secondary, .share-btn.secondary {
  background: rgba(255,255,255,0.95);
  color: #2ECC71;
  border: 2px solid #2ECC71;
}

.back-btn.secondary:hover, .share-btn.secondary:hover {
  background: #2ECC71;
  color: white;
  transform: translateY(-2px);
}

.export-btn.primary {
  background: linear-gradient(135deg, #58D68D 0%, #2ECC71 100%);
  color: white;
  border: none;
  box-shadow: 0 4px 16px rgba(46, 204, 113, 0.4);
}

.export-btn.primary span {
  font-size: 0.9rem;
  white-space: nowrap;
}

.export-btn.primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(46, 204, 113, 0.5);
}

/* 错误通知 */
.error-notification {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 10000;
  background: rgba(248, 215, 218, 0.95);
  border: 1px solid #f5c6cb;
  border-radius: 12px;
  padding: 16px 20px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.2);
  backdrop-filter: blur(10px);
  max-width: 400px;
}

.error-content {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #721c24;
}

.error-icon {
  font-size: 1.2rem;
}

.close-error {
  background: none;
  border: none;
  color: #721c24;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0;
  margin-left: auto;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 动画 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.slide-fade-enter-active {
  transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}
.slide-fade-enter-from {
  opacity: 0;
  transform: translateY(40px);
}

.modal-fade-enter-active, .modal-fade-leave-active {
  transition: opacity 0.4s;
}
.modal-fade-enter-from, .modal-fade-leave-to {
  opacity: 0;
}

.notification-fade-enter-active, .notification-fade-leave-active {
  transition: all 0.3s;
}
.notification-fade-enter-from, .notification-fade-leave-to {
  opacity: 0;
  transform: translateX(100%);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .main-title {
    font-size: 2rem;
  }

  .main-subtitle {
    font-size: 1rem;
  }

  .card-list {
    grid-template-columns: 1fr;
    gap: 20px;
    max-width: 300px;
  }

  .card-item {
    max-width: 100%;
  }

  .progress-indicator {
    padding: 16px;
    margin-bottom: 30px;
  }

  .step-item {
    font-size: 0.8rem;
  }

  .step-circle {
    width: 28px;
    height: 28px;
    font-size: 0.8rem;
  }

  .step-line {
    width: 40px;
    margin: 0 12px;
  }

  .modal-content {
    margin: 10px;
    padding: 30px 20px;
    min-width: auto;
    width: calc(100vw - 40px);
  }

  .info-card-light {
    flex-direction: column;
    text-align: center;
    padding: 24px;
  }

  .info-img-light {
    align-self: center;
  }

  .animal-header {
    justify-content: center;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .additional-info {
    grid-template-columns: 1fr;
  }

  .action-buttons {
    flex-direction: column;
    align-items: center;
  }

  .back-btn, .export-btn, .share-btn {
    width: 200px;
  }
}

@media (max-width: 480px) {
  .page-header {
    margin: 20px 0 15px 0;
  }

  .main-title {
    font-size: 1.8rem;
  }

  .result-wrap {
    padding: 20px 10px;
  }

  .tips-section {
    text-align: center;
  }

  .tip-item {
    font-size: 0.8rem;
    padding: 6px 12px;
  }
}

.mllm-analysis-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
  border-left: 4px solid #8B5CF6; /* MLLM 紫色 */
}

.mllm-content {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.mllm-section {
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}
.mllm-section:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.mllm-section-title {
  font-size: 1rem;
  font-weight: 600;
  color: #6D28D9;
  margin: 0 0 8px 0;
}

.mllm-text {
  font-size: 0.95rem;
  line-height: 1.7;
  color: #495057;
  margin: 0;
}

.mllm-text strong {
  color: #212529;
}

.risk-level {
  padding: 3px 10px;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: bold;
  color: white;
}
.risk-level.low { background-color: #28a745; }
.risk-level.medium { background-color: #ffc107; }
</style>