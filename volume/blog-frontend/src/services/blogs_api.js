
import api from './api';

const BLOGS_RESOURCE = 'blogs';

export default {
  getBlogs(params) {
    return api.simpleGet(BLOGS_RESOURCE, params);
  },
  createBlog(params) {
    return api.simplePost(BLOGS_RESOURCE, params);
  },
}