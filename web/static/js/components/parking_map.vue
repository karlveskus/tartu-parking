<template>
    <div class="wrapper">
        <div class="input-field">
            <input v-model="destionation_address" v-on:keyup.enter="get_parkings"
                id="address-field" type="text" placeholder="Enter parking address here"/>
            <span v-on:click="clear_address" class="clear-input">&times;</span>
            <button v-on:click="get_parkings" id="search-button">Search</button>
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
            closes_parkings_markers: [],
            parking_info_window_hover: null,
            parking_info_window_static: null,
            parking_polygons: [],
        }
    },
    methods: {
        get_parkings: function() {
            document.activeElement.blur();
            if (this.destionation_address === "") return;

            this.remove_all_markers();
            this.remove_all_polygons();

            const url = "/api/parkings?address=" + this.destionation_address

            axios.get(url)
            .then((res) => {
                res.data.forEach((parking) => {
                    this.geocoder.geocode({'address': `${parking.address}, Tartu city, Estonia`}, (results, status) => {
                        if (status == google.maps.GeocoderStatus.OK) {

                            const coords = parking.coordinates
                            
                            const area = new google.maps.Polygon({
                                paths: coords,
                                strokeColor: '#000099',
                                strokeOpacity: 0.8,
                                strokeWeight: 2,
                                fillColor: '#3232ad',
                                fillOpacity: 0.45,
                            });

                            area.setMap(this.map);
                            this.parking_polygons.push(area);


                            const bounds = new google.maps.LatLngBounds();
                            area.getPath().forEach(function (path, index) {
                                bounds.extend(path);
                            });

                            
                            const position = results[0].geometry.location
                            const marker = new google.maps.Marker({
                                map: this.map,
                                position: bounds.getCenter(),
                                icon: '/images/marker_blueP.png'
                            });

                            marker.addListener('mouseover', () => {
                                if (this.isInfoWindowOpen(this.parking_info_window_static)) return;

                                this.parking_info_window_hover = this.generate_info_window(parking);
                                this.parking_info_window_hover.open(this.map, marker);
                            })
                            marker.addListener('mouseout', () => {
                                this.parking_info_window_hover.close();
                            })
                            marker.addListener('click', () => {
                                if (this.isInfoWindowOpen(this.parking_info_window_static)) return;

                                this.parking_info_window_hover.close();

                                this.parking_info_window_static = this.generate_info_window_with_button(parking);
                                this.parking_info_window_static.open(this.map, marker);
                            })

                            this.closes_parkings_markers.push(marker);
                        }
                    });
                });
            })
            .catch((e) => {
                console.log(e)
            })

            this.geocoder.geocode({'address': `${this.destionation_address}, Tartu city, Estonia`}, (results, status) => {
                if (status == google.maps.GeocoderStatus.OK) {
                    const position = results[0].geometry.location
                    this.map.setCenter(position);
                    this.map.setZoom(17);
                    this.destionation_marker = new google.maps.Marker({
                        map: this.map,
                        position,
                    });
                } else {
                    console.log('Geocode was not successful for the following reason: ' + status);
                }
            });

        },
        clear_address: function() {
            this.destionation_address = "";
        },
        remove_all_markers: function() {
            if (this.destionation_marker) {
                this.destionation_marker.setMap(null);
            }
            this.closes_parkings_markers.map((marker) => marker.setMap(null))
        },
        remove_all_polygons: function() {
            this.parking_polygons.map((polygon) => polygon.setMap(null))
        },
        generate_info_window: function(parking_info) {
            const infoWindowContent = `
                <div style="font-weight: 400; font-size: 14px; margin-bottom: 5px">${parking_info.address}</div>
                <div>Available slots: ${parking_info.slots.available} / ${parking_info.slots.total}</div>
                <div>Distance: ${parking_info.distance}</div>
            `;

            return new google.maps.InfoWindow({ content: infoWindowContent });
        },
        generate_info_window_with_button: function(parking_info) {
            const info_window = this.generate_info_window(parking_info);
            const infoWindowContent = info_window.content +
                `<button 
                    style="margin: 5px 0 4px 23px ; border-radius: 0; height: 25px;
                        color: white; background: #4a80f5; outline: none; border: 0; font-size: 13px;
                        font-weight: 100; cursor: pointer; padding: 0 20px;
                        box-shadow: 0 1px 1px rgba(0,0,0,0.16), 0 2px 5px rgba(0,0,0,0.23);" 
                    onClick='window.see_details()'>See details</button>`

            return new google.maps.InfoWindow({ address: parking_info.address, content: infoWindowContent });
        },
        generate_marker_with_icon: function(position, icon) {
            return new google.maps.Marker({
                map: this.map,
                position,
                icon
            });
        },
        isInfoWindowOpen: function(infoWindow){
            return (infoWindow
                && infoWindow.getMap() !== null
                && typeof infoWindow.getMap() !== "undefined");
        },
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

        window.see_details = () => {
            window.location.href = '/bookings?parking_id=1';
        }
    },
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
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            box-sizing: border-box;
            color: #929292;
            float: left;
            font: inherit;
            margin: 0;
            outline: 0;
            padding: 10px 30px 10px 10px;
            width: 290px;

            @media (max-width: 768px) {
                & {
                    width: calc(100% - 70px);
                }
            }

            &:active, &:focus {
                border: 1px solid #4a80f5;
                border-right: 0;
            }

            &::-webkit-input-placeholder {
                color: #929292;
            }
        }

        .clear-input {
            color: #929292;
            cursor: pointer;
            height: 32px;
            font-size: 28px;
            left: 270px;
            margin-top: 4px;
            position: absolute;
            padding: 0 4px;

            @media (max-width: 768px) {
                & {
                    left: auto;
                    right: 88px;
                }
            }
        }

        button {
            background: #4a80f5;
            border: 0;
            border-radius: 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
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