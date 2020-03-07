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
      return this.routes.filter(
        route => route.display && route.name !== "login"
      );
    }
  }
};
</script>

<style scoped>
</style>