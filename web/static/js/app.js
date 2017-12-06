import Vue from "vue";
import "vueify/lib/insert-css";
import "axios";

import parking_map from "./components/parking_map";
import booking from "./components/booking/booking";
import login from "./login";

Vue.component("parking-map", parking_map);
Vue.component("booking", booking);
Vue.component("login", login);

new Vue({
    el: '#parking-app'
});