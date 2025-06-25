<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue';
import axios from 'axios';

const mapContainer = ref(null);
const map = ref(null);
let AMap = null; // Changed to let instead of const with window.AMap
const trackingData = ref([]);
const selectedSpecies = ref('');
const selectedSpeciesId = ref('');
const selectedAnimalId = ref('');
const availableSpecies = ref([]);
const availableSpeciesIds = ref({});
const availableAnimalIds = ref({});
const polylines = ref([]);
const mapLoaded = ref(false); // Track if map has been loaded
const loadingData = ref(false); // Track if data is being loaded
const errorMessage = ref(''); // 添加错误信息显示

// 添加侧边栏宽度调整相关变量
const sidebar = ref(null);
const isDragging = ref(false);
const initialWidth = ref(350);

// 侧边栏拖拽开始函数
const startResizing = (event) => {
  isDragging.value = true;
  document.addEventListener('mousemove', resize);
  document.addEventListener('mouseup', stopResizing);
};

// 侧边栏拖拽改变大小函数
const resize = (event) => {
  if (!isDragging.value || !sidebar.value) return;
  
  const newWidth = event.clientX - sidebar.value.getBoundingClientRect().left;
  
  // 应用最小/最大宽度限制
  if (newWidth < 250) return;
  if (newWidth > window.innerWidth * 0.5) return;
  
  sidebar.value.style.width = `${newWidth}px`;
};

// 侧边栏拖拽结束函数
const stopResizing = () => {
  isDragging.value = false;
  document.removeEventListener('mousemove', resize);
  document.removeEventListener('mouseup', stopResizing);
  
  // 地图可能需要重新渲染来适应新的容器大小
  if (map.value) {
    map.value.resize();
  }
};

// Check if API key is properly set
const isApiKeySet = computed(() => {
  return process.env.VUE_APP_AMAP_KEY && process.env.VUE_APP_AMAP_KEY !== 'YOUR_AMAP_KEY_HERE';
});

// Fetch available species and their IDs
const fetchAvailableSpecies = async () => {
  loadingData.value = true;
  errorMessage.value = ''; // 清除错误信息
  
  try {
    console.log('开始请求所有动物追踪数据');
    // 使用/api前缀以正确经过代理
    const response = await axios.get('/api/tracking/all', {
      timeout: 10000 // 设置超时时间
    });
    console.log('获取到的数据:', response.data);
    
    const data = response.data;
    
    if (!data || data.length === 0) {
      errorMessage.value = '未获取到动物追踪数据，请确认后端服务是否正常运行';
      return;
    }
    
    // 提取唯一物种
    const speciesSet = new Set();
    const speciesIdsMap = {};
    const animalIdsMap = {};
    
    data.forEach(item => {
      speciesSet.add(item.species);
      
      if (!speciesIdsMap[item.species]) {
        speciesIdsMap[item.species] = new Set();
        animalIdsMap[item.species] = {};
      }
      
      speciesIdsMap[item.species].add(item.speciesId);
      
      // 为每个物种和物种ID组合跟踪动物ID
      if (!animalIdsMap[item.species][item.speciesId]) {
        animalIdsMap[item.species][item.speciesId] = new Set();
      }
      animalIdsMap[item.species][item.speciesId].add(item.animalId);
    });
    
    availableSpecies.value = Array.from(speciesSet);
    
    // 将Set转换为每个物种的数组
    Object.keys(speciesIdsMap).forEach(species => {
      speciesIdsMap[species] = Array.from(speciesIdsMap[species]);
      
      // 将Set转换为每个动物ID的数组
      if (animalIdsMap[species]) {
        Object.keys(animalIdsMap[species]).forEach(speciesId => {
          animalIdsMap[species][speciesId] = Array.from(animalIdsMap[species][speciesId]);
        });
      }
    });
    
    availableSpeciesIds.value = speciesIdsMap;
    availableAnimalIds.value = animalIdsMap;
    
    // 如果有可用的设置默认选择
    if (availableSpecies.value.length > 0) {
      selectedSpecies.value = availableSpecies.value[0];
      if (availableSpeciesIds.value[selectedSpecies.value]?.length > 0) {
        selectedSpeciesId.value = availableSpeciesIds.value[selectedSpecies.value][0];
        if (availableAnimalIds.value[selectedSpecies.value]?.[selectedSpeciesId.value]?.length > 0) {
          selectedAnimalId.value = availableAnimalIds.value[selectedSpecies.value][selectedSpeciesId.value][0];
          await fetchTrackingData();
        }
      }
    }
  } catch (error) {
    console.error('获取可用物种时出错:', error);
    errorMessage.value = `获取数据失败: ${error.message}`;
    if (error.response) {
      console.error('错误响应数据:', error.response.data);
      console.error('错误状态码:', error.response.status);
    } else if (error.request) {
      console.error('未收到响应:', error.request);
      errorMessage.value = '后端服务器未响应，请检查后端是否启动';
    }
  } finally {
    loadingData.value = false;
  }
};

