import Login from './components/login/Login.vue'
import ListBlog from './components/blog/list-blog/ListBlog.vue'
import CreateBlog from './components/blog/create-blog/CreateBlog.vue'

export const routes = [
  { name: 'login', path: '/login', component: Login, title: 'Login' },
  { name: 'listBlogs', path: '/blogs', component: ListBlog, title: 'List Blogs' },
  { name: 'createBlogs', path: '/blogs/new', component: CreateBlog, title: 'Create Blogs' },
]