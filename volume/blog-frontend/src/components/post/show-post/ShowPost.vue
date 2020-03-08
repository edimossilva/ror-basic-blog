<template lang="">
  <div>
    <h3>Show Post</h3>

    <div>
      <p> Post Title: {{ post.title }} </p>
      <p> Post Owner: {{ post.owner }} </p>

    </div>

    <button @click="redirectToShowBlog">Show posts</button>
    <button @click="redirectToCreatePost">Create post</button>

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

    redirectToShowBlog() {
      this.$router.push({ name: "showBlog", params: { id: this.blogId } });
    },
    redirectToCreatePost() {
      this.$router.push({
        name: "createPost",
        params: { blogId: this.blogId }
      });
    },
    updateData({ data: { data } }) {
      this.post = data;
    },

    showErrorMessage({
      response: {
        data: { error_message }
      }
    }) {
      // debugger; // eslint-disable-line
      this.$modal.show("modal", { message: error_message });
    }
  },

  mounted: function() {
    this.getPost();
  }
};
</script>

<style scoped></style>