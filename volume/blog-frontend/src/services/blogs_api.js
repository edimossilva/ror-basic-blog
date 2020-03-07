
import api from './api';

const BLOGS_RESOURCE = 'blogs';

export default {
  createBlog(params) {
    return api.simplePost(BLOGS_RESOURCE, params);
  },

  deleteBlog({ params, token }) {
    return api.simpleDeleteResource(BLOGS_RESOURCE, params.id, token);
  },

  getBlog({ params, token }) {
    return api.simpleGetResource(BLOGS_RESOURCE, params.id, token);
  },

  getBlogs(params) {
    return api.simpleGet(BLOGS_RESOURCE, params);
  },
}