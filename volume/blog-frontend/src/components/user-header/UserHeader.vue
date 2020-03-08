<template lang="">
  <div>
    <p>{{userLabel}}</p>
    <button v-if="isLoged" button @click="logout">Logout</button>
    <button v-else @click="redirectToLogin">Login</button>
  </div>
</template>

<script>
export default {
  computed: {
    username: function() {
      const username = this.$store.getters.username;
      return username ? username : "not registred";
    },
    userLabel: function() {
      if (!this.isLoged) {
        return "not registred";
      }
      const user = this.$store.getters.user;
      return `username: ${user.username}, accessLevel: ${user.accessLevel}, id: ${user}`;
    },
    isLoged: function() {
      return this.$store.getters.isLoged;
    }
  },
  methods: {
    logout() {
      this.$store.commit("deleteUser");
      location.reload();
    },
    redirectToLogin() {
      this.$router.push({ name: "login" });
    }
  }
};
</script>

<style scoped></style>