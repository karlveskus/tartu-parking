import Vue from "vue";
import "vueify/lib/insert-css";

import parking_map from "./parking_map";
import address_field from "./address_field";

Vue.component("parking-map", parking_map);
Vue.component("address-field", address_field);

new Vue({}).$mount("#parking-app");