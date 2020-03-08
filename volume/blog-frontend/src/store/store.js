import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

export const store = new Vuex.Store({
  plugins: [createPersistedState()],

  state: {
    user: {},
  },

  mutations: {
    saveUser(state, user) {
      state.user = user;
    },

    deleteUser(state) {
      state.user.token = ""
      state.user.username = ""
      state.user.userId = ""
    }
  },

  getters: {
    authToken: state => state.user.token,
    username: state => state.user.username,
    userId: state => state.user.userId,
    isLoged: state => state.user.token,
    user: state => state.user
  }
});