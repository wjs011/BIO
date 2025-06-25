<template>
  <div id="app">
    <header>
      <nav>
        <div class="nav-container">
          <div class="logo">生物多样性AI守护者</div>
          <div class="nav-links">
            <router-link to="/">首页</router-link>
            <div class="dropdown" @mouseenter="showDropdown" @mouseleave="hideDropdown">
              <span class="dropdown-title">项目介绍</span>
              <div class="dropdown-content" v-show="dropdownVisible" @mouseenter="showDropdown" @mouseleave="hideDropdown">
                <router-link to="/project-overview">项目概览</router-link>
                <router-link to="/technique">核心技术</router-link>
              </div>
            </div>
          </div>
        </div>
      </nav>
    </header>
    <main>
      <router-view/>
    </main>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dropdownVisible: false,
      dropdownTimer: null
    }
  },
  methods: {
    showDropdown() {
      clearTimeout(this.dropdownTimer)
      this.dropdownVisible = true
    },
    hideDropdown() {
      this.dropdownTimer = setTimeout(() => {
        this.dropdownVisible = false
      }, 200)
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  margin: 0;
  padding: 0;
}

body {
  margin: 0;
  padding: 0;
  background-color: #f5f5f5;
}

header {
  background-color: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
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
  color: #42b983;
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
  color: #2c3e50;
  cursor: pointer;
  padding: 0 8px;
  transition: color 0.3s ease;
}

.dropdown-title:hover {
  color: #42b983;
}

.dropdown-content {
  position: absolute;
  background-color: #fff;
  min-width: 120px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  z-index: 1001;
  flex-direction: column;
  border-radius: 4px;
  margin-top: 8px;
}

.dropdown-content .router-link-active,
.dropdown-content a:hover {
  color: #42b983;
}

.dropdown:hover .dropdown-content {
  display: flex;
}

.dropdown-content a {
  color: #2c3e50;
  padding: 10px 16px;
  text-decoration: none;
  display: block;
  transition: background 0.2s;
  border-radius: 4px;
}

.dropdown-content a:hover {
  background: #f0f9f5;
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
  color: #2c3e50;
  text-decoration: none;
}

nav a.router-link-active {
  color: #42b983;
  text-decoration: none;
}
</style>