// Fetch tracking data for a specific species, speciesId and animalId
const fetchTrackingData = async () => {
  if (!selectedSpecies.value || !selectedSpeciesId.value || !selectedAnimalId.value) return;
  
  loadingData.value = true;
  errorMessage.value = ''; // 清除错误信息
  
  try {
    console.log(`获取动物追踪数据: ${selectedSpecies.value}/${selectedSpeciesId.value}/${selectedAnimalId.value}`);
    // 使用/api前缀以正确经过代理
    const response = await axios.get(`/api/tracking/species/${selectedSpecies.value}/id/${selectedSpeciesId.value}/animal/${selectedAnimalId.value}`, {
      timeout: 10000 // 设置超时时间
    });
    console.log('获取到的追踪数据:', response.data);
    
    trackingData.value = response.data;
    
    // Display tracking data only if map is loaded
    if (mapLoaded.value && map.value) {
      displayTrackingOnMap();
    }
  } catch (error) {
    console.error('获取追踪数据时出错:', error);
    errorMessage.value = `获取追踪数据失败: ${error.message}`;
    if (error.response) {
      console.error('错误响应数据:', error.response.data);
      console.error('错误状态码:', error.response.status);
    } else if (error.request) {
      console.error('未收到响应:', error.request);
      errorMessage.value = '后端服务器未响应，请检查后端是否启动';
    }
  } finally {
    loadingData.value = false;
  }
};

// Function to handle species selection change
// 添加动物图标映射
const getAnimalIcon = (species) => {
  // 根据物种名称返回相应图标
  const iconMap = {
    'tiger': '🐅',
    'panda': '🐼',
    'elephant': '🐘',
    'rhino': '🦏',
    'whale': '🐋',
    'dolphin': '🐬',
    'sea turtle': '🐢',
    'polar bear': '🐻‍❄️',
    'wolf': '🐺',
    'eagle': '🦅',
    'leopard': '🐆',
    'gorilla': '🦍',
    'orangutan': '🦧',
    'shark': '🦈',
    'snake': '🐍',
    'crocodile': '🐊',
    'lion': '🦁'
  };
  
  // 转换为小写并尝试匹配
  const lowerSpecies = species?.toLowerCase() || '';
  for (const [key, icon] of Object.entries(iconMap)) {
    if (lowerSpecies.includes(key)) {
      return icon;
    }
  }
  
  // 默认返回一般动物图标
  return '🐾';
};

const handleSpeciesChange = () => {
  // Reset species ID and animal ID when species changes
  selectedSpeciesId.value = availableSpeciesIds.value[selectedSpecies.value]?.[0] || '';
  selectedAnimalId.value = '';
  
  // Set default animal ID if available
  if (selectedSpeciesId.value && availableAnimalIds.value[selectedSpecies.value]?.[selectedSpeciesId.value]?.length > 0) {
    selectedAnimalId.value = availableAnimalIds.value[selectedSpecies.value][selectedSpeciesId.value][0];
  }
  
  fetchTrackingData();
};

// Function to handle species ID selection change
const handleSpeciesIdChange = () => {
  // Reset animal ID when species ID changes
  selectedAnimalId.value = '';
  
  // Set default animal ID if available
  if (availableAnimalIds.value[selectedSpecies.value]?.[selectedSpeciesId.value]?.length > 0) {
    selectedAnimalId.value = availableAnimalIds.value[selectedSpecies.value][selectedSpeciesId.value][0];
  }
  
  fetchTrackingData();
};

