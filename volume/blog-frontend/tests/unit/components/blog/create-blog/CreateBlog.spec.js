import { shallowMount } from '@vue/test-utils'
import CreateBlog from '@/components/blog/create-blog/CreateBlog'

describe('CreateBlog.vue', () => {
  it('is a valid component', () => {
    const wrapper = shallowMount(CreateBlog)

    expect(wrapper.isVueInstance()).toBeTruthy()
  })
})
