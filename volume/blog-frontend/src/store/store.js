import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    authToken: "",
    username: ""
  },
  mutations: {
    saveAuthToken(state, token) {
      state.authToken = token;
    },
    saveUsername(state, username) {
      state.username = username;
    },
    deleteToken(state) {
      state.authToken = "";
    }
  },
  getters: {
    authToken: state => state.authToken,
    username: state => state.username,
    isLoged: state => !!state.authToken
  }
});