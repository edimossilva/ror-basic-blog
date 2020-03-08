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
import notificationService from "../../services/notification_service";

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

    onLoginSuccess({ data }) {
      this.saveData(data);
      this.registerToNotifications(data);
      this.redirectToHomeIfLogged();
    },

    saveData({ token, username, userId, accessLevel }) {
      const user = { token, username, userId, accessLevel };
      this.$store.commit("saveUser", user);
    },

    showErrorMessage({
      response: {
        data: { error_message }
      }
    }) {
      // debugger; // eslint-disable-line
      this.$modal.show("modal", { message: error_message });
    },

    registerToNotifications(user) {
      const showModal = this.$modal.show;

      notificationService.createCableByUser({
        user,
        onDataReceived: showModal
      });
    },

    redirectToHomeIfLogged() {
      // debugger; // eslint-disable-line

      if (this.$store.getters.isLoged) {
        this.$router.push({ name: "listBlogs" });
      }
    }
  },
  mounted: function() {
    this.redirectToHomeIfLogged();
  }
};
</script>

<style scoped></style>