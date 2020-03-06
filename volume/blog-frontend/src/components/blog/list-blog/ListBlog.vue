<template lang="">
  <div>
    <p>List Blogs</p>

    <table>
      <thead>
        <tr>
          <th>id</th>
          <th>name</th>
          <th>private</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="blog in blogs" v-bind:key="blog.id">
          <td>{{blog.id}}</td>
          <td>{{blog.name}}</td>
          <td>{{blog.is_private}}</td>
        </tr>
      </tbody>
    </table>
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
      console.log(`error ${error}`);
    }
  },

  mounted: function() {
    this.getBlogs();
  }
};
</script>

<style scoped></style>