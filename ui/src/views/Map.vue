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

// Check if API key is properly set
const isApiKeySet = computed(() => {
  return process.env.VUE_APP_AMAP_KEY && process.env.VUE_APP_AMAP_KEY !== 'YOUR_AMAP_KEY_HERE';
});

// Fetch available species and their IDs
const fetchAvailableSpecies = async () => {
  loadingData.value = true;
  try {
    const response = await axios.get('/api/tracking/all');
    const data = response.data;
    
    // Extract unique species
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
      
      // Track animal IDs per species and speciesId combination
      if (!animalIdsMap[item.species][item.speciesId]) {
        animalIdsMap[item.species][item.speciesId] = new Set();
      }
      animalIdsMap[item.species][item.speciesId].add(item.animalId);
    });
    
    availableSpecies.value = Array.from(speciesSet);
    
    // Convert Sets to Arrays for each species
    Object.keys(speciesIdsMap).forEach(species => {
      speciesIdsMap[species] = Array.from(speciesIdsMap[species]);
      
      // Convert Sets to Arrays for each animal ID
      if (animalIdsMap[species]) {
        Object.keys(animalIdsMap[species]).forEach(speciesId => {
          animalIdsMap[species][speciesId] = Array.from(animalIdsMap[species][speciesId]);
        });
      }
    });
    
    availableSpeciesIds.value = speciesIdsMap;
    availableAnimalIds.value = animalIdsMap;
    
    // Set default selection if available
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
    console.error('Error fetching available species:', error);
  } finally {
    loadingData.value = false;
  }
};

// Fetch tracking data for a specific species, speciesId and animalId
const fetchTrackingData = async () => {
  if (!selectedSpecies.value || !selectedSpeciesId.value || !selectedAnimalId.value) return;
  
  loadingData.value = true;
  try {
    const response = await axios.get(`/api/tracking/species/${selectedSpecies.value}/id/${selectedSpeciesId.value}/animal/${selectedAnimalId.value}`);
    trackingData.value = response.data;
    
    // Display tracking data only if map is loaded
    if (mapLoaded.value) {
      displayTrackingOnMap();
    }
  } catch (error) {
    console.error('Error fetching tracking data:', error);
  } finally {
    loadingData.value = false;
  }
};

// Function to handle species selection change
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
  if (!map.value || !AMap) return; // Ensure map and AMap are available
  
  // Clear existing polylines
  polylines.value.forEach(polyline => {
    map.value.remove(polyline);
  });
  polylines.value = [];
  
  if (!trackingData.value || trackingData.value.length < 2) return;
  
  try {
    // Sort data by timestamp
    const sortedData = [...trackingData.value].sort((a, b) => 
      new Date(a.timestamp) - new Date(b.timestamp)
    );
    
    // Group tracking points by day to use different colors
    const trackingByDay = {};
    
    sortedData.forEach(point => {
      if (!point.timestamp || !point.longitude || !point.latitude) return;
      
      const date = new Date(point.timestamp).toISOString().split('T')[0];
      if (!trackingByDay[date]) {
        trackingByDay[date] = [];
      }
      
      // Parse longitude and latitude to numbers in case they're returned as strings
      let longitude, latitude;
      
      try {
        longitude = typeof point.longitude === 'string' ? parseFloat(point.longitude) : Number(point.longitude);
        latitude = typeof point.latitude === 'string' ? parseFloat(point.latitude) : Number(point.latitude);
        
        // Skip invalid coordinates
        if (isNaN(longitude) || isNaN(latitude)) return;
        
        trackingByDay[date].push([longitude, latitude]);
      } catch (err) {
        console.error('Invalid coordinate data:', point, err);
      }
    });
    
    // Create a polyline for each day with different colors
    Object.keys(trackingByDay).forEach(date => {
      const path = trackingByDay[date];
      if (path.length > 1) {
        try {
          const polyline = new AMap.Polyline({
            path: path,
            strokeColor: getRandomColor(),
            strokeWeight: 5,
            strokeOpacity: 0.8,
            zIndex: 100
          });
          
          map.value.add(polyline);
          polylines.value.push(polyline);
          
          // Add marker for each point
          path.forEach((point, index) => {
            const marker = new AMap.Marker({
              position: point,
              content: `<div class="custom-marker">${index + 1}</div>`,
              offset: new AMap.Pixel(-10, -10),
              zIndex: 101
            });
            map.value.add(marker);
            polylines.value.push(marker);
          });
        } catch (err) {
          console.error('Error creating polyline:', err);
        }
      }
    });
    
    // Fit the map to show all points
    if (sortedData.length > 0) {
      try {
        // Convert coordinates to numbers for min/max calculation
        const validPoints = sortedData.filter(p => 
          p.longitude !== null && 
          p.latitude !== null && 
          !isNaN(Number(p.longitude)) && 
          !isNaN(Number(p.latitude))
        );
        
        if (validPoints.length > 0) {
          const longitudes = validPoints.map(p => typeof p.longitude === 'string' ? parseFloat(p.longitude) : Number(p.longitude));
          const latitudes = validPoints.map(p => typeof p.latitude === 'string' ? parseFloat(p.latitude) : Number(p.latitude));
          
          const minLng = Math.min(...longitudes);
          const minLat = Math.min(...latitudes);
          const maxLng = Math.max(...longitudes);
          const maxLat = Math.max(...latitudes);
          
          const bounds = new AMap.Bounds(
            [minLng, minLat],
            [maxLng, maxLat]
          );
          
          // Add padding to bounds
          map.value.setBounds(bounds, false, [50, 50, 50, 50]);
        }
      } catch (err) {
        console.error('Error setting map bounds:', err);
      }
    }
  } catch (error) {
    console.error('Error displaying tracking data on map:', error);
  }
};

