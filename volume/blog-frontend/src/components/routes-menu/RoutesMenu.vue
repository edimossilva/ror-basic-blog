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

      if (this.$store.getters.isLoged) {
        return this.routes.filter(route => route.name !== "login");
      }
      return this.routes;
    }
  }
};
</script>

<style scoped>
</style>