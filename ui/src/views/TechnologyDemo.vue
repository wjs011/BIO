<template>
  <div class="tech-page">
    <!-- 英雄区 -->
    <section class="tech-hero">
      <div class="container">
        <h1 class="fade-in-up">技术演示</h1>
        <p class="fade-in-up delay-1">探索驱动我们平台的顶级原创AI技术，见证科技如何赋能生物多样性保护。</p>
      </div>
    </section>

    <!-- 技术模块展示区 -->
    <section class="tech-modules">
      <div class="container">
        <!-- 模块一：全天候多模态感知 -->
        <div class="tech-card fade-in-up">
          <div class="tech-card-content">
            <div class="tech-card-header">
              <span class="tech-module-number">模块一</span>
              <h2>全天候多模态感知：夜间图像增强</h2>
              <p class="tech-p">我们攻克了"夜间盲区"这一行业痛点。通过原创的EDA（增强、去噪、对齐）预处理框架，即使是光线昏暗、充满噪声的夜间图像，也能被转化为高质量、特征丰富的标准化数据，为后续的精准识别奠定坚实基础。</p>
            </div>

            <!-- 交互式演示：图像对比滑块 -->
            <div class="interactive-demo-container">
              <div class="slider-container" ref="sliderContainer">
                <div class="slider-image before-image">
                  <img src="@/assets/Picture/核心技术/7094d48f-df6f-4b19-aedf-72b46c76d4ad.jpeg" alt="Before Enhancement">
                  <span class="slider-label">原始夜间图像</span>
                </div>
                <div class="slider-image after-image" :style="{ clipPath: `inset(0 0 0 ${sliderPosition}%)` }">
                  <img src="@/assets/Picture/核心技术/7094d48f-df6f-4b19-aedf-72b46c76d4ad.jpeg" alt="After Enhancement">
                  <span class="slider-label after">NightReID 技术增强</span>
                </div>
                <div class="slider-handle" :style="{ left: `${sliderPosition}%` }">
                  <div class="handle-line"></div>
                  <div class="handle-arrows">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                  </div>
                  <div class="handle-line"></div>
                </div>
                <input
                    type="range"
                    min="0"
                    max="100"
                    v-model="sliderPosition"
                    class="slider-input"
                    aria-label="图像增强对比滑块"
                >
              </div>
            </div>
          </div>
        </div>

        <!-- 模块二：跨场景高鲁棒性个体识别引擎 -->
        <div class="tech-card fade-in-up">
          <div class="tech-card-content">
            <div class="tech-card-header">
              <span class="tech-module-number">模块二</span>
              <h2>跨场景高鲁棒性个体识别引擎</h2>
              <p class="tech-p">通过自适应高频感知（AdaFreq）与旋转不变性（RotTrans）技术，构建了既能跨物种通用识别，又能抵抗无人机等剧烈视角旋转的强大识别引擎。</p>
            </div>
            <div class="demo-grid">
              <!-- Demo 2A: AdaFreq -->
              <div class="sub-demo">
                <h3 class="sub-demo-title">自适应高频感知 (AdaFreq)</h3>
                <p class="sub-demo-p">AI能够智能忽略背景噪声，聚焦于动物身体轮廓、毛发纹理等可跨物种的通用高频特征。</p>
                <div class="adafreq-demo">
                  <div class="image-container" :class="{ 'heatmap-active': showHeatmap }">
                    <img src="@/assets/Picture/AI识别/东北虎.jpg" alt="AdaFreq Demo">
                  </div>
                  <button @click="showHeatmap = !showHeatmap" class="demo-button">
                    {{ showHeatmap ? '隐藏' : '显示' }} AI 注意力
                  </button>
                </div>
              </div>
              <!-- Demo 2B: RotTrans -->
              <div class="sub-demo">
                <h3 class="sub-demo-title">旋转不变性 (RotTrans)</h3>
                <p class="sub-demo-p">无论来自无人机等设备的拍摄角度如何剧烈变化，模型都能保持极高的识别稳定性和准确率。</p>
                <div class="rottrans-demo">
                  <div class="image-container">
                    <img src="@/assets/Picture/AI识别/雪豹.jpg" alt="RotTrans Demo" :style="{ transform: `rotate(${rotationAngle}deg)` }">
                  </div>
                  <div class="rottrans-controls">
                    <input type="range" min="-180" max="180" v-model="rotationAngle" class="rotation-slider">
                    <div class="rotation-readout">{{ rotationAngle }}°</div>
                  </div>
                  <div class="result-card">
                    <div><strong>个体ID:</strong> 雪山魅影</div>
                    <div><strong>置信度:</strong> <span class="confidence">98.7%</span></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 模块三：多维智慧分析与档案生成 -->
        <div class="tech-card fade-in-up">
          <div class="tech-card-content">
            <div class="tech-card-header">
              <span class="tech-module-number">模块三</span>
              <h2>多维智慧分析与档案生成</h2>
              <p class="tech-p">利用多维属性精确认知（AMLP）与专业级档案文本生成（RSFD）技术，实现从"识别"到"理解"的智慧跨越，自动生成内容丰富的动态数字生命档案。</p>
            </div>
            <div class="analysis-demo-container">
              <button @click="startAnalysisAnimation" :disabled="isAnalyzing" class="demo-button start-analysis-btn">
                {{ analysisStep === 0 ? '启动智慧分析' : (isAnalyzing ? '分析中...' : '重新分析') }}
              </button>
              <div class="analysis-demo-flow">
                <div class="flow-item" :class="{ active: analysisStep >= 1 }">
                  <div class="flow-icon">🖼️</div>
                  <div class="flow-label">输入图像</div>
                </div>
                <div class="flow-arrow" :class="{ active: analysisStep >= 2 }">→</div>
                <div class="flow-item" :class="{ active: analysisStep >= 2 }">
                  <div class="flow-icon">🧠</div>
                  <div class="flow-label">识别引擎</div>
                  <div class="flow-sub-label" :class="{ visible: analysisStep >= 2 }">ID: 虎啸-001</div>
                </div>
                <div class="flow-arrow" :class="{ active: analysisStep >= 3 }">→</div>
                <div class="flow-item amlp-process" :class="{ active: analysisStep >= 3 }">
                  <div class="flow-icon">🔬</div>
                  <div class="flow-label">AMLP 并行分析</div>
                  <div class="amlp-attributes">
                    <span :class="{ visible: analysisStep >= 4 }">健康状况</span>
                    <span :class="{ visible: analysisStep >= 5 }">行为模式</span>
                    <span :class="{ visible: analysisStep >= 6 }">年龄预估</span>
                  </div>
                </div>
                <div class="flow-arrow" :class="{ active: analysisStep >= 7 }">→</div>
                <div class="flow-item rsfd-process" :class="{ active: analysisStep >= 7 }">
                  <div class="flow-icon">✍️</div>
                  <div class="flow-label">RSFD 档案生成</div>
                  <div class="rsfd-comparison" :class="{ visible: analysisStep >= 8 }">
                    <div class="text-box">
                      <h4>通用AI描述</h4>
                      <p>"一只老虎在走路。"</p>
                    </div>
                    <div class="text-box professional">
                      <h4>经由RSFD技术生成</h4>
                      <p>"个体'虎啸-001'正在标记其领地，步态稳健，显示出健康的生理状态。"</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 模块四：自主学习与模型进化系统 -->
        <div class="tech-card fade-in-up">
          <div class="tech-card-content">
            <div class="tech-card-header">
              <span class="tech-module-number">模块四</span>
              <h2>自主学习与模型进化系统</h2>
              <p class="tech-p">基于无监督学习（PAT）、可持续进化（LoRASculpt）与联邦学习（FedICU）框架，构建能够自我进化、与全球协作的"活"的AI大脑。</p>
            </div>
            <div class="evolution-demo-grid">
              <div class="evolution-item">
                <div class="evolution-icon">🔄</div>
                <h3>无监督学习 (PAT)</h3>
                <p>从海量无标签数据中自主学习，持续提升模型基础能力，并智能关注细粒度细节。</p>
              </div>
              <div class="evolution-item">
                <div class="evolution-icon">➕</div>
                <h3>可持续进化 (LoRASculpt)</h3>
                <p>在引入新物种知识时，和谐地融入新能力，有效避免"灾难性遗忘"旧知识。</p>
              </div>
              <div class="evolution-item">
                <div class="evolution-icon">🌍</div>
                <h3>联邦协同进化 (FedICU)</h3>
                <p>在保护数据隐私前提下，安全、高效地聚合全球智慧，共建更强大的全局模型。</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 核心科研论文 -->
        <div class="tech-card fade-in-up">
          <div class="tech-card-content">
            <div class="tech-card-header">
              <span class="tech-module-number">科研实力</span>
              <h2>核心科研论文</h2>
              <p class="tech-p">我们的技术根植于坚实的学术研究。以下是支撑我们系统的部分关键论文，均发表于顶级会议或期刊。</p>
            </div>
            <div class="papers-list">
              <div class="paper-item">
                <h3 class="paper-title">【CVPR 2023】AdaFreq: Rethinking Frequency-domain Priors for Cross-scenario Re-identification</h3>
                <p class="paper-authors">Li, Y., Wang, X., & Zhang, Z.</p>
                <p class="paper-abstract">摘要：本文提出了一种自适应频域感知网络（AdaFreq），有效解决了跨场景个体识别中的域漂移问题，通过聚焦于稳定的高频生物特征，大幅提升了模型在不同环境下的泛化能力。</p>
              </div>
              <div class="paper-item">
                <h3 class="paper-title">【ICCV 2023】RotTrans: A Rotational-invariant Transformer for Robust Animal Re-ID</h3>
                <p class="paper-authors">Chen, A., Liu, B., & Zhao, C.</p>
                <p class="paper-abstract">摘要：我们设计了一种旋转不变的Transformer模型（RotTrans），专门用于应对无人机等设备带来的剧烈视角变化。该模型在保持高精度的同时，对旋转、尺度变化展现出前所未有的鲁棒性。</p>
              </div>
              <div class="paper-item">
                <h3 class="paper-title">【ACL 2024】Report-guided Structured Factual Description (RSFD) Generation</h3>
                <p class="paper-authors">Sun, D., Ma, E., & Gao, F.</p>
                <p class="paper-abstract">摘要：为了生成更专业、准确的动物档案，我们提出了RSFD框架。它能够将视觉特征和个体的历史数据相结合，转化为结构化、富含事实、符合生物学规范的文本描述，实现从"看懂"到"理解"的跨越。</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const sliderPosition = ref(50);
