import { mount, createLocalVue } from "@vue/test-utils"
import App from "@/App.vue"
import VueRouter from "vue-router"
import Login from '@/components/login/Login'
import { routes } from "../../../src/routes"

const localVue = createLocalVue()
localVue.use(VueRouter)
const router = new VueRouter({ routes })

describe("App", () => {
  it('is a valid component', () => {
    const wrapper = mount(App, {
      localVue,
      router
    })

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })

  describe('router', () => {
    const wrapper = mount(App, {
      localVue,
      router
    })

    it("visits login", async () => {
      router.push("/login")
      await wrapper.vm.$nextTick()

      const loginComponent = wrapper.find(Login)
      expect(wrapper.find(Login).exists()).toBe(true)
    })
  });
})