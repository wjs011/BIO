<template>
  <div class="activity-map">
    <div class="map-title">活动轨迹地图</div>
    <svg class="map-svg" viewBox="0 0 100 100" preserveAspectRatio="none">
      <!-- 轨迹线 -->
      <polyline
        :points="trackPoints"
        class="track-line"
      />
      <!-- 关键点 -->
      <g v-for="(pt, idx) in track" :key="idx">
        <circle :cx="pt.x" :cy="pt.y" r="3.5" class="track-point" />
        <image
          v-if="idx === 0"
          href="https://cdn-icons-png.flaticon.com/512/684/684908.png"
          :x="pt.x - 5"
          :y="pt.y - 12"
          width="10"
          height="10"
        />
        <image
          v-else-if="idx === track.length - 1"
          href="https://cdn-icons-png.flaticon.com/512/684/684908.png"
          :x="pt.x - 5"
          :y="pt.y - 12"
          width="10"
          height="10"
        />
        <image
          v-else
          href="https://cdn-icons-png.flaticon.com/512/616/616408.png"
          :x="pt.x - 5"
          :y="pt.y - 12"
          width="10"
          height="10"
        />
      </g>
      <!-- 动态流光 -->
      <circle
        v-if="track.length > 1"
        :cx="animatedPoint.x"
        :cy="animatedPoint.y"
        r="4.5"
        class="glow-dot"
      />
    </svg>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';
const props = defineProps({
  track: {
    type: Array,
    default: () => []
  }
});

const trackPoints = props.track.map(pt => `${pt.x},${pt.y}`).join(' ');

// 动态流光动画
const animatedPoint = ref({ x: 0, y: 0 });
let animFrame = null;
let t = ref(0);

function interpolateTrack(track, t) {
  if (track.length < 2) return track[0] || { x: 0, y: 0 };
  const total = track.length - 1;
  const idx = Math.floor(t * total);
  const frac = t * total - idx;
  if (idx >= track.length - 1) return track[track.length - 1];
  const p1 = track[idx];
  const p2 = track[idx + 1];
  return {
    x: p1.x + (p2.x - p1.x) * frac,
    y: p1.y + (p2.y - p1.y) * frac
  };
}

function animate() {
  t.value += 0.008;
  if (t.value > 1) t.value = 0;
  animatedPoint.value = interpolateTrack(props.track, t.value);
  animFrame = requestAnimationFrame(animate);
}

onMounted(() => {
  animate();
});
onUnmounted(() => {
  cancelAnimationFrame(animFrame);
});
watch(() => props.track, () => {
  t.value = 0;
});
</script>

<style scoped>
.activity-map {
  background: linear-gradient(120deg, #181a1b 60%, #101c14 100%);
  border-radius: 18px;
  box-shadow: 0 2px 24px 0 #0f2d1a33;
  padding: 24px 32px 18px 32px;
  min-height: 220px;
  margin-bottom: 12px;
  border: 1.5px solid rgba(57,255,20,0.13);
  animation: fadeIn 0.7s cubic-bezier(.4,2,.6,1);
}
.map-title {
  color: #39ff14;
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 10px;
  letter-spacing: 1px;
  text-shadow: 0 0 8px #39ff14cc;
}
.map-svg {
  width: 100%;
  height: 160px;
  background: #181a1b;
  border-radius: 12px;
  box-shadow: 0 0 12px 2px #39ff1422;
  display: block;
}
.track-line {
  fill: none;
  stroke: #39ff14;
  stroke-width: 2.5;
  filter: drop-shadow(0 0 6px #39ff14cc);
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-dasharray: 4 2;
  animation: dashMove 2s linear infinite;
}
@keyframes dashMove {
  to { stroke-dashoffset: 12; }
}
.track-point {
  fill: #39ff14;
  filter: drop-shadow(0 0 6px #39ff14cc);
  opacity: 0.85;
}
.glow-dot {
  fill: #39ff14;
  filter: blur(2px) drop-shadow(0 0 8px #39ff14cc);
  opacity: 0.95;
  animation: glowPulse 1.2s infinite alternate;
}
@keyframes glowPulse {
  from { opacity: 0.7; }
  to { opacity: 1; }
}
</style> 