// Function to handle animal ID selection change
const handleAnimalIdChange = () => {
  fetchTrackingData();
};

// Generate random color for polylines
const getRandomColor = () => {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
};

// Format coordinate values from any type to a fixed decimal string
const formatCoordinate = (coordinate) => {
  if (coordinate === null || coordinate === undefined) return 'N/A';
  // Handle various types that might come from backend (string, number, etc.)
  const numValue = typeof coordinate === 'string' ? parseFloat(coordinate) : Number(coordinate);
  return isNaN(numValue) ? coordinate.toString() : numValue.toFixed(6);
};

// Function to display tracking data on the map
const displayTrackingOnMap = () => {
  if (!map.value || !AMap) {
    console.error('地图或AMap未加载，无法显示追踪数据');
    return;
  }
   
  // 清除现有线条
  polylines.value.forEach(polyline => {
    try {
      map.value.remove(polyline);
    } catch (e) {
      console.warn('移除旧路线出错:', e);
    }
  });
  polylines.value = [];
  
  if (!trackingData.value || trackingData.value.length < 2) {
    console.log('追踪数据点不足，无法绘制路线');
    return;
  }
  
  try {
    // 按时间戳排序
    const sortedData = [...trackingData.value].sort((a, b) => 
      new Date(a.timestamp) - new Date(b.timestamp)
    );
    
    console.log('排序后的数据点数量:', sortedData.length);
    
    // 所有有效的点位
    const validPoints = [];
    
    // 按天分组追踪点以使用不同颜色
    const trackingByDay = {};
    
    sortedData.forEach(point => {
      if (!point.timestamp || !point.longitude || !point.latitude) {
        console.warn('无效的追踪点数据:', point);
        return;
      }
      
      const date = new Date(point.timestamp).toISOString().split('T')[0];
      if (!trackingByDay[date]) {
        trackingByDay[date] = [];
      }
      
      // 解析经纬度为数字类型
      let longitude, latitude;
      
      try {
        longitude = typeof point.longitude === 'string' ? parseFloat(point.longitude) : Number(point.longitude);
        latitude = typeof point.latitude === 'string' ? parseFloat(point.latitude) : Number(point.latitude);
        
        // 跳过无效坐标
        if (isNaN(longitude) || isNaN(latitude)) {
          console.warn('无效的坐标数据:', point);
          return;
        }
        
        const lngLatPair = [longitude, latitude];
        trackingByDay[date].push(lngLatPair);
        validPoints.push(lngLatPair);
      } catch (err) {
        console.error('处理坐标数据出错:', point, err);
      }
    });
    
    console.log('按天分组的追踪数据:', Object.keys(trackingByDay).length, '天');
    
    // 使用简化的绘制方法
    if (validPoints.length > 0) {
      try {
        // 创建单个折线
        const polyline = new AMap.Polyline({
          path: validPoints,
          strokeColor: '#3498db', 
          strokeWeight: 6,
          strokeOpacity: 0.8,
          zIndex: 100,
          strokeStyle: 'solid',
          lineJoin: 'round'
        });
        
        map.value.add(polyline);
        polylines.value.push(polyline);
        console.log('成功创建主路径折线');
        
        // 添加起点和终点特殊标记
        if (validPoints.length >= 2) {
          const startPoint = validPoints[0];
          const endPoint = validPoints[validPoints.length - 1];
          
          // 起点标记
          const startMarker = new AMap.Marker({
            position: startPoint,
            content: '<div class="custom-marker start-marker">起</div>',
            offset: new AMap.Pixel(-10, -10),
            zIndex: 110
          });
          map.value.add(startMarker);
          polylines.value.push(startMarker);
          
          // 终点标记
          const endMarker = new AMap.Marker({
            position: endPoint,
            content: '<div class="custom-marker end-marker">终</div>',
            offset: new AMap.Pixel(-10, -10),
            zIndex: 110
          });
          map.value.add(endMarker);
          polylines.value.push(endMarker);
          
          console.log('添加起点和终点标记');
        }
        
        // 为每个关键点添加标记（每5个点添加一个)
        validPoints.forEach((point, index) => {
          if (index > 0 && index < validPoints.length - 1 && index % 5 === 0) {
            const marker = new AMap.Marker({
              position: point,
              content: `<div class="custom-marker">${index + 1}</div>`,
              offset: new AMap.Pixel(-10, -10),
              zIndex: 101
            });
            map.value.add(marker);
            polylines.value.push(marker);
          }
        });
        
        // 设置地图以适应所有点
        if (validPoints.length > 0) {
          const bounds = new AMap.Bounds(...calculateBounds(validPoints));
          // 设置视图以包含所有点，添加一些边距
          map.value.setBounds(bounds, false, [50, 50, 50, 50]);
        }
      } catch (err) {
        console.error('创建折线总路径出错:', err);
        errorMessage.value = `创建路线失败: ${err.message}`;
      }
    }
  } catch (error) {
    console.error('在地图上显示追踪数据时出错:', error);
    errorMessage.value = `显示路线失败: ${error.message}`;
  }
};

