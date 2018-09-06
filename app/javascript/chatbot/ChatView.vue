<template>
<div>
  <div class="chatview">
    <div class="messages">
      <div v-for="message in messages" :key="message">{{ message }}</div>
    </div>
    <div class="input">
      <input type="text" v-model="message">
      <button @click="sendMessage">SEND</button>
    </div>
  </div>
</div>
</template>

<script>
import * as axios from 'axios';

export default {
  components: {
  },

  data: function () {
    return {
      conversationId: 'conversation',
      message: '',
      messages: [],
    }
  },

  methods: {
    sendMessage() {
      axios.post('/bot/send', {
        conversation_id: this.conversationId,
        message: {
          type: 'text',
          content: this.message
        }
      } )
        .then(({data}) => {
          this.message = '';
          data.response.messages.forEach((message) => {
            console.log(message);
            this.messages.push(message.content);
          })
        })
        .catch(function (error) {
          console.log(error);
        });
    }
  }
}
</script>

<style lang="scss" scoped>
.messages {
  height: 30vh;
  width: 100%;
  background: #FFFFFF;
  margin-bottom: 20px;
}

.input {
  display: flex;

  input {
    width: 80%;
  }

  button {
    width: 20%;
  }
}

</style>
