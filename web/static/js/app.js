import Vue from "vue";
import "vueify/lib/insert-css";
import VueRouter from "vue-router";
import "phoenix";
import "axios";

import parking_map from "./components/parking_map";
import booking from "./components/booking/booking";
import login from "./login";

Vue.use(VueRouter);

Vue.component("parking-map", parking_map);
Vue.component("booking", booking);
Vue.component("login", login);

var router = new VueRouter({
    routes: [
        { path: '/login', component: login},
        { path: '/', component: parking_map}
    ]
});

new Vue({
    el: '#parking-app',
    router
});