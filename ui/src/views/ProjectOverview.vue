<template>
  <div class="project-overview">
    <div class="page-banner">
      <h1>项目概览</h1>
    </div>

    <div class="container">
      <section class="overview-section">
        <div class="section-header">
          <h2>项目介绍</h2>
          <div class="section-line"></div>
        </div>
        
        <div class="overview-content">
          <div class="content-text">
            <p>增强型全球生物多样性AI守护者是一个大型综合性平台，致力于利用前沿人工智能技术保护全球生物多样性。本项目结合了深度学习、计算机视觉、大数据分析和物联网技术，构建了一个覆盖全球的生态监测与保护系统。</p>
            <p>通过部署在各类生态系统中的智能监测设备，结合卫星遥感数据，我们的AI系统能够实时监测、分析和预测生物多样性变化趋势，为濒危物种保护和生态系统健康评估提供科学依据。</p>
            <div class="stats-highlight">
              <div class="stat-item">
                <div class="stat-number">5年</div>
                <div class="stat-text">研发历程</div>
              </div>
              <div class="stat-item">
                <div class="stat-number">100+</div>
                <div class="stat-text">国家覆盖</div>
              </div>
              <div class="stat-item">
                <div class="stat-number">500+</div>
                <div class="stat-text">合作机构</div>
              </div>
            </div>
          </div>
          <div class="content-image">
            <img src="@/assets/Picture/项目概览/9a8fe4be-ce73-4418-91e5-a14efc07ab5a.jpeg" alt="项目概述">
          </div>
        </div>
      </section>

      <section class="overview-section">
        <div class="section-header">
          <h2>项目目标</h2>
          <div class="section-line"></div>
        </div>
        
        <div class="goals-grid">
          <div class="goal-card">
            <div class="goal-icon">🌍</div>
            <h3>建立全球监测网络</h3>
            <p>在全球范围内部署智能监测系统，构建生物多样性数据库，实现对生态系统的实时监控。</p>
          </div>
          
          <div class="goal-card">
            <div class="goal-icon">🔬</div>
            <h3>物种保护与研究</h3>
            <p>重点关注濒危物种及其栖息地，开展深入研究，制定科学保护方案，阻止生物多样性丧失。</p>
          </div>
          
          <div class="goal-card">
            <div class="goal-icon">🤝</div>
            <h3>促进全球合作</h3>
            <p>连接全球科研机构、保护组织和政府部门，共享数据和资源，协同推进生物多样性保护。</p>
          </div>
          
          <div class="goal-card">
            <div class="goal-icon">📊</div>
            <h3>数据驱动决策</h3>
            <p>基于海量生态数据和AI分析，为生态保护决策提供科学依据，提高保护行动的有效性。</p>
          </div>
        </div>
      </section>

      <section class="overview-section">
        <div class="section-header">
          <h2>应用场景</h2>
          <div class="section-line"></div>
        </div>
        
        <div class="applications-content">
          <div class="application-item">
            <div class="application-image">
              <img src="@/assets/Picture/项目概览/f89e8c3f-c8ef-4e3c-9d05-500fde5f8f62.jpeg" alt="热带雨林保护">
            </div>
            <div class="application-details">
              <h3>热带雨林保护</h3>
              <p>在亚马逊、刚果盆地等世界重要雨林区域部署AI监测系统，实时识别非法砍伐活动，监测物种分布变化，评估森林健康状况。我们的系统已成功帮助当地保护区减少40%的非法活动。</p>
            </div>
          </div>
          
          <div class="application-item reverse">
            <div class="application-image">
              <img src="@/assets/Picture/项目概览/cbddebbecZkvUMRgtkDrzkSdwkpKDQFF.jpeg" alt="珊瑚礁监测">
            </div>
            <div class="application-details">
              <h3>珊瑚礁监测</h3>
              <p>通过水下智能传感器和自主潜水机器人，持续监测全球珊瑚礁健康状况，识别白化现象，预警海洋酸化风险。我们的早期预警系统帮助大堡礁保护区提前30天预测到了潜在的白化风险。</p>
            </div>
          </div>
          
          <div class="application-item">
            <div class="application-image">
              <img src="@/assets/Picture/项目概览/fcbbecaadedabaFzjZNzqRjFlZrtlZwa.jpeg" alt="濒危物种保护">
            </div>
            <div class="application-details">
              <h3>濒危物种保护</h3>
              <p>针对全球濒危物种，部署专项监测与保护计划，实时追踪个体活动，分析种群动态，预测威胁因素。在非洲象保护项目中，我们的AI系统帮助巡护队提高了60%的反偷猎效率。</p>
            </div>
          </div>
        </div>
      </section>

      <section class="overview-section">
        <div class="section-header">
          <h2>合作伙伴</h2>
          <div class="section-line"></div>
        </div>
        
        <div class="partners-grid">
          <div class="partner-logo">WWF</div>
          <div class="partner-logo">UNESCO</div>
          <div class="partner-logo">Conservation International</div>
          <div class="partner-logo">UNEP</div>
          <div class="partner-logo">National Geographic</div>
          <div class="partner-logo">IUCN</div>
        </div>
        
        <div class="action-button">
          <router-link to="/ai-guardian" class="btn-primary">探索AI守护者 &rarr;</router-link>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProjectOverview',
  components: {
  }
}
</script>

