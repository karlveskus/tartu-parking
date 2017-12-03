<template>
    <div class="wrapper">
        <div class="input-field">
            <input v-model="destionation_address" v-on:keyup.enter="get_parkings" type="text" placeholder="Enter parking address here"/>
            <button v-on:click="get_parkings">Search</button>
        </div>
        <div class="google-map" :id="mapName"></div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data: function () {
        return {
            geocoder: new google.maps.Geocoder(),
            mapName: '#parking-map',
            map: null,
            destionation_address: "",
            destionation_marker: null,
            closes_parkings_markers: []
        }
    },
    methods: {
        get_parkings: function() {
            this.remove_all_markers();

            let url = "/api/parkings?address=" + this.destionation_address

            axios.get(url)
            .then((res) => {
                console.log(res.data);

                res.data.forEach((parking) => {
                    this.geocoder.geocode({'address': parking.address + " Tartu"}, (results, status) => {
                        if (status == google.maps.GeocoderStatus.OK) {
                            this.closes_parkings_markers.push(new google.maps.Marker({
                                map: this.map,
                                position: results[0].geometry.location,
                                label: 'P'
                            }));
                        }
                    });
                });
            })
            .catch((e) => {
                console.log(e)
            })

            this.geocoder.geocode({'address': this.destionation_address + " Tartu"}, (results, status) => {
                if (status == google.maps.GeocoderStatus.OK) {
                    this.map.setCenter(results[0].geometry.location);
                    this.destionation_marker = new google.maps.Marker({
                        map: this.map,
                        position: results[0].geometry.location,
                    });
                } else {
                    console.log('Geocode was not successful for the following reason: ' + status);
                }
            });

        },
        remove_all_markers: function() {
            if (this.destionation_marker) {
                this.destionation_marker.setMap(null);
            }
            this.closes_parkings_markers.map((marker) => marker.setMap(null))
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
    }
};
</script>

<style scoped lang="scss">
div.wrapper {
    height: 100%;

    .input-field {
        padding: 10px;
        position: absolute;
        width: 100%;
        z-index: 1;

        input {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;

            background: #fff;
            border: 1px solid #fff;
            border-radius: 0;
            box-shadow: 0 2px 6px 0px rgba(0, 0, 0, .2);
            box-sizing: border-box;
            color: #929292;
            float: left;
            font: inherit;
            margin: 0;
            outline: 0;
            padding: 10px 10px;
            width: 290px;

            &:active, &:focus {
                border: 1px solid #4a80f5;
                border-right: 0;
            }

            &::-webkit-input-placeholder {
                color: #929292;
            }
        }

        @media (max-width: 768px) {
            input {
                width: calc(100% - 70px);
            }
        }

        button {
            background: #4a80f5;
            border: 0;
            box-shadow: 0 4px 10px -2px rgba(0, 0, 0, .2);
            color: white;
            float: left;
            font-family: inherit;
            font-size: 14px;
            height: 42px;
            outline: 0;
            width: 70px;

            &:hover {
                background: #4273dc;
                cursor: pointer;
            }

            &:active {
                background: #3b66c4;
            }
        }
    }

    .google-map {
        width: 100%;
        height: 100%;
        background: gray;
    }
}
</style>