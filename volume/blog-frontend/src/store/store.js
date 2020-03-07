import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

export const store = new Vuex.Store({
  plugins: [createPersistedState()],

  state: {
    authToken: "",
    username: "",
    userId: ""
  },

  mutations: {
    saveAuthToken(state, token) {
      state.authToken = token;
    },
    saveUsername(state, username) {
      state.username = username;
    },
    saveUserId(state, userId) {
      state.userId = userId;
    },
    deleteToken(state) {
      state.authToken = "";
    }
  },

  getters: {
    authToken: state => state.authToken,
    username: state => state.username,
    userId: state => state.userId,
    isLoged: state => !!state.authToken
  }
});