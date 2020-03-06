<template>
  <div>
    <routes-menu :routes="routes"></routes-menu>
    <router-view></router-view>
  </div>
</template>

<script>
import { routes } from "./routes";
import RoutesMenu from "./components/routes-menu/RoutesMenu";

export default {
  name: "App",
  components: {
    RoutesMenu
  },
  data() {
    return {
      routes: routes
    };
  }
};
</script>

<style>
</style>
