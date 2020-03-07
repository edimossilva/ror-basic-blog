<template>
  <modal name="modal" :width="300" :height="300" @before-open="beforeOpen">
    <b>{{message}}</b>
  </modal>
</template>
<script>
export default {
  name: "AlertModal",
  data() {
    return {
      message: ""
    };
  },
  methods: {
    beforeOpen(event) {
      this.message = event.params.message;
    }
  }
};
</script>