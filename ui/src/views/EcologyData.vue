<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const animalData = ref([]);
const loading = ref(true);
const error = ref('');
const speciesStats = ref({});
const selectedSpecies = ref(''); // Track selected species

// Navigate to the map view
const navigateToMap = () => {
  router.push('/map-view');
};

// Fetch all tracking data
const fetchAllTrackingData = async () => {
  loading.value = true;
  error.value = '';
  
  try {
    const response = await axios.get('/api/tracking/all', {
      timeout: 10000 
    });
    
    if (response.data && Array.isArray(response.data)) {
      animalData.value = response.data;
      calculateStats(response.data);
    } else {
      error.value = '数据格式不正确';
    }
  } catch (err) {
    console.error('获取数据失败:', err);
    error.value = err.response ? `服务器错误: ${err.response.status}` : '无法连接到服务器';
  } finally {
    loading.value = false;
  }
};

// Calculate statistics from tracking data
const calculateStats = (data) => {
  const stats = {};
  
  data.forEach(item => {
    if (!stats[item.species]) {
      stats[item.species] = {
        count: 0,
        locations: new Set(),
        animalIds: new Set()
      };
    }
    
    stats[item.species].count += 1;
    if (item.location) stats[item.species].locations.add(item.location);
    if (item.animalId) stats[item.species].animalIds.add(item.animalId);
  });
  
  // Convert sets to counts for display
  Object.keys(stats).forEach(species => {
    stats[species].locationCount = stats[species].locations.size;
    stats[species].animalCount = stats[species].animalIds.size;
    delete stats[species].locations;
    delete stats[species].animalIds;
  });
  
  speciesStats.value = stats;
};

// Format date for display
const formatDate = (dateString) => {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleString();
};

// Select or deselect a species
const toggleSpeciesSelection = (species) => {
  if (selectedSpecies.value === species) {
    selectedSpecies.value = ''; // Deselect if already selected
  } else {
    selectedSpecies.value = species; // Select the species
  }
};

// Filter data based on selected species
const filteredAnimalData = computed(() => {
  if (!selectedSpecies.value) {
    return animalData.value;
  }
  return animalData.value.filter(item => item.species === selectedSpecies.value);
});

// Get display data for table with pagination
const displayData = computed(() => {
  return filteredAnimalData.value.slice(0, 10);
});

// Compute the total records count
const totalRecords = computed(() => {
  return filteredAnimalData.value.length;
});

onMounted(() => {
  fetchAllTrackingData();
});
</script>

