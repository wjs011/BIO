import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  },
  {
    path: '/technique',
    name: 'technique',
    component: () => import(/* webpackChunkName: "technique" */ '../views/Technique.vue')
  },
  {
    path: '/project-overview',
    name: 'project-overview',
    component: () => import(/* webpackChunkName: "project-overview" */ '../views/ProjectOverview.vue')
  },
  {
    path: '/ai-engine',
    name: 'ai-engine',
    component: () => import(/* webpackChunkName: "ai-engine" */ '../views/AIGuardianEngine.vue')
  },
  {
    path: '/map',
    name: 'map',
    component: () => import(/* webpackChunkName: "map" */ '../views/Map.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router