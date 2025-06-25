<template>
  <div id="app">
    <header :class="['main-header', { 'nav-hidden': !isNavVisible }]">
      <nav>
        <div class="nav-container">
          <div class="logo">生物多样性AI守护者</div>
          <div class="nav-links">
            <router-link to="/">首页</router-link>
            <router-link to="/ai-engine">AI个体识别引擎</router-link>
            <div class="dropdown" @mouseenter="showDropdown" @mouseleave="hideDropdown">
              <span class="dropdown-title">项目介绍</span>
              <div class="dropdown-content" v-show="dropdownVisible" @mouseenter="showDropdown" @mouseleave="hideDropdown">
                <router-link to="/project-overview">项目概览</router-link>
                <router-link to="/technique">核心技术</router-link>
              </div>
            </div>
            <router-link to="/map">生态地图</router-link>
          </div>
        </div>
      </nav>
    </header>
    <main>
      <router-view/>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const lastScrollY = ref(0)
const isNavVisible = ref(true)

const dropdownVisible = ref(false)
let dropdownTimer = null

const showDropdown = () => {
  clearTimeout(dropdownTimer)
  dropdownVisible.value = true
}
const hideDropdown = () => {
  dropdownTimer = setTimeout(() => {
    dropdownVisible.value = false
  }, 200)
}

const handleScroll = () => {
  const currentScrollY = window.scrollY
  if (currentScrollY <= 0) {
    isNavVisible.value = true
    return
  }
  if (currentScrollY > lastScrollY.value) {
    isNavVisible.value = false
  } else {
    isNavVisible.value = true
  }
  lastScrollY.value = currentScrollY
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})
onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  margin: 0;
  padding: 0;
  background-color: #f5f5f5;
}

body {
  margin: 0;
  padding: 0;
  background-color: #f5f5f5;
}

/* 新增：主导航栏动画样式 */
.main-header {
  position: fixed;
  top: 20px;
  left: 150px;
  right: 150px;
  z-index: 1000;
  background-color: #000000;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  transition: transform 0.3s cubic-bezier(.4,2,.6,1);
}
.main-header.nav-hidden {
  transform: translateY(-120%);
}

nav {
  padding: 0;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
}

.logo {
  font-weight: bold;
  font-size: 1.4rem;
  color: #ffffff;
}

.nav-links {
  display: flex;
  gap: 30px;
  align-items: center;
}

.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-title {
  font-weight: 500;
  color: #f0f0f0;
  cursor: pointer;
  padding: 0 8px;
  transition: color 0.3s ease;
}

.dropdown-title:hover {
  color: #42b983;
}

.dropdown-content {
  position: absolute;
  background-color: rgba(25, 25, 25, 0.9);
  min-width: 120px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.25);
  z-index: 1001;
  flex-direction: column;
  border-radius: 8px;
  margin-top: 8px;
  backdrop-filter: blur(5px);
}

.dropdown-content .router-link-active,
.dropdown-content a:hover {
  color: #42b983;
}

.dropdown:hover .dropdown-content {
  display: flex;
}

.dropdown-content a {
  color: #f0f0f0;
  padding: 10px 16px;
  text-decoration: none;
  display: block;
  transition: background 0.2s;
  border-radius: 4px;
}

.dropdown-content a:hover {
  background: rgba(255, 255, 255, 0.1);
}

.dropdown-content[style*="display: block"],
.dropdown-content[style*="display: flex"],
.dropdown-content[style*="display: inline-block"],
.dropdown-content[style*="display: inline-flex"] {
  display: flex !important;
}

/* Global styles */
h1, h2, h3, h4, h5 {
  margin-top: 0;
}

img {
  max-width: 100%;
}

nav a,
nav a:visited {
  color: #e0e0e0;
  text-decoration: none;
}

nav a.router-link-active {
  color: #42b983;
  text-decoration: none;
}
</style>
