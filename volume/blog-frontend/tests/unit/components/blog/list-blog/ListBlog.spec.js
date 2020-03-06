import { mount } from '@vue/test-utils'
import ListBlog from '@/components/blog/list-blog/ListBlog'

describe('ListBlog.vue', () => {
  it('is a valid component', () => {

    const wrapper = mount(ListBlog, {
      methods: { getBlogs: jest.fn() },
    });

    expect(wrapper.isVueInstance()).toBeTruthy()
  })

  it('render blogs', () => {
    const mockBlogs = [
      { id: 1, name: "mockName1", is_private: true },
      { id: 2, name: "mockName2", is_private: false },
    ]

    const wrapper = mount(ListBlog, {
      methods: { getBlogs: jest.fn() },
      data() { return { blogs: mockBlogs } }
    });

    expect(wrapper).toMatchSnapshot()
  })
})
