import Vue from "vue";
import "vueify/lib/insert-css";
import "axios";

import parking_map from "./components/parking_map";
import bookings from "./components/bookings";

Vue.component("parking-map", parking_map);
Vue.component("bookings", bookings);

new Vue({
    el: '#parking-app'
})