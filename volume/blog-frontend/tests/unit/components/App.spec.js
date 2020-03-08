import { mount, config, createLocalVue } from "@vue/test-utils"

import VueRouter from "vue-router"
import App from "@/App.vue"
import Login from '@/components/login/Login'

import { store } from '@/store/store'
import { routes } from "../../../src/routes"
config.mocks.$store = store

const localVue = createLocalVue()
localVue.use(VueRouter)
const router = new VueRouter({ routes })

describe("App", () => {
  it('is a valid component', () => {
    const wrapper = mount(App, {
      localVue,
      router,
      stubs: {
        modal: true
      },
    })

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })

  describe('router', () => {
    const wrapper = mount(App, {
      localVue,
      router,
      stubs: {
        modal: true
      },
    })

    it("visits login", async () => {
      router.push("/login")
      await wrapper.vm.$nextTick()

      expect(wrapper.find(Login).exists()).toBe(true)
    })
  });
})