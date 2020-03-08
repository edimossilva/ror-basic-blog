import { mount, config, createLocalVue } from '@vue/test-utils'

import UserHeader from '@/components/user-header/UserHeader'
import { store } from '@/store/store'

describe('UserHeader', () => {
  it('is a valid component', () => {
    const wrapper = mount(UserHeader, {
      stubs: {
        modal: true,
      },
      store,
    })

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })
});