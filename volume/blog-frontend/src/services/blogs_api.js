
import api from './api';

const BLOGS_RESOURCE = 'blogs';

export default {
  getBlogs(token) {
    return api.simpleGet(BLOGS_RESOURCE, token);
  },
}