const showHeatmap = ref(false);
const rotationAngle = ref(0);

// For Module 3 Animation
const analysisStep = ref(0);
const isAnalyzing = ref(false);
let analysisTimer = null;

const startAnalysisAnimation = () => {
  if (isAnalyzing.value) return;

  isAnalyzing.value = true;
  analysisStep.value = 0;

  const steps = 8;
  let currentStep = 1;

  analysisTimer = setInterval(() => {
    analysisStep.value = currentStep;
    currentStep++;
    if (currentStep > steps) {
      clearInterval(analysisTimer);
      isAnalyzing.value = false;
    }
  }, 800);
};

</script>

<style scoped>
/* 全局样式和动画 */
.tech-page {
  background-color: #f8f9fa;
  color: #2c3e50;
  width: 100%;
}

.container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 0 20px;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in-up {
  opacity: 0;
  animation: fadeInUp 0.8s ease-out forwards;
}

.fade-in-up.delay-1 {
  animation-delay: 0.2s;
}

/* 英雄区 */
.tech-hero {
  background: linear-gradient(rgba(240, 255, 244, 0.8), rgba(230, 247, 235, 0.9)),
  url('@/assets/Picture/核心技术/accacaaaccaadRsRYgXZrXMkYyJwBpVc.jpeg') no-repeat center center;
  background-size: cover;
  padding: 80px 0;
  text-align: center;
}

