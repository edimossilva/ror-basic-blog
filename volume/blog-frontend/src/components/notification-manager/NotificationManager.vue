<template>
  <div></div>
</template>

<script>
import ActionCable from "actioncable";
const cable = ActionCable.createConsumer("ws://localhost:3000/cable");

export default {
  name: "NotificationManager",

  created() {
    cable.subscriptions.create(
      {
        channel: "BlogCreatedChannel",
        user: "edimo"
      },
      {
        connected: function() {
          console.log("connected");
        },
        disconnected: function() {
          console.log("disconnected");
        },
        received: data => {
          // debugger; // eslint-disable-line
          console.log("notification received:", data);
          this.$modal.show("modal", { message: data.message });
        }
      }
    );
  }
};
</script>

<style>
</style>
