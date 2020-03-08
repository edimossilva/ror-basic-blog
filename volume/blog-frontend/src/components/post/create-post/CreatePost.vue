<template lang="">
  <div>
    <p>Create Post</p>

    <div>
      <label> title: </label>
      <input type="text" v-model="title"> 
    </div>

    <button @click="createPost">Create</button>
  </div>
</template>

<script>
import potsApi from "../../../services/posts_api";

export default {
  props: {
    blogId: {
      required: true
    }
  },
  data() {
    return {
      title: ""
    };
  },
  methods: {
    createPost() {
      const params = {
        title: this.title,
        blogId: this.blogId
      };
      potsApi
        .createPost({
          params,
          token: this.$store.getters.authToken
        })
        .then(this.redirectToShowPost)
        .catch(this.showErrorMessage);
    },
    redirectToShowPost({ data: { data } }) {
      this.$router.push({
        name: "showPost",
        params: { id: data.id, blogId: data.blog_id }
      });
    },
    showErrorMessage({
      response: {
        data: { error_message }
      }
    }) {
      // debugger; // eslint-disable-line
      this.$modal.show("modal", { message: error_message });
    }
  }
};
</script>

<style scoped></style>