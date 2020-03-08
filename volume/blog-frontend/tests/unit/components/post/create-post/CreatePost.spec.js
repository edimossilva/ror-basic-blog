import { shallowMount } from '@vue/test-utils'
import CreatePost from '@/components/post/create-post/CreatePost'

describe('CreatePost.vue', () => {
  it('is a valid component', () => {
    const wrapper = shallowMount(CreatePost, {
      propsData: { blogId: 1 },
    });

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })
})
