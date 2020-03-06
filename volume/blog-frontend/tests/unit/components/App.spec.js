import { mount, createLocalVue } from "@vue/test-utils"
import App from "@/App.vue"
import VueRouter from "vue-router"
import Login from '@/components/login/Login'
import { routes } from "../../../src/routes"

const localVue = createLocalVue()
localVue.use(VueRouter)

describe("App", () => {
  const router = new VueRouter({ routes })
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
})