<template>
  <div class="ecology-data-container">
    <div class="header">
      <h1>生态监测数据中心</h1>
      <button class="map-button" @click="navigateToMap">
        <span class="map-icon">🗺️</span>
        查看迁徙地图
      </button>
    </div>
    
    <div class="data-summary-container" v-if="!loading && !error">
      <div class="summary-card">
        <h2>数据概览</h2>
        <div class="stats">
          <div class="stat-item">
            <div class="stat-value">{{ animalData.length }}</div>
            <div class="stat-label">数据点总数</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">{{ Object.keys(speciesStats).length }}</div>
            <div class="stat-label">监测物种</div>
          </div>
        </div>
      </div>
      
      <div class="species-cards">
        <div class="species-header">
          <h2>物种分布</h2>
          <div v-if="selectedSpecies" class="filter-indicator">
            正在查看: {{ selectedSpecies }} 
            <button class="clear-filter" @click="selectedSpecies = ''">查看全部</button>
          </div>
        </div>
        <div class="cards-grid">
          <div 
            v-for="(stats, species) in speciesStats" 
            :key="species" 
            class="species-card" 
            :class="{ 'selected': selectedSpecies === species }"
            @click="toggleSpeciesSelection(species)"
          >
            <div class="species-icon">{{ getAnimalEmoji(species) }}</div>
            <h3>{{ species }}</h3>
            <div class="species-stats">
              <div class="species-stat">
                <span class="label">跟踪数据点:</span>
                <span class="value">{{ stats.count }}</span>
              </div>
              <div class="species-stat">
                <span class="label">独立个体数:</span>
                <span class="value">{{ stats.animalCount }}</span>
              </div>
              <div class="species-stat">
                <span class="label">监测区域:</span>
                <span class="value">{{ stats.locationCount }}</span>
              </div>
            </div>
            <div class="card-overlay">
              <span class="click-hint">点击查看详情</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <div class="recent-data" v-if="!loading && !error">
      <h2>
        {{ selectedSpecies ? `${selectedSpecies} 迁徙数据` : '最近迁徙数据' }}
        <span class="data-count">(共 {{ totalRecords }} 条记录)</span>
      </h2>
      <div class="table-container">
        <table>
          <thead>
            <tr>
              <th>物种</th>
              <th>个体ID</th>
              <th>位置</th>
              <th>时间</th>
              <th>坐标</th>
            </tr>
          </thead>
          <tbody class="animated-tbody">
            <tr 
              v-for="(item, index) in displayData" 
              :key="item.id || index"
              @click="toggleSpeciesSelection(item.species)"
              :class="{ 
                'clickable-row': true,
                'selected-row': selectedSpecies && item.species === selectedSpecies 
              }"
            >
              <td>
                <span class="animal-emoji">{{ getAnimalEmoji(item.species) }}</span>
                {{ item.species }}
              </td>
              <td>{{ item.animalId }}</td>
              <td>{{ item.location || 'N/A' }}</td>
              <td>{{ formatDate(item.timestamp) }}</td>
              <td>{{ item.latitude }}, {{ item.longitude }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="no-data" v-if="displayData.length === 0">
        暂无数据
      </div>
    </div>
    
    <div class="loading-container" v-if="loading">
      <div class="loading-spinner"></div>
      <p>加载数据中...</p>
    </div>
    
    <div class="error-container" v-if="error">
      <p class="error-message">{{ error }}</p>
      <button class="retry-button" @click="fetchAllTrackingData">重试</button>
    </div>
  </div>
</template>

<script>
// Helper function to get animal emoji based on species name
function getAnimalEmoji(species) {
  if (!species) return '🐾';
  
  const speciesLower = species.toLowerCase();
  const emojiMap = {
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
  
  for (const [key, emoji] of Object.entries(emojiMap)) {
    if (speciesLower.includes(key)) {
      return emoji;
    }
  }
  
  return '🐾';
}

export default {
  methods: {
    getAnimalEmoji
  }
}
</script>

<style scoped>
.ecology-data-container {
  padding: 20px;
  margin-top: 60px;
  background-color: #f7fcf7;
  min-height: calc(100vh - 60px);
  font-family: 'Helvetica Neue', Arial, sans-serif;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

h1 {
  color: #2e7d32;
  font-size: 28px;
  position: relative;
}

h1:after {
  content: '';
  position: absolute;
  left: 0;
  bottom: -8px;
  width: 60px;
  height: 4px;
  background-color: #4caf50;
  border-radius: 2px;
}

h2 {
  color: #2e7d32;
  font-size: 22px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.data-count {
  font-size: 14px;
  color: #666;
  margin-left: 10px;
  font-weight: normal;
}

.map-button {
  display: flex;
  align-items: center;
  padding: 10px 20px;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 30px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
}

.map-button:hover {
  background-color: #388e3c;
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(76, 175, 80, 0.4);
}

.map-button:active {
  transform: translateY(1px);
  box-shadow: 0 3px 6px rgba(76, 175, 80, 0.3);
}

.map-icon {
  font-size: 20px;
  margin-right: 10px;
}

.data-summary-container {
  display: flex;
  flex-direction: column;
  gap: 30px;
  margin-bottom: 30px;
}

.summary-card {
  background-color: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  border-left: 5px solid #4caf50;
}

.stats {
  display: flex;
  gap: 30px;
  margin-top: 20px;
}

.stat-item {
  background-color: #e8f5e9;
  padding: 20px;
  border-radius: 10px;
  text-align: center;
  transition: transform 0.2s ease;
  flex: 1;
}

.stat-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 12px rgba(76, 175, 80, 0.15);
}

.stat-value {
  font-size: 36px;
  font-weight: bold;
  color: #2e7d32;
}

.stat-label {
  font-size: 14px;
  color: #555;
  margin-top: 5px;
}

.species-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filter-indicator {
  display: flex;
  align-items: center;
  background-color: #e8f5e9;
  padding: 8px 15px;
  border-radius: 20px;
  font-size: 14px;
  color: #2e7d32;
  font-weight: 500;
}

.clear-filter {
  margin-left: 10px;
  background: #4caf50;
  border: none;
  color: white;
  padding: 3px 8px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  transition: all 0.2s;
}

.clear-filter:hover {
  background: #388e3c;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}

.species-card {
  background-color: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
}

.species-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.species-card:hover .species-icon {
  transform: scale(1.1);
}

.species-card.selected {
  border-color: #4caf50;
  box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.3), 0 8px 20px rgba(0, 0, 0, 0.1);
}

.card-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(46, 125, 50, 0);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s ease;
}

.species-card:hover .card-overlay {
  background-color: rgba(46, 125, 50, 0.1);
  opacity: 1;
}

.click-hint {
  background-color: rgba(255, 255, 255, 0.9);
  color: #2e7d32;
  padding: 5px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.species-icon {
  font-size: 32px;
  margin-bottom: 10px;
  transition: transform 0.3s ease;
}

.species-stats {
  margin-top: 15px;
}

.species-stat {
  display: flex;
  justify-content: space-between;
  padding: 5px 0;
  border-bottom: 1px dotted #e0e0e0;
}

.species-stat:last-child {
  border-bottom: none;
}

.label {
  color: #555;
  font-size: 14px;
}

.value {
  font-weight: 600;
  color: #2e7d32;
}

.recent-data {
  background-color: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  margin-bottom: 30px;
}

.table-container {
  overflow-x: auto;
  margin-top: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}

th {
  background-color: #e8f5e9;
  color: #2e7d32;
  padding: 12px 15px;
  font-weight: 600;
}

td {
  padding: 12px 15px;
  border-bottom: 1px solid #e0e0e0;
}

tr:last-child td {
  border-bottom: none;
}

tr:hover {
  background-color: #f5f5f5;
}

.clickable-row {
  cursor: pointer;
  transition: all 0.2s ease;
}

.clickable-row:hover {
  background-color: #e8f5e9;
}

.selected-row {
  background-color: #e8f5e9;
  font-weight: 500;
}

.selected-row td {
  border-bottom: 1px solid #a5d6a7;
}

.animal-emoji {
  font-size: 18px;
  margin-right: 8px;
  vertical-align: middle;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 300px;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 3px solid #e0e0e0;
  border-top: 3px solid #4caf50;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

.no-data {
  text-align: center;
  padding: 30px;
  color: #666;
  font-style: italic;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-container {
  text-align: center;
  padding: 30px;
  background-color: #fff5f5;
  border-radius: 10px;
  border-left: 5px solid #e53935;
}

.error-message {
  color: #c62828;
  font-weight: 500;
  margin-bottom: 20px;
}

.retry-button {
  padding: 10px 20px;
  background-color: #e53935;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.2s;
}

.retry-button:hover {
  background-color: #d32f2f;
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .map-button {
    margin-top: 15px;
  }
  
  .stats {
    flex-direction: column;
    gap: 15px;
  }
  
  .cards-grid {
    grid-template-columns: 1fr;
  }
  
  .species-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .filter-indicator {
    margin-top: 10px;
  }
}

.animated-tbody {
  transition: all 0.4s ease;
}

.animated-tbody tr {
  animation: fadeIn 0.5s ease;
  transition: all 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style> 