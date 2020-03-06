import Login from './components/login/Login.vue'
import ListBlog from './components/blog/list-blog/ListBlog.vue'

export const routes = [
  { name: 'login', path: '/login', component: Login, title: 'Login' },
  { name: 'blogs', path: '/blogs', component: ListBlog, title: 'Blogs' },
]