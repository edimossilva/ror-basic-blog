import Vue from 'vue'
import App from './App.vue'
import VueRouter from 'vue-router';

import { routes } from './routes';
import { store } from './store/store';
import VModal from 'vue-js-modal'

Vue.use(VModal)
Vue.use(VueRouter)

Vue.config.productionTip = false

const router = new VueRouter({ routes })

new Vue({
  render: h => h(App),
  router,
  store
}).$mount('#app')
