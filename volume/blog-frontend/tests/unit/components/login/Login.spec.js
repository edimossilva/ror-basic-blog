import { mount, config } from '@vue/test-utils'
import Login from '@/components/login/Login'
import { store } from '@/store/store'

config.mocks.$store = store
describe('Login.vue', () => {
  const mockUsername = "mockUsername"
  const mockPassword = "mockPassword"
  const mockToken = "mockToken"

  it('is a valid component', () => {
    const wrapper = mount(Login)

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })

  describe('Behaviour', () => {
    describe('When fill username and password', () => {
      const doLoginSpy = jest.fn()
      Login.methods.doLogin = doLoginSpy

      const wrapper = mount(Login)

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
        store
      })

      beforeEach(() => {
        const response = {
          data: {
            token: mockToken,
            username: mockUsername
          }
        }
        wrapper.vm.onLoginSuccess(response)
      });

      it('should save token and username in store', () => {
        expect(store.state.username).toEqual(mockUsername)
      })
      it('should save token and username in store', () => {
        expect(store.state.authToken).toEqual(mockToken)
      })
    })
  })
})
