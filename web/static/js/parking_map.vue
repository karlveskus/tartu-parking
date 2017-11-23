<template>
  <div class="google-map" :id="mapName"></div>
</template>

<script>
export default {
  name: 'parking-map',
  data: function () {
    return {
      mapName: this.name + "-map",
    }
  },
  mounted: function () {
    const element = document.getElementById(this.mapName)
    const options = {
      zoom: 14,
      center: new google.maps.LatLng(58.378025,26.728493)
    }
    const map = new google.maps.Map(element, options);
    
  }
};
</script>

<style scoped>
.google-map {
  width: 100%;
  height: 100%;
  background: gray;
}
</style>