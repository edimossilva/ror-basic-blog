
import api from './api';


export default {
  postResource({ blogId, id }) {
    return `blogs/${blogId}/posts/${id}`
  },
  createPost(params) {
    return api.simplePost(this.postResource(params), params);
  },

  deletePost({ params, token }) {
    // debugger; // eslint-disable-line

    return api.simpleDelete(this.postResource(params), token);
  },

  getPost({ params, token }) {
    return api.simpleGet(this.postResource(params), params.id, token);
  },

  getPosts(params) {
    return api.simpleGet(this.postResource(params), params);
  },

}