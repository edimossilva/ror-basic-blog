<template>
  <div>
    <user-header></user-header>
    <routes-menu :routes="routes"></routes-menu>
    <router-view></router-view>
  </div>
</template>

<script>
import { routes } from "./routes";
import RoutesMenu from "./components/routes-menu/RoutesMenu";
import UserHeader from "./components/user-header/UserHeader";

export default {
  name: "App",
  components: {
    RoutesMenu,
    UserHeader
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
