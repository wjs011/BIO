<template>
  <div class="progress-bar-bg">
    <div class="progress-bar-fg" :style="{ width: progress + '%' }">
      <div class="glow"></div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  progress: {
    type: Number,
    default: 0
  }
});
</script>

<style scoped>
.progress-bar-bg {
  width: 100%;
  height: 16px;
  background: #1a2a1e;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 0 8px #39ff1422;
  position: relative;
}
.progress-bar-fg {
  height: 100%;
  background: linear-gradient(90deg, #39ff14 60%, #39ff1466 100%);
  border-radius: 10px;
  box-shadow: 0 0 16px 2px #39ff14cc;
  position: relative;
  transition: width 0.5s cubic-bezier(.4,2,.6,1);
  overflow: visible;
}
.glow {
  position: absolute;
  right: -8px;
  top: 0;
  width: 16px;
  height: 100%;
  background: radial-gradient(circle, #39ff14cc 60%, transparent 100%);
  filter: blur(2px);
  animation: glow-move 1.2s linear infinite;
}
@keyframes glow-move {
  0% { right: -8px; }
  100% { right: 100%; }
}
</style> 