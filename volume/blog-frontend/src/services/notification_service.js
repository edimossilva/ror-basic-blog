import ActionCable from "actioncable";

const cable = ActionCable.createConsumer("ws://localhost:3000/cable");

export default {
  createCable(appInstance) {
    const token = appInstance.$store.getters.authToken
    cable.subscriptions.create(
      {
        channel: "BlogCreatedChannel",
        token
      },
      {
        connected: function () {
          console.log("connected");
        },
        disconnected: function () {
          console.log("disconnected");
        },
        received: data => {
          // debugger; // eslint-disable-line
          console.log("notification received:", data);
          appInstance.$modal.show("modal", { message: data.message });
        }
      }
    );
  },
}