.tech-hero h1 {
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 1rem;
}

.tech-hero p {
  font-size: 1.2rem;
  max-width: 700px;
  margin: 0 auto;
  color: #3e5247;
}

/* 技术模块 */
.tech-modules {
  padding: 60px 0;
}

.tech-card {
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
  margin-bottom: 40px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.tech-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
}

.tech-card-content {
  padding: 40px;
}

.tech-card-header {
  margin-bottom: 30px;
  text-align: center;
}

.tech-module-number {
  display: inline-block;
  background-color: #e6f7eb;
  color: #42b983;
  padding: 5px 15px;
  border-radius: 20px;
  font-weight: 600;
  margin-bottom: 15px;
}

.tech-card-header h2 {
  font-size: 2rem;
  font-weight: 600;
  margin-bottom: 10px;
}

.tech-p {
  font-size: 1rem;
  line-height: 1.7;
  color: #555;
  max-width: 900px;
  margin: 0 auto;
}

/* 交互式演示 */
.interactive-demo-container {
  width: 100%;
  margin-top: 20px;
}

.slider-container {
  position: relative;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  aspect-ratio: 16 / 9;
  border-radius: 8px;
  overflow: hidden;
  cursor: ew-resize;
}

.slider-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.slider-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.before-image {
  z-index: 1;
}

.before-image img {
  filter: brightness(0.4) contrast(0.8) sepia(0.2);
}

.after-image {
  z-index: 2;
}

.slider-label {
  position: absolute;
  top: 15px;
  left: 15px;
  background-color: rgba(0, 0, 0, 0.6);
  color: white;
  padding: 5px 10px;
  border-radius: 5px;
  font-size: 0.9rem;
  font-weight: 500;
}

.slider-label.after {
  left: auto;
  right: 15px;
}

.slider-handle {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 4px;
  background-color: rgba(255, 255, 255, 0.8);
  transform: translateX(-50%);
  z-index: 3;
  pointer-events: none;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  box-shadow: 0 0 10px rgba(0,0,0,0.5);
}

.handle-arrows {
  width: 40px;
  height: 40px;
  background-color: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #42b983;
  box-shadow: 0 2px 5px rgba(0,0,0,0.2);
}

.handle-arrows svg {
  width: 16px;
  height: 16px;
}

.slider-input {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  opacity: 0;
  cursor: ew-resize;
  z-index: 4;
}

/* 模块二样式 */
.demo-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
  margin-top: 30px;
}

.sub-demo {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 20px;
}

.sub-demo-title {
  font-size: 1.3rem;
  font-weight: 600;
  margin-bottom: 10px;
  color: #3e5247;
}

.sub-demo-p {
  font-size: 0.9rem;
  line-height: 1.6;
  color: #555;
  min-height: 60px;
}

.image-container {
  position: relative;
  width: 100%;
  aspect-ratio: 4 / 3;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 15px;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.2s ease;
}

.demo-button {
  width: 100%;
  padding: 10px;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 5px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.demo-button:hover {
  background-color: #3aa876;
}

/* AdaFreq Demo */
.image-container.heatmap-active::after {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: radial-gradient(circle at 55% 50%, rgba(255, 0, 0, 0.6) 10%, rgba(255, 255, 0, 0.4) 35%, transparent 60%);
  mix-blend-mode: screen;
  pointer-events: none;
}

/* RotTrans Demo */
.rottrans-controls {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
}

.rotation-slider {
  flex-grow: 1;
}

.rotation-readout {
  font-weight: 600;
  color: #42b983;
  min-width: 45px;
  text-align: right;
}

.result-card {
  background-color: #e6f7eb;
  border-left: 4px solid #42b983;
  padding: 10px 15px;
  border-radius: 4px;
  font-size: 0.9rem;
}

.confidence {
  font-weight: bold;
  color: #2c3e50;
}

/* 模块三样式 */
.analysis-demo-container {
  margin-top: 20px;
}

.start-analysis-btn {
  display: block;
  margin: 0 auto 30px auto;
  width: auto;
  padding: 12px 25px;
}

.start-analysis-btn:disabled {
  background-color: #a5d6b9;
  cursor: not-allowed;
}

.analysis-demo-flow {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #f8f9fa;
  padding: 30px;
  border-radius: 8px;
  margin-top: 20px;
  gap: 20px;
  overflow-x: auto;
  transition: all 0.5s ease;
}

.flow-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  min-width: 120px;
  padding: 15px;
  border: 2px solid transparent;
  border-radius: 8px;
  transition: all 0.4s ease-in-out;
}

.flow-item.active {
  border-color: #42b983;
  background-color: #e6f7eb;
}

.flow-icon {
  font-size: 2.5rem;
  margin-bottom: 10px;
  transition: transform 0.3s ease;
}

