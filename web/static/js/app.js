import Vue from "vue";
import "vueify/lib/insert-css";
import "axios";

import parking_map from "./components/parking_map";
import booking from "./components/booking/booking";

Vue.component("parking-map", parking_map);
Vue.component("booking", booking);

new Vue({
    el: '#parking-app'
})