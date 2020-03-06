<template lang="">
  <div>
    <p>Login</p>

    <div>
      <label> Username: </label>
      <input type="text" v-model="username" class="Login__username-input-js"> 
    </div>
    
    <div>
      <label> Password: </label>
      <input type="password" v-model="password" class="Login__password-input-js"> 
    </div>

    <button @click="doLogin" class="Login__login-button-js">Login</button>
    <div>
      username: 'registered_user1', password: '111' <br>
      username: 'registered_user2', password: '222' <br>
      username: 'admin_user1',      password: '111' <br>
      username: 'admin_user2',      password: '222' <br>
    </div>
  </div>
</template>

<script>
import authService from "../../services/auth_service";

export default {
  data() {
    return {
      username: "registered_user1",
      password: "111"
    };
  },
  methods: {
    doLogin() {
      const { username, password } = this;
      const { onLoginSuccess, showErrorMessage } = this;

      authService
        .doLogin(username, password)
        .then(onLoginSuccess)
        .catch(showErrorMessage);
    },

    onLoginSuccess({ data: { token, username } }) {
      this.saveToken(token);
      this.saveUsername(username);
      this.redirectToHomeIfLogged();
      console.log("redirecthome");
    },

    saveToken(token) {
      this.$store.commit("saveAuthToken", token);
    },

    saveUsername(username) {
      this.$store.commit("saveUsername", username);
    },

    showErrorMessage(error) {
      // debugger; // eslint-disable-line
      console.log(`error ${error}`);
    },
    redirectToHomeIfLogged() {
      if (this.$store.getters.isLoged) {
        return this.$router.push({ name: "blogs" });
      }
    }
  },
  mounted: function() {
    this.redirectToHomeIfLogged();
  }
};
</script>

<style scoped></style>