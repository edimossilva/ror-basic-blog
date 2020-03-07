<template lang="">
  <div>
    <p>User: {{username}}</p>
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
    isLoged: function() {
      return this.$store.getters.isLoged;
    }
  },
  methods: {
    logout() {
      this.$store.commit("deleteToken");
    },
    redirectToLogin() {
      this.$router.push({ name: "login" });
    }
  }
};
</script>

<style scoped></style>