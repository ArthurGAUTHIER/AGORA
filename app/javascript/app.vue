<template>
  <ChatView></ChatView>
</template>

<script>
import ChatView from './chatbot/ChatView.vue';

export default {
  components: {
    ChatView,
  },

  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>

</style>
