<template>
    <div class="google-map" :id="mapName"></div>
</template>

<script>
export default {
    data: function () {
        return {
            geocoder: new google.maps.Geocoder(),
            mapName: 'parking-map',
            map: undefined,
            address: this.$store.getters.address
        }
    },
    mounted: function () {
        this.map = new google.maps.Map(
            document.getElementById(this.mapName),
            {
                zoom: 14,
                mapTypeControl: false,
                center: new google.maps.LatLng(58.378025,26.728493),
                scaleControl: false,
                streetViewControl: false,
                fullscreenControl: false
            }
        );

        this.geocoder.geocode({'address': this.address}, (results, status) => {
            if (status == google.maps.GeocoderStatus.OK) {
                this.map.setCenter(results[0].geometry.location);
                var marker = new google.maps.Marker({
                    map: this.map,
                    position: results[0].geometry.location
                });
            } else {
                console.log('Geocode was not successful for the following reason: ' + status);
            }
        });
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