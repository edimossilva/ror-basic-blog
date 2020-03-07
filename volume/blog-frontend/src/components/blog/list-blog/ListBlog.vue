<template lang="">
  <div>
    <p>List Blogs</p>

    <table>
      <thead>
        <tr>
          <th>id</th>
          <th>name</th>
          <th>private</th>
          <th>show</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="blog in blogs" v-bind:key="blog.id">
          <td>{{blog.id}}</td>
          <td>{{blog.name}}</td>
          <td>{{blog.is_private}}</td>
          <button @click="redirectToShowBlog(blog.id)" class="ListBlog__showBlog-button-js">Show</button>
        </tr>
      </tbody>
    </table>
    <button @click="redirectTocreateBlog()">Create</button>
  </div>
</template>

<script>
import blogsApi from "../../../services/blogs_api";

export default {
  data() {
    return {
      blogs: []
    };
  },

  methods: {
    getBlogs() {
      const { onGetBlogsSuccess, showErrorMessage } = this;
      // debugger; // eslint-disable-line

      blogsApi
        .getBlogs({ token: this.$store.getters.authToken })
        .then(onGetBlogsSuccess)
        .catch(showErrorMessage);
    },

    onGetBlogsSuccess({ data: { data: blogs } }) {
      // debugger; // eslint-disable-line
      this.blogs = blogs;
    },

    showErrorMessage(error) {
      debugger; // eslint-disable-line

      console.log(`error ${error}`);
    },

    redirectToShowBlog(blogId) {
      console.log(`show blog ${blogId}`);
    },

    redirectTocreateBlog() {
      this.$router.push({ name: "createBlog" });
    }
  },

  mounted: function() {
    this.getBlogs();
  }
};
</script>

<style scoped></style>