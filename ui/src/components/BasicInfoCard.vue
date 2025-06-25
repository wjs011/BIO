<template>
  <div class="basic-info-card">
    <img :src="animal.img" :alt="animal.species" class="animal-img" />
    <div class="info-content">
      <div class="info-row">
        <span class="info-label">ID：</span>
        <span class="info-value">{{ animal.id }}</span>
      </div>
      <div class="info-row">
        <span class="info-label">物种：</span>
        <span class="info-value">{{ animal.species }}</span>
      </div>
      <div class="info-row">
        <span class="info-label">预估年龄：</span>
        <span class="info-value">{{ animal.age }}</span>
      </div>
      <div class="info-row">
        <span class="info-label">健康状况：</span>
        <span class="health-tag">健康</span>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  animal: {
    type: Object,
    default: () => ({})
  }
});
</script>

<style scoped>
.basic-info-card {
  display: flex;
  align-items: center;
  background: rgba(30,40,35,0.96);
  border-radius: 18px;
  box-shadow: 0 2px 24px 0 #0f2d1a33;
  padding: 24px 32px;
  margin-bottom: 12px;
  min-height: 120px;
  gap: 32px;
  border: 1.5px solid rgba(57,255,20,0.13);
  animation: fadeIn 0.7s cubic-bezier(.4,2,.6,1);
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: none; }
}
.animal-img {
  width: 88px;
  height: 88px;
  object-fit: cover;
  border-radius: 16px;
  box-shadow: 0 0 16px 2px #39ff1444;
  border: 2px solid #222;
  background: #181a1b;
}
.info-content {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.info-row {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 1.08rem;
  color: #fff;
}
.info-label {
  color: #b0b0b0;
  font-weight: 500;
}
.info-value {
  color: #fff;
  font-weight: 600;
  letter-spacing: 1px;
}
.health-tag {
  background: linear-gradient(90deg, #39ff14 60%, #39ff1488 100%);
  color: #fff;
  font-weight: 700;
  border-radius: 8px;
  padding: 2px 16px;
  margin-left: 4px;
  box-shadow: 0 0 8px 2px #39ff14cc;
  text-shadow: 0 0 6px #39ff14cc;
  font-size: 1.02rem;
  letter-spacing: 1px;
  animation: healthGlow 1.5s infinite alternate;
}
@keyframes healthGlow {
  from { box-shadow: 0 0 8px 2px #39ff14cc; }
  to { box-shadow: 0 0 16px 4px #39ff14cc; }
}
</style> 