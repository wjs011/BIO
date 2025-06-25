<template>
  <div
    class="sample-card"
    :class="{ selected }"
    @click="$emit('click')"
  >
    <img :src="sample.img" :alt="sample.name" class="sample-img" />
    <div class="sample-info">
      <div class="sample-name">{{ sample.name }}</div>
      <div class="sample-desc">{{ sample.desc }}</div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  sample: Object,
  selected: Boolean
});
</script>

<style scoped>
.sample-card {
  display: flex;
  align-items: center;
  background: rgba(30,40,35,0.92);
  border-radius: 16px;
  box-shadow: 0 2px 16px 0 #0f2d1a33;
  border: 2.5px solid transparent;
  padding: 14px 18px;
  cursor: pointer;
  transition: border 0.3s, box-shadow 0.3s, transform 0.25s;
  position: relative;
  min-height: 80px;
}
.sample-card.selected {
  border: 2.5px solid #39ff14;
  box-shadow: 0 0 16px 2px #39ff14cc, 0 2px 16px 0 #0f2d1a33;
  transform: scale(1.04);
  z-index: 2;
}
.sample-card:hover {
  box-shadow: 0 0 12px 2px #39ff1488, 0 2px 16px 0 #0f2d1a33;
  transform: scale(1.03);
}
.sample-img {
  width: 56px;
  height: 56px;
  object-fit: cover;
  border-radius: 12px;
  margin-right: 18px;
  box-shadow: 0 0 8px 0 #39ff1444;
  border: 1.5px solid #222;
  transition: box-shadow 0.3s;
}
.sample-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.sample-name {
  font-size: 1.1rem;
  font-weight: 600;
  color: #fff;
  letter-spacing: 1px;
}
.sample-desc {
  font-size: 0.98rem;
  color: #b0b0b0;
  margin-top: 2px;
}
</style> 