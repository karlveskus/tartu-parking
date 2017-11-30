import Vue from "vue";
import "vueify/lib/insert-css";
import "axios";

import parking_map from "./parking_map";
import address_field from "./address_field";
import { store } from './store/store';

Vue.component("parking-map", parking_map);
Vue.component("address-field", address_field);

new Vue({
    store: store,
    el: '#parking-app'
})