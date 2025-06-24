<template>
  <div id="app">
    <header>
      <nav>
        <div class="nav-container">
          <div class="logo">生物多样性AI守护者</div>
          <div class="nav-links">
            <router-link to="/">首页</router-link>
            <router-link to="/project-overview">项目概览</router-link>
            <router-link to="/technique">核心技术</router-link>
            <router-link to="/ai-guardian">增强型全球生物多样性AI守护者</router-link>
          </div>
        </div>
      </nav>
    </header>
    <main>
      <router-view/>
    </main>
  </div>
</template>

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
}

nav a {
  font-weight: 500;
  color: #2c3e50;
  text-decoration: none;
  transition: color 0.3s ease;
  position: relative;
}

nav a::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 0;
  height: 2px;
  background-color: #42b983;
  transition: width 0.3s ease;
}

nav a:hover {
  color: #42b983;
}

nav a:hover::after,
nav a.router-link-active::after {
  width: 100%;
}

nav a.router-link-active {
  color: #42b983;
}

main {
  padding-top: 80px; /* Add space for fixed header */
  min-height: calc(100vh - 80px);
}

/* Global styles */
h1, h2, h3, h4, h5 {
  margin-top: 0;
}

img {
  max-width: 100%;
}
</style>
