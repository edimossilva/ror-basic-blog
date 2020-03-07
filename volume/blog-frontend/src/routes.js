import Login from './components/login/Login.vue'
import ListBlog from './components/blog/list-blog/ListBlog.vue'
import CreateBlog from './components/blog/create-blog/CreateBlog.vue'
import ShowBlog from './components/blog/show-blog/ShowBlog.vue'


export const routes = [
  { name: 'login', path: '/login', component: Login, title: 'Login', display: true },
  { name: 'listBlogs', path: '/blogs', component: ListBlog, title: 'List Blogs', display: true },
  { name: 'createBlog', path: '/blogs/new', component: CreateBlog, title: 'Create Blog', display: true },
  { name: 'showBlog', path: '/blogs/:id', component: ShowBlog, title: 'Show Blog', display: false, props: true },
]

