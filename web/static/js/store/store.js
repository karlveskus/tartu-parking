import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export const store = new Vuex.Store({
    state: {
        map: undefined,
        address: "Raatuse 22"
    },
    getters: {
        address: (state) => {
            return state.address;
        }
    },
    mutations: {
        setAddress: (state, address) => {
            state.address = address
        }
    },
    actions: {
        setAddress: (context, address) => {
            context.commit('setAddress', address)
        }
    }
})