// Initialize map
const initMap = () => {
  if (!AMap) {
    console.error('AMap is not loaded');
    return;
  }
  
  try {
    map.value = new AMap.Map(mapContainer.value, {
      resizeEnable: true,
      zoom: 5,
      center: [116.397428, 39.90923] // Beijing as default center
    });
    
    // Add map controls
    map.value.addControl(new AMap.Scale());
    map.value.addControl(new AMap.ToolBar());
    
    // Set map loaded flag
    mapLoaded.value = true;
    
    // Load data after map is initialized
    fetchAvailableSpecies();
    
    // Display data if already loaded
    if (trackingData.value.length > 0) {
      displayTrackingOnMap();
    }
  } catch (error) {
    console.error('Error initializing map:', error);
  }
};

// Load AMap API
const loadAmapAPI = () => {
  return new Promise((resolve, reject) => {
    if (window.AMap) {
      AMap = window.AMap;
      resolve();
      return;
    }
    
    const script = document.createElement('script');
    // Using API key from vue.config.js configuration
    script.src = `https://webapi.amap.com/maps?v=2.0&key=${process.env.VUE_APP_AMAP_KEY}`;
    script.async = true;
    
    script.onload = () => {
      if (window.AMap) {
        AMap = window.AMap;
        resolve();
      } else {
        reject(new Error('AMap not loaded properly'));
      }
    };
    
    script.onerror = () => {
      reject(new Error('Failed to load AMap API'));
    };
    
    document.head.appendChild(script);
  });
};

onMounted(async () => {
  try {
    await loadAmapAPI();
    initMap();
  } catch (error) {
    console.error('Failed to load map:', error);
  }
});

onBeforeUnmount(() => {
  if (map.value) {
    map.value.destroy();
  }
});
</script>

<template>
  <div class="map-page">
    <div class="controls">
      <div class="control-group">
        <label for="species">Species:</label>
        <select id="species" v-model="selectedSpecies" @change="handleSpeciesChange">
          <option v-for="species in availableSpecies" :key="species" :value="species">
            {{ species }}
          </option>
        </select>
      </div>
      
      <div class="control-group">
        <label for="speciesId">Species ID:</label>
        <select id="speciesId" v-model="selectedSpeciesId" @change="handleSpeciesIdChange">
          <option v-for="id in availableSpeciesIds[selectedSpecies] || []" :key="id" :value="id">
            {{ id }}
          </option>
        </select>
      </div>

      <div class="control-group">
        <label for="animalId">Animal ID:</label>
        <select id="animalId" v-model="selectedAnimalId" @change="handleAnimalIdChange">
          <option v-for="id in availableAnimalIds[selectedSpecies]?.[selectedSpeciesId] || []" :key="id" :value="id">
            {{ id }}
          </option>
        </select>
      </div>
    </div>
    
    <div ref="mapContainer" class="map-container"></div>
    
    <div class="api-key-reminder" v-if="!isApiKeySet">
      <p>⚠️ Please update the AMap API key in ui/vue.config.js file before using the map.</p>
    </div>

    <div class="loading" v-if="loadingData">Loading data...</div>
    
    <div class="tracking-info" v-if="trackingData.length > 0">
      <h3>Tracking Data for Animal {{ selectedAnimalId }}</h3>
      <div class="info-table-container">
        <table>
          <thead>
            <tr>
              <th>Time</th>
              <th>Location</th>
              <th>Coordinates</th>
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
</template>

<style scoped>
.map-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  padding: 20px;
}

.controls {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.control-group {
  display: flex;
  flex-direction: column;
  min-width: 200px;
}

label {
  margin-bottom: 5px;
  font-weight: bold;
}

select {
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

.map-container {
  flex: 1;
  min-height: 400px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  position: relative;
}

.loading {
  padding: 10px;
  background-color: #e7f3fe;
  color: #0c63e4;
  margin: 10px 0;
  border-radius: 4px;
  text-align: center;
  font-weight: bold;
}

.tracking-info {
  margin-top: 20px;
}

.info-table-container {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

th, td {
  padding: 8px 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

th {
  background-color: #f5f5f5;
  font-weight: bold;
}

.custom-marker {
  background-color: #fff;
  border: 2px solid #3498db;
  color: #3498db;
  font-weight: bold;
  text-align: center;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  line-height: 20px;
  font-size: 12px;
}

.api-key-reminder {
  margin: 15px 0;
  padding: 12px;
  background-color: #fff3cd;
  color: #856404;
  border: 1px solid #ffeeba;
  border-radius: 4px;
  font-weight: bold;
}
</style>