// 计算边界的辅助函数
const calculateBounds = (points) => {
  if (!points || points.length === 0) {
    return [[0, 0], [0, 0]];
  }
  
  let minLng = Number.MAX_VALUE;
  let minLat = Number.MAX_VALUE;
  let maxLng = -Number.MAX_VALUE;
  let maxLat = -Number.MAX_VALUE;
  
  points.forEach(point => {
    const lng = point[0];
    const lat = point[1];
    
    minLng = Math.min(minLng, lng);
    minLat = Math.min(minLat, lat);
    maxLng = Math.max(maxLng, lng);
    maxLat = Math.max(maxLat, lat);
  });
  
  return [
    [minLng, minLat],  // 西南角
    [maxLng, maxLat]   // 东北角
  ];
};

// Initialize map
const initMap = () => {
  if (!AMap) {
    console.error('AMap未加载');
    errorMessage.value = 'AMap地图API未成功加载';
    return;
  }
  
  try {
    console.log('初始化地图...');
    map.value = new AMap.Map(mapContainer.value, {
      resizeEnable: true,
      zoom: 5,
      center: [116.397428, 39.90923] // 默认中心为北京
    });
    
    // 添加地图控件 - 使用插件方式加载控件
    try {
      // 加载比例尺插件
      AMap.plugin(['AMap.Scale', 'AMap.ToolBar'], () => {
        // 使用插件方式加载控件
        try {
          if (AMap.Scale) {
            const scale = new AMap.Scale();
            map.value.addControl(scale);
            console.log('比例尺控件加载成功');
          }
        } catch (err) {
          console.warn('比例尺控件加载失败:', err);
        }
        
        try {
          if (AMap.ToolBar) {
            const toolbar = new AMap.ToolBar();
            map.value.addControl(toolbar);
            console.log('工具栏控件加载成功');
          }
        } catch (err) {
          console.warn('工具栏控件加载失败:', err);
        }
      });
    } catch (controlError) {
      console.warn('控件加载失败:', controlError);
    }
    
    // 设置地图加载标志
    mapLoaded.value = true;
    console.log('地图初始化完成');
    
    // 地图初始化后加载数据
    fetchAvailableSpecies();
    
    // 如果已加载则显示数据
    if (trackingData.value.length > 0) {
      displayTrackingOnMap();
    }
  } catch (error) {
    console.error('初始化地图时出错:', error);
    errorMessage.value = `地图初始化失败: ${error.message}`;
  }
};

// Load AMap API
const loadAmapAPI = () => {
  return new Promise((resolve, reject) => {
    if (window.AMap) {
      console.log('AMap已存在，直接使用');
      AMap = window.AMap;
      resolve();
      return;
    }
    
    const apiKey = process.env.VUE_APP_AMAP_KEY;
    console.log('加载高德地图API，Key:', apiKey ? '已设置' : '未设置');
    
    const script = document.createElement('script');
    // 使用来自vue.config.js配置的API密钥，并明确指定插件
    script.src = `https://webapi.amap.com/maps?v=2.0&key=${apiKey}&plugin=AMap.Scale,AMap.ToolBar`;
    script.async = true;
    
    script.onload = () => {
      if (window.AMap) {
        console.log('高德地图API加载成功');
        AMap = window.AMap;
        resolve();
      } else {
        console.error('高德地图API未正确加载');
        reject(new Error('高德地图API未正确加载'));
      }
    };
    
    script.onerror = () => {
      console.error('加载高德地图API失败');
      reject(new Error('加载高德地图API失败'));
    };
    
    document.head.appendChild(script);
  });
};

