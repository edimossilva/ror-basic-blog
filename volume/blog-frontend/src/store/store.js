import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    authToken: {},
  },
  mutations: {
    saveToken(state, token) {
      state.authToken = token;
    },
    deleteToken(state) {
      state.authToken = {};
    }
  },
  getters: {
    authToken: state => state.authToken,
  }
});