<style scoped>
.project-overview {
  width: 100%;
}

.page-banner {
  background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.7)), 
              url('@/assets/Picture/项目概览/c14c8985-845c-4f71-ab76-bb94e99a720b.jpeg') no-repeat center center;
  background-size: cover;
  height: 250px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
}

.page-banner h1 {
  font-size: 3rem;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 50px 20px;
}

.overview-section {
  margin-bottom: 70px;
}

.section-header {
  text-align: center;
  margin-bottom: 40px;
}

.section-header h2 {
  font-size: 2.2rem;
  color: #2c3e50;
  margin-bottom: 15px;
}

.section-line {
  width: 80px;
  height: 4px;
  background-color: #42b983;
  margin: 0 auto;
}

.overview-content {
  display: flex;
  align-items: center;
  gap: 40px;
}

.content-text {
  flex: 1;
}

.content-text p {
  margin-bottom: 1.2rem;
  line-height: 1.7;
  color: #333;
}

.content-image {
  flex: 1;
}

.content-image img {
  width: 100%;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.stats-highlight {
  display: flex;
  justify-content: space-between;
  margin-top: 30px;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 2.5rem;
  font-weight: bold;
  color: #42b983;
}

.stat-text {
  color: #666;
}

.goals-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 30px;
}

.goal-card {
  background-color: #f8f9fa;
  padding: 30px;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.05);
  transition: transform 0.3s ease;
}

.goal-card:hover {
  transform: translateY(-5px);
}

.goal-icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
}

.goal-card h3 {
  margin-bottom: 15px;
  color: #2c3e50;
}

.goal-card p {
  color: #555;
  line-height: 1.6;
}

.applications-content {
  display: flex;
  flex-direction: column;
  gap: 50px;
}

.application-item {
  display: flex;
  gap: 30px;
}

.application-item.reverse {
  flex-direction: row-reverse;
}

.application-image {
  flex: 1;
}

.application-image img {
  width: 100%;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.application-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.application-details h3 {
  font-size: 1.8rem;
  margin-bottom: 15px;
  color: #2c3e50;
}

.application-details p {
  line-height: 1.7;
  color: #444;
}

.partners-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.partner-logo {
  background-color: #f8f9fa;
  height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: bold;
  color: #2c3e50;
  border-radius: 5px;
}

.action-button {
  text-align: center;
  margin-top: 40px;
}

.btn-primary {
  background-color: #42b983;
  color: white;
  text-decoration: none;
  padding: 12px 30px;
  border-radius: 5px;
  font-weight: 600;
  transition: background-color 0.3s ease;
}

.btn-primary:hover {
  background-color: #3aa876;
}

@media (max-width: 768px) {
  .overview-content {
    flex-direction: column;
  }
  
  .application-item, .application-item.reverse {
    flex-direction: column;
  }
  
  .stats-highlight {
    flex-wrap: wrap;
    gap: 20px;
  }
  
  .stat-item {
    width: 30%;
  }
}
</style> 