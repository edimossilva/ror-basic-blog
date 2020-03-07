<template lang="">
  <div>
    <h3>Show Blog</h3>

    <div>
      <h3> Blog Name: {{blog.name}} </h3>
    </div>
    
    <table>
      <thead>
        <tr>
          <th>id</th>
          <th>title</th>
          <th>show post</th>
          <th>delete</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="post in blog.posts" v-bind:key="post.id">
        <td>{{post.id}}</td>
        <td>{{post.title}}</td>
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
      console.log("deleted post");
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
      this.blog = JSON.parse(data);
    },

    showErrorMessage({
      response: {
        data: { errors }
      }
    }) {
      debugger; // eslint-disable-line
      console.log(errors);
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