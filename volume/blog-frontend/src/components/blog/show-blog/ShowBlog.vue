<template lang="">
  <div>
    <div>
      <h3> Blog Name: {{blog.name}} </h3>
    </div>
    
    <table>
      <thead>
        <tr>
          <th>id</th>
          <th>title</th>
          <th>owner</th>
          <th>private</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="post in blog.posts" v-bind:key="post.id">
        <td>{{post.id}}</td>
        <td>{{post.title}}</td>
        <td>{{post.owner}}</td>
        <td>{{post.is_private}}</td>

        <td><button @click="redirectToShowPost(post.id)">Show post</button></td>
        <td><button @click="deletePost(post.id)">Delete post</button></td>
      </tr>
    </tbody>
    </table>
    <button @click="redirectTocreatePost()">Create Post</button>

  </div>
</template>

<script>
import blogsApi from "../../../services/blogs_api";
import postsApi from "../../../services/posts_api";

export default {
  props: {
    id: {
      required: true
    }
  },

  data() {
    return {
      blog: {}
    };
  },

  methods: {
    deletePost(postId) {
      const { onDeletePost, showErrorMessage } = this;
      const params = {
        blogId: this.id,
        id: postId
      };

      postsApi
        .deletePost({ params, token: this.$store.getters.authToken })
        .then(onDeletePost)
        .catch(showErrorMessage);
    },
    onDeletePost() {
      location.reload();
    },
    getBlog() {
      const params = {
        id: this.id
      };
      blogsApi
        .getBlog({
          params,
          token: this.$store.getters.authToken
        })
        .then(this.updateData)
        .catch(this.showErrorMessage);
    },

    updateData({ data: { data } }) {
      // debugger; // eslint-disable-line

      this.blog = data;
    },

    showErrorMessage({
      response: {
        data: { error_message }
      }
    }) {
      // debugger; // eslint-disable-line
      this.$modal.show("modal", { message: error_message });
    },

    redirectToShowPost(postId) {
      this.$router.push({
        name: "showPost",
        params: { id: postId, blogId: this.blog.id }
      });
    },

    redirectTocreatePost() {
      this.$router.push({
        name: "createPost",
        params: { blogId: this.blog.id }
      });
    }
  },

  mounted: function() {
    this.getBlog();
  }
};
</script>

<style scoped></style>