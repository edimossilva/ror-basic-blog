<template lang="">
  <div>
    <h3>Show Post</h3>

    <div>
      <h3> Post Title: {{ post.title }} </h3>
    </div>
  </div>
</template>

<script>
import postsApi from "../../../services/posts_api";

export default {
  props: {
    id: {
      required: true
    },
    blogId: {
      required: true
    }
  },

  data() {
    return {
      post: {}
    };
  },

  methods: {
    getPost() {
      const params = {
        id: this.id,
        blogId: this.blogId
      };
      postsApi
        .getPost({
          params,
          token: this.$store.getters.authToken
        })
        .then(this.updateData)
        .catch(this.showErrorMessage);
    },

    updateData({ data: { data } }) {
      this.post = data;
    },

    showErrorMessage({
      response: {
        data: { errors }
      }
    }) {
      debugger; // eslint-disable-line
      console.log(errors);
    }
  },

  mounted: function() {
    this.getPost();
  }
};
</script>

<style scoped></style>