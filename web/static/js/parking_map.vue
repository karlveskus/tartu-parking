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
            parking_info_window_static: null
        }
    },
    methods: {
        get_parkings: function() {
            if (this.destionation_address === "") return;

            this.remove_all_markers();

            let url = "/api/parkings?address=" + this.destionation_address

            axios.get(url)
            .then((res) => {
                res.data.forEach((parking) => {
                    this.geocoder.geocode({'address': `${parking.address}, Tartu city, Estonia`}, (results, status) => {
                        if (status == google.maps.GeocoderStatus.OK) {
                            const position = results[0].geometry.location
                            const marker = new google.maps.Marker({
                                map: this.map,
                                position,
                                icon: '/images/marker_blueP.png'
                            });

                            marker.addListener('mouseover', () => {
                                if (this.parking_info_window_static
                                    && this.isInfoWindowOpen(this.parking_info_window_static)) return;

                                this.parking_info_window_hover = this.generate_info_window(parking);
                                this.parking_info_window_hover.open(this.map, marker);
                            })
                            marker.addListener('mouseout', () => {
                                this.parking_info_window_hover.close();
                            })
                            marker.addListener('click', () => {
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
        generate_info_window: function(parking_info) {
            const infoWindowContent = `
                <div style="font-weight: 400; font-size: 14px; margin-bottom: 5px">${parking_info.address}</div>
                <div>Available slots: ${parking_info.slots.available} / ${parking_info.slots.total}</div>
                <div>Distance: ${parking_info.distance.distance.text}</div>
                <div>Duration: ${parking_info.distance.duration.text}</div>
            `;

            return new google.maps.InfoWindow({ content: infoWindowContent });
        },
        generate_info_window_with_button: function(parking_info) {
            const info_window = this.generate_info_window(parking_info);
            const infoWindowContent = info_window.content +
                `<button>See details</button>`

            return new google.maps.InfoWindow({ content: infoWindowContent });
        },
        generate_marker_with_icon: function(position, icon) {
            return new google.maps.Marker({
                map: this.map,
                position,
                icon
            });
        },
        isInfoWindowOpen: function(infoWindow){
            const map = infoWindow.getMap();
            return (map !== null && typeof map !== "undefined");
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
            box-shadow: 0 2px 6px 0px rgba(0, 0, 0, .2);
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
            box-shadow: 0 2px 6px 0px rgba(0, 0, 0, .2);
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