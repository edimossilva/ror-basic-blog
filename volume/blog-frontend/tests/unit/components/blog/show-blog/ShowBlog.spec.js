import { shallowMount } from '@vue/test-utils'
import ShowBlog from '@/components/blog/show-blog/ShowBlog'

describe('ShowBlog.vue', () => {
  it('is a valid component', () => {
    const mockBlog = {
      name: "mockName",
      title: "mockTitle",
      private: "mockPrivate",

      posts: [
        { id: 1, owner: "mockOwner", title: "mockTitle1", is_private: true },
        { id: 2, owner: "mockOwner", title: "mockTitle2", is_private: false },
      ]
    }
    const wrapper = shallowMount(ShowBlog, {
      methods: { getBlog: jest.fn() },
      propsData: { id: 1 },
      data() { return { blog: mockBlog } }
    });

    expect(wrapper.isVueInstance()).toBeTruthy()
    expect(wrapper).toMatchSnapshot()
  })
})
