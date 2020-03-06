<template lang="">
  <div>
    <p>Login</p>

    <div>
      <label> Username: </label>
      <input type="text" v-model="username"> 
    </div>
    
    <div>
      <label> Password: </label>
      <input type="password" v-model="password"> 
    </div>

    <button @click="doLogin">Login</button>
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

    onLoginSuccess(response) {
      this.saveToken(response);
      console.log("redirecthome");
    },

    saveToken(response) {
      this.$store.commit("saveToken", response);
    },

    showErrorMessage(error) {
      // debugger; // eslint-disable-line
      console.log(`error ${error}`);
    }
  }
};
</script>

<style scoped></style>