// 手动重试获取数据
const retryFetch = () => {
  errorMessage.value = '';
  fetchAvailableSpecies();
};

onMounted(async () => {
  try {
    console.log('组件已挂载，开始加载高德地图API');
    await loadAmapAPI();
    initMap();
  } catch (error) {
    console.error('地图加载失败:', error);
    errorMessage.value = `地图API加载失败: ${error.message}`;
  }
});

onBeforeUnmount(() => {
  if (map.value) {
    console.log('组件卸载，销毁地图');
    map.value.destroy();
  }
});
</script>

<template>
  <div class="map-page">
    <div class="main-content">
      <!-- 左侧追踪数据边栏 -->
      <div ref="sidebar" class="sidebar" :class="{ 'has-data': trackingData.length > 0 }">
        <div class="sidebar-resizer" @mousedown="startResizing"></div>
        
        <div class="controls">
          <h3 class="sidebar-title">🌍 野生动物追踪控制台</h3>
          
          <div class="control-group">
            <label for="species">🦁 物种:</label>
            <select id="species" v-model="selectedSpecies" @change="handleSpeciesChange">
              <option v-for="species in availableSpecies" :key="species" :value="species">
                <span v-if="species">{{ getAnimalIcon(species) }}</span> {{ species }}
              </option>
            </select>
          </div>
          
          <div class="control-group">
            <label for="speciesId">🔢 物种ID:</label>
            <select id="speciesId" v-model="selectedSpeciesId" @change="handleSpeciesIdChange">
              <option v-for="id in availableSpeciesIds[selectedSpecies] || []" :key="id" :value="id">
                {{ id }}
              </option>
            </select>
          </div>

          <div class="control-group">
            <label for="animalId">🏷️ 动物ID:</label>
            <select id="animalId" v-model="selectedAnimalId" @change="handleAnimalIdChange">
              <option v-for="id in availableAnimalIds[selectedSpecies]?.[selectedSpeciesId] || []" :key="id" :value="id">
                {{ id }}
              </option>
            </select>
          </div>

          <div class="control-group">
            <button @click="retryFetch" class="retry-button">重新获取数据</button>
          </div>
        </div>
        
        <div class="tracking-info" v-if="trackingData.length > 0">
          <h3 class="tracking-header">
            <span class="animal-icon">{{ getAnimalIcon(selectedSpecies) }}</span>
            {{ selectedSpecies }} (ID: {{ selectedAnimalId }}) 的追踪数据
          </h3>
          <div class="info-table-container">
            <table>
              <thead>
                <tr>
                  <th>⏱️ 时间</th>
                  <th>📍 位置</th>
                  <th>🧭 坐标</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(point, index) in trackingData" :key="index">
                  <td>{{ new Date(point.timestamp).toLocaleString() }}</td>
                  <td>{{ point.location }}</td>
                  <td>{{ formatCoordinate(point.latitude) }}, {{ formatCoordinate(point.longitude) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- 右侧地图区域 -->
      <div class="map-area">
        <div class="error-message" v-if="errorMessage">
          <p>❌ {{ errorMessage }}</p>
        </div>

        <div class="api-key-reminder" v-if="!isApiKeySet">
          <p>⚠️ 请在ui/vue.config.js文件中更新高德地图API密钥后再使用地图。</p>
        </div>

        <div class="loading" v-if="loadingData">
          <span class="loading-icon">🔄</span> 数据加载中...
        </div>
        
        <div ref="mapContainer" class="map-container">
          <div class="eco-tips" v-if="trackingData.length > 0">
            追踪珍稀野生动物的迁徙路线对于生态保护和栖息地保护至关重要。
          </div>
          <div class="eco-badge">生物多样性保护项目</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.map-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px); /* 减去顶栏高度 */
  padding: 20px;
  margin-top: 60px; /* 为顶栏预留空间 */
  background-color: #f0f8f4; /* 更改为淡绿色调背景 */
  font-family: 'Helvetica Neue', Arial, sans-serif;
}

