import { mount, config, createLocalVue } from '@vue/test-utils'

import VueRouter from "vue-router"
import Login from '@/components/login/Login'

import { store } from '@/store/store'
import { routes } from "../../../../src/routes"
config.mocks.$store = store

const localVue = createLocalVue()
localVue.use(VueRouter)
const router = new VueRouter({ routes })


describe('Login.vue', () => {
  const mockUsername = "mockUsername"
  const mockPassword = "mockPassword"
  const mockToken = "mockToken"

  it('is a valid component', () => {
    const wrapper = mount(Login, {
      stubs: {
        modal: true
      }
    })

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })

  describe('Behaviour', () => {
    describe('When fill username and password, and click login button', () => {
      const doLoginSpy = jest.fn()
      Login.methods.doLogin = doLoginSpy

      const wrapper = mount(Login, {
        stubs: {
          modal: true
        }
      })

      beforeEach(() => {
        // fill username 
        const usernameInput = wrapper.find('.Login__username-input-js')
        usernameInput.element.value = mockUsername
        usernameInput.trigger('input')

        //fill password
        const passwordInput = wrapper.find('.Login__password-input-js')
        passwordInput.element.value = mockPassword
        passwordInput.trigger('input')

        //click login button
        const loginButton = wrapper.find('.Login__login-button-js')
        loginButton.trigger('click')
      })

      it('should populate fields and call login method', () => {
        expect(wrapper.vm.username).toEqual(mockUsername)
        expect(wrapper.vm.password).toEqual(mockPassword)
        expect(doLoginSpy).toHaveBeenCalledTimes(1)
      })
    })
  })

  describe('Methods', () => {
    describe('onLoginSuccess', () => {
      const wrapper = mount(Login, {
        localVue,
        router,
        store,
        stubs: {
          modal: true
        },
        methods: { registerToNotifications: jest.fn() },
      })

      const user = { token: "token", username: "username", userId: "userId", accessLevel: "accessLevel" }
      beforeEach(() => {
        const response = {
          data: user
        }
        wrapper.vm.onLoginSuccess(response)
      });

      it('should save username in store', () => {
        expect(store.state.user).toEqual(user)
      })
    })
  })
})
