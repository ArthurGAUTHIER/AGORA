<template>
  <ChatView></ChatView>
</template>

<script>
import Vue from 'vue'
import ChatView from './chatbot/ChatView.vue';
import VueChatScroll from 'vue-chat-scroll'

Vue.use(VueChatScroll)

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