.main-content {
  display: flex;
  flex: 1;
  height: 100%;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border-radius: 12px;
  background-color: #fff;
}

/* 左侧边栏样式 */
.sidebar {
  width: 350px;
  min-width: 250px;
  max-width: 50%;
  overflow-y: auto;
  background-color: #ffffff;
  border-radius: 12px 0 0 12px;
  box-shadow: 3px 0 10px rgba(0, 0, 0, 0.05);
  position: relative;
  padding: 20px;
  transition: all 0.3s ease;
  margin-right: 1px;
  border-right: 1px solid #d7e8d0; /* 淡绿色边框 */
}

.sidebar h3 {
  color: #2e7d32; /* 深绿色标题 */
  font-size: 18px;
  margin-top: 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #81c784; /* 绿色底部边框 */
}

/* 拉伸手柄 */
.sidebar-resizer {
  position: absolute;
  right: -5px;
  top: 0;
  width: 10px;
  height: 100%;
  cursor: ew-resize;
  z-index: 10;
}

.sidebar-resizer::after {
  content: '';
  position: absolute;
  top: 50%;
  right: 5px;
  width: 4px;
  height: 40px;
  background-color: #dfe6e9;
  border-radius: 4px;
  transform: translateY(-50%);
  transition: all 0.2s ease;
}

.sidebar-resizer:hover::after {
  background-color: #4caf50; /* 绿色调 */
  box-shadow: 0 0 6px rgba(76, 175, 80, 0.5);
}

/* 右侧地图区域 */
.map-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: #f1f8e9; /* 淡绿色背景 */
  border-radius: 0 12px 12px 0;
  padding: 15px;
}

.controls {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 20px;
  background-color: #e8f5e9; /* 更浅的绿色背景 */
  padding: 15px;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.1);
  border-left: 3px solid #66bb6a; /* 增加绿色左侧边框强调 */
}

.control-group {
  display: flex;
  flex-direction: column;
}

label {
  margin-bottom: 6px;
  font-weight: 600;
  color: #2e7d32; /* 深绿色标签 */
  font-size: 14px;
  letter-spacing: 0.3px;
}

select {
  padding: 10px 12px;
  border-radius: 8px;
  border: 1px solid #dde1e7;
  background-color: #fff;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
  color: #2c3e50;
  font-size: 14px;
  transition: all 0.2s;
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23555' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 10px center;
  padding-right: 30px;
}

select:focus {
  border-color: #4caf50;
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
  outline: none;
}

.map-container {
  flex: 1;
  min-height: 400px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  position: relative;
  border: 1px solid #e6eaf0;
}

.map-container::before {
  content: '🌿 珍稀动物迁徙保护追踪';
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(76, 175, 80, 0.9);
  padding: 8px 15px;
  border-radius: 20px;
  font-weight: bold;
  color: white;
  z-index: 1;
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.3);
  font-size: 14px;
  letter-spacing: 0.5px;
}

.loading {
  padding: 12px;
  background-color: #e8f5e9;
  color: #2e7d32;
  margin: 10px 0;
  border-radius: 8px;
  text-align: center;
  font-weight: bold;
  box-shadow: 0 2px 5px rgba(76, 175, 80, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
}

.loading-icon {
  display: inline-block;
  animation: spin 1.5s infinite linear;
  margin-right: 10px;
  font-size: 18px;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.error-message {
  padding: 12px;
  background-color: #fdf2f3;
  color: #842029;
  margin: 10px 0;
  border-radius: 8px;
  text-align: center;
  font-weight: bold;
  box-shadow: 0 2px 5px rgba(132, 32, 41, 0.1);
  border-left: 4px solid #dc3545;
}

.tracking-info {
  margin-top: 20px;
  border-top: 1px solid #a5d6a7;
  padding-top: 15px;
  position: relative;
}

.tracking-info::before {
  content: '🦁 野生动物保护追踪';
  position: absolute;
  top: -10px;
  left: 50%;
  transform: translateX(-50%);
  background: #ffffff;
  padding: 0 15px;
  font-size: 14px;
  color: #2e7d32;
  font-weight: 600;
}

.info-table-container {
  overflow-x: auto;
  max-height: calc(100vh - 300px);
  overflow-y: auto;
  border-radius: 8px;
  border: 1px solid #a5d6a7; /* 绿色边框 */
  margin-top: 10px;
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.1);
}

table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  margin-top: 0;
  background-color: #fff;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eaeef2;
}

