import ActionCable from "actioncable";

const cable = ActionCable.createConsumer("ws://localhost:3000/cable");

export default {
  createCable({ channel, token, onDataReceived }) {
    cable.subscriptions.create(
      {
        channel,
        token
      },
      {
        connected: function () {
          console.log(`connected to ${channel}`);
        },
        disconnected: function () {
          console.log(`disconnected from ${channel}`);
        },
        received: data => {
          console.log("notification received:", data);
          onDataReceived("modal", { message: data.message });
        }
      }
    );
  },

  createCableByUser({ user, onDataReceived }) {
    const blogChannel = "BlogCreatedChannel";
    const postChannel = "PostDeletedChannel";

    if (user.accessLevel !== "admin") {
      this.createCable({
        channel: postChannel,
        token: user.token,
        onDataReceived
      });
    } else if (user.accessLevel !== "registred") {
      this.createCable({
        channel: blogChannel,
        token: user.token,
        onDataReceived
      });
    }
  }
}