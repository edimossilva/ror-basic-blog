<template lang="">
  <div>
    <p>Create Blog</p>

    <div>
      <label> Name: </label>
      <input type="text" v-model="name"> 
    </div>

    <div>
      <label> Visibility: </label>
      <select v-model="isPrivate">
        <option selected v-bind:value="false">public</option>
        <option v-bind:value="true">private</option>
      </select>
    </div>

    <button @click="createBlog">Create</button>

  </div>
</template>

<script>
import blogsApi from "../../../services/blogs_api";

export default {
  data() {
    return {
      name: "",
      isPrivate: false
    };
  },
  methods: {
    createBlog() {
      const params = {
        name: this.name,
        is_private: this.isPrivate,
        user_id: this.$store.getters.userId
      };
      blogsApi
        .createBlog({
          params,
          token: this.$store.getters.authToken
        })
        .then(this.redirectToShowBlog)
        .catch(this.showErrorMessage);
    },
    redirectToShowBlog(response) {
      console.log(response);
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