th {
  background-color: #e8f5e9;
  font-weight: 600;
  position: sticky;
  top: 0;
  z-index: 1;
  color: #2e7d32;
  text-transform: uppercase;
  font-size: 12px;
  letter-spacing: 0.5px;
}

tr:last-child td {
  border-bottom: none;
}

tr:hover {
  background-color: #f9fafc;
}

.custom-marker {
  background-color: #fff;
  border: 2px solid #3498db;
  color: #3498db;
  font-weight: bold;
  text-align: center;
  border-radius: 50%;
  width: 22px;
  height: 22px;
  line-height: 22px;
  font-size: 12px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  transition: transform 0.2s;
}

.custom-marker:hover {
  transform: scale(1.2);
}

.start-marker {
  background-color: #2ecc71;
  border-color: #27ae60;
  color: white;
  font-size: 14px;
  width: 28px;
  height: 28px;
  line-height: 28px;
  box-shadow: 0 0 0 4px rgba(46, 204, 113, 0.3);
}

.end-marker {
  background-color: #e74c3c;
  border-color: #c0392b;
  color: white;
  font-size: 14px;
  width: 28px;
  height: 28px;
  line-height: 28px;
  box-shadow: 0 0 0 4px rgba(231, 76, 60, 0.3);
}

.api-key-reminder {
  margin: 15px 0;
  padding: 15px;
  background-color: #fff3cd;
  color: #856404;
  border: 1px solid #ffeeba;
  border-radius: 8px;
  font-weight: bold;
  box-shadow: 0 2px 5px rgba(133, 100, 4, 0.1);
  display: flex;
  align-items: center;
}

.api-key-reminder p::before {
  content: "⚠️";
  margin-right: 8px;
  font-size: 18px;
}

.retry-button {
  padding: 10px 16px;
  background-color: #43a047; /* 绿色按钮 */
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  box-shadow: 0 2px 5px rgba(67, 160, 71, 0.3);
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.retry-button::before {
  content: "🌱";  /* 使用植物图标代替刷新图标 */
  margin-right: 8px;
  font-size: 16px;
}

.retry-button:hover {
  background-color: #388e3c;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(67, 160, 71, 0.4);
}

.retry-button:active {
  transform: translateY(1px);
  box-shadow: 0 2px 3px rgba(67, 160, 71, 0.4);
}

.sidebar-title {
  display: flex;
  align-items: center;
  color: #2e7d32;
  font-size: 18px;
  margin-top: 0;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid #81c784;
}

/* 动物类型图标映射 */
.animal-icon {
  display: inline-block;
  margin-right: 5px;
  font-size: 16px;
}

/* 错误信息样式增强 */
.error-message p {
  display: flex;
  align-items: center;
  justify-content: center;
}

.error-message p::before {
  margin-right: 8px;
}

.tracking-header {
  display: flex;
  align-items: center;
  color: #2e7d32;
  margin-bottom: 15px;
}

.tracking-header .animal-icon {
  font-size: 24px;
  margin-right: 10px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  background-color: #e8f5e9;
  border-radius: 50%;
  box-shadow: 0 2px 5px rgba(76, 175, 80, 0.2);
}

/* 添加生态保护提示框 */
.eco-tips {
  position: absolute;
  bottom: 20px;
  right: 20px;
  background-color: rgba(76, 175, 80, 0.9);
  padding: 12px 20px;
  border-radius: 10px;
  color: white;
  max-width: 300px;
  font-size: 13px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
  z-index: 10;
}

.eco-tips::before {
  content: '💡';
  margin-right: 8px;
  font-size: 16px;
}

/* 生态保护标签 */
.eco-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: #4caf50;
  color: white;
  padding: 5px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
}

.eco-badge::before {
  content: '🌿';
  margin-right: 5px;
}
</style>