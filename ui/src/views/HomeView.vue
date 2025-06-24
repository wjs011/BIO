<template>
  <div class="home">
    <!-- 英雄区域 -->
    <section class="hero-section">
      <div class="hero-content">
        <h1>增强型全球生物多样性AI守护者</h1>
        <p>利用人工智能技术保护地球生物多样性</p>
        <div class="hero-buttons">
          <router-link to="/project-overview" class="btn btn-primary">了解更多</router-link>
          <router-link to="/ai-guardian" class="btn btn-secondary">探索技术</router-link>
        </div>
      </div>
    </section>

    <!-- 简介部分 -->
    <section class="intro-section">
      <div class="container">
        <div class="section-header">
          <h2>项目简介</h2>
          <div class="subtitle">智能科技助力生物多样性保护</div>
        </div>
        <div class="intro-content">
          <div class="intro-text">
            <p>增强型全球生物多样性AI守护者是一个结合人工智能与生态保护的创新项目，旨在通过先进技术手段监测、分析和保护全球生物多样性。</p>
            <p>我们的系统利用机器学习、计算机视觉和物联网技术，构建了一个全面的生态监测和保护网络，为濒危物种和生态系统提供有力支持。</p>
            <div class="feature-highlights">
              <div class="feature">
                <div class="feature-icon">🌍</div>
                <div class="feature-text">全球覆盖</div>
              </div>
              <div class="feature">
                <div class="feature-icon">🔍</div>
                <div class="feature-text">实时监测</div>
              </div>
              <div class="feature">
                <div class="feature-icon">🤖</div>
                <div class="feature-text">AI分析</div>
              </div>
              <div class="feature">
                <div class="feature-icon">🔄</div>
                <div class="feature-text">可持续发展</div>
              </div>
            </div>
          </div>
          <div class="intro-image">
            <img src="@/assets/Picture/项目概览/9a8fe4be-ce73-4418-91e5-a14efc07ab5a.jpeg" alt="项目简介">
          </div>
        </div>
      </div>
    </section>

    <!-- 核心内容卡片 -->
    <section class="cards-section">
      <div class="container">
        <div class="section-header">
          <h2>探索更多</h2>
          <div class="subtitle">了解我们的技术与项目</div>
        </div>
        <div class="cards-grid">
          <router-link to="/project-overview" class="card">
            <div class="card-image">
              <img src="@/assets/Picture/项目概览/c14c8985-845c-4f71-ab76-bb94e99a720b.jpeg" alt="项目概览">
            </div>
            <div class="card-content">
              <h3>项目概览</h3>
              <p>了解项目背景、目标和全球影响</p>
            </div>
          </router-link>

          <router-link to="/technique" class="card">
            <div class="card-image">
              <img src="@/assets/Picture/核心技术/7094d48f-df6f-4b19-aedf-72b46c76d4ad.jpeg" alt="核心技术">
            </div>
            <div class="card-content">
              <h3>核心技术</h3>
              <p>探索支持项目的前沿AI技术</p>
            </div>
          </router-link>

          <router-link to="/ai-guardian" class="card">
            <div class="card-image">
              <img src="@/assets/Picture/增强型全球生物多样性AI守护者/photo-1458724338480-79bc7a8352e4.webp" alt="AI守护者">
            </div>
            <div class="card-content">
              <h3>AI守护者</h3>
              <p>探索全球生物多样性AI守护系统</p>
            </div>
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'HomeView'
}
</script>

<style scoped>
.home {
  width: 100%;
}

/* 英雄区域 */
.hero-section {
  height: 80vh;
  background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.6)), 
              url('@/assets/Picture/项目概览/f89e8c3f-c8ef-4e3c-9d05-500fde5f8f62.jpeg') no-repeat center center;
  background-size: cover;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
  color: white;
  padding: 0 20px;
}

.hero-content {
  max-width: 800px;
}

.hero-content h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.hero-content p {
  font-size: 1.5rem;
  margin-bottom: 2rem;
}

.hero-buttons {
  display: flex;
  justify-content: center;
  gap: 15px;
}

.btn {
  padding: 12px 28px;
  border-radius: 4px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #42b983;
  color: white;
}

.btn-primary:hover {
  background-color: #3aa876;
}

.btn-secondary {
  background-color: transparent;
  color: white;
  border: 2px solid white;
}

.btn-secondary:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

/* 容器 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 章节通用样式 */
section {
  padding: 60px 0;
}

.section-header {
  text-align: center;
  margin-bottom: 40px;
}

.section-header h2 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 8px;
}

.subtitle {
  font-size: 1.2rem;
  color: #666;
}

/* 简介部分 */
.intro-section {
  background-color: #f9f9f9;
}

.intro-content {
  display: flex;
  align-items: center;
  gap: 40px;
}

.intro-text {
  flex: 1;
}

.intro-text p {
  margin-bottom: 1rem;
  line-height: 1.6;
}

.intro-image {
  flex: 1;
}

.intro-image img {
  width: 100%;
  border-radius: 8px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.feature-highlights {
  display: flex;
  justify-content: space-between;
  margin-top: 30px;
}

.feature {
  text-align: center;
}

.feature-icon {
  font-size: 2rem;
  margin-bottom: 8px;
}

/* 卡片部分 */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.card {
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
  transition: transform 0.3s ease;
  text-decoration: none;
  color: inherit;
}

.card:hover {
  transform: translateY(-5px);
}

.card-image {
  height: 200px;
  overflow: hidden;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.card:hover .card-image img {
  transform: scale(1.05);
}

.card-content {
  padding: 20px;
}

.card-content h3 {
  margin-bottom: 10px;
  color: #2c3e50;
}

.card-content p {
  color: #666;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .hero-content h1 {
    font-size: 2.5rem;
  }
  
  .hero-content p {
    font-size: 1.2rem;
  }
  
  .intro-content {
    flex-direction: column;
  }
  
  .feature-highlights {
    flex-wrap: wrap;
    gap: 20px;
  }
  
  .feature {
    width: 45%;
  }
}

@media (max-width: 480px) {
  .hero-content h1 {
    font-size: 2rem;
  }
  
  .hero-buttons {
    flex-direction: column;
  }
}
</style>
