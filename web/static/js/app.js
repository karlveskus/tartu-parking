import Vue from "vue";
import "vueify/lib/insert-css";

import parking_map from "./parking_map";
Vue.component("parking-map", parking_map);

new Vue({}).$mount("#parking-app");