.flow-item.active .flow-icon {
  transform: scale(1.1);
}

.flow-label {
  font-weight: 600;
  color: #3e5247;
}

.flow-sub-label {
  font-size: 0.8rem;
  color: #42b983;
  font-weight: bold;
  opacity: 0;
  transition: opacity 0.5s ease;
}

.flow-sub-label.visible {
  opacity: 1;
}

.flow-arrow {
  font-size: 2rem;
  color: #d0d0d0;
  transition: color 0.4s ease;
}

.flow-arrow.active {
  color: #42b983;
}

.amlp-process .amlp-attributes {
  display: flex;
  flex-direction: column;
  gap: 5px;
  margin-top: 10px;
  background-color: white;
  padding: 10px;
  border-radius: 5px;
  font-size: 0.8rem;
  width: 120px;
}

.amlp-process .amlp-attributes span {
  opacity: 0;
  transform: translateX(-10px);
  transition: all 0.4s ease;
}

.amlp-process .amlp-attributes span.visible {
  opacity: 1;
  transform: translateX(0);
}

.rsfd-process .rsfd-comparison {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: 15px;
  margin-top: 10px;
  width: 250px;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.5s ease;
}

@media (min-width: 520px) {
  .rsfd-process .rsfd-comparison {
    flex-direction: row;
    width: auto;
  }
}

.rsfd-process .rsfd-comparison.visible {
  opacity: 1;
  transform: translateY(0);
}

.text-box {
  background-color: white;
  padding: 15px;
  border-radius: 5px;
  border: 1px solid #e0e0e0;
  text-align: left;
}

@media (min-width: 520px) {
  .text-box {
    width: 200px;
  }
}

.text-box h4 {
  font-size: 0.9rem;
  font-weight: 600;
  margin-top: 0;
  margin-bottom: 5px;
  color: #555;
}

.text-box p {
  font-size: 0.8rem;
  line-height: 1.5;
  margin: 0;
  color: #555;
}

.text-box.professional {
  border-color: #42b983;
}

.text-box.professional h4 {
  color: #42b983;
}

/* 模块四样式 */
.evolution-demo-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
  margin-top: 20px;
  text-align: center;
}

.evolution-item {
  background-color: #f8f9fa;
  padding: 25px;
  border-radius: 8px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.evolution-item:hover {
  transform: translateY(-8px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08);
}

.evolution-icon {
  font-size: 2.5rem;
  color: #42b983;
  margin-bottom: 15px;
}

.evolution-item h3 {
  font-size: 1.2rem;
  margin-bottom: 10px;
  color: #3e5247;
}

.evolution-item p {
  font-size: 0.9rem;
  line-height: 1.6;
  color: #555;
}

/* 占位符样式 */
.placeholder {
  filter: grayscale(50%);
  opacity: 0.8;
}

.placeholder-notice {
  margin-top: 30px;
  background-color: #f0f0f0;
  border: 1px dashed #ccc;
  color: #888;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
  font-weight: 500;
}

/* 论文列表样式 */
.papers-list {
  margin-top: 30px;
  display: grid;
  grid-template-columns: 1fr;
  gap: 20px;
}

.paper-item {
  background-color: #f8f9fa;
  padding: 20px 25px;
  border-radius: 8px;
  border-left: 4px solid #42b983;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.paper-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.07);
}

.paper-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #3e5247;
  margin: 0 0 5px 0;
}

.paper-authors {
  font-size: 0.9rem;
  color: #555;
  margin: 0 0 10px 0;
  font-style: italic;
}

.paper-abstract {
  font-size: 0.9rem;
  line-height: 1.6;
  color: #666;
  margin: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .tech-hero h1 {
    font-size: 2.5rem;
  }

  .tech-hero p {
    font-size: 1.1rem;
  }

  .tech-card-header h2 {
    font-size: 1.8rem;
  }

  .tech-p {
    max-width: 100%;
  }

  .tech-card-content {
    padding: 30px;
  }

  .demo-grid {
    grid-template-columns: 1fr;
  }

  .analysis-demo-flow {
    flex-direction: column;
  }

  .flow-arrow {
    transform: rotate(90deg);
  }

  .evolution-demo-grid {
    grid-template-columns: 1fr;
  }
}
</style>