import { shallowMount } from '@vue/test-utils'
import ShowPost from '@/components/post/show-post/ShowPost'

describe('ShowPost.vue', () => {
  it('is a valid component', () => {
    const mockPost = {
      owner: "mockOwner",
      title: "mockTitle",
    }

    const wrapper = shallowMount(ShowPost, {
      methods: { getPost: jest.fn() },
      propsData: {
        id: 1,
        blogId: 2
      },
      data() { return { post: mockPost } }
    });

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })
})
