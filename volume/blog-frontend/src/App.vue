<template>
  <div>
    <user-header></user-header>
    <routes-menu :routes="routes"></routes-menu>
    <router-view></router-view>
    <alert-modal></alert-modal>
  </div>
</template>

<script>
import { routes } from "./routes";
import RoutesMenu from "./components/routes-menu/RoutesMenu";
import UserHeader from "./components/user-header/UserHeader";
import AlertModal from "./components/alert-modal/AlertModal";

export default {
  name: "App",
  components: {
    RoutesMenu,
    UserHeader,
    AlertModal
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
