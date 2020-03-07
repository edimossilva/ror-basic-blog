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
          <th>Delete</th>

        </tr>
      </thead>
      <tbody>
        <tr v-for="blog in blogs" v-bind:key="blog.id">
          <td>{{blog.id}}</td>
          <td>{{blog.name}}</td>
          <td>{{blog.is_private}}</td>
          <td><button @click="redirectToShowBlog(blog.id)" class="ListBlog__showBlog-button-js">Show</button></td>
          <td><button @click="deleteBlog(blog.id)" class="ListBlog__deleteBlog-button-js">Delete</button></td>
        </tr>
      </tbody>
    </table>
    <button @click="redirectTocreateBlog()">Create Blog</button>
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
    deleteBlog(blogId) {
      const { getBlogs, showErrorMessage } = this;
      const params = { id: blogId };

      blogsApi
        .deleteBlog({ params, token: this.$store.getters.authToken })
        .then(getBlogs)
        .catch(showErrorMessage);
    },
    getBlogs() {
      const { onGetBlogsSuccess, showErrorMessage } = this;

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
      this.$router.push({ name: "showBlog", params: { id: blogId } });
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