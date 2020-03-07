<template>
  <nav>
    <ul>
      <li v-for="route in visibleRoutes" :key="route.path">
        <router-link class="router-link" :to="route.path">{{route.title}}</router-link>
      </li>
    </ul>
  </nav>
</template>

<script>
export default {
  props: {
    routes: {
      type: Array,
      required: true
    }
  },
  computed: {
    visibleRoutes() {
      // debugger; // eslint-disable-line
      let filteredRoutes = [];

      if (this.$store.getters.isLoged) {
        filteredRoutes = this.routes.filter(route => route.name !== "login");
      } else {
        filteredRoutes = this.routes;
      }

      return filteredRoutes.filter(route => route.display);
    }
  }
};
</script>

<style scoped>
</style>