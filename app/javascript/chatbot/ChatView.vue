<template>
  <div class="chatview">
    <div class="messages">
      <div v-for="message in messages" :key="message.id">
        <div class="chatMessage" :class="message.side">
          <div>
            {{ message.content }}
          </div>
        </div>
      </div>
    </div>
    <div class="input">
      <input type="text" v-model="message">
      <button @click="sendMessage">SEND</button>
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
      this.messages.push({
        side: 'sent',
        content: this.message,
        id: (this.messages.length + 1),
      });

      const newMessage = this.message;
      this.message = '';

      axios.post('/bot/send', {
        conversation_id: this.conversationId,
        message: {
          type: 'text',
          content: newMessage,
        }
      })
        .then(({data}) => {
          data.response.messages.forEach((message) => {
            if (message.content.match(/\$chiengeant/)) {
              window.location.href = '/discover';
            }
            this.messages.push({...message, side: 'received', id: (this.messages.length + 1) });
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
  margin-top: 30px;
  height: 50vh;
  width: 700px;
  background: #FFFFFF;
  margin-bottom: 20px;
  padding: 20px;
  overflow: scroll;
}

.input {
  display: flex;
}

input {
  width: 80%;
  height: 50px;
  padding: 2px 10px;
}

button {
  width: 20%;
  background: rgb(181, 7, 7);
  color: #FFFFFF;
  border: none;
}

.chatMessage {
  display: flex;
  margin-bottom: 10px;
  div {
    border-radius: 10px;
    width: 70%;
    padding: 20px 5px;
  }

  &.received {
    justify-content: flex-start;

    div {
      color: #FFFFFF;
      background: rgb(181, 7, 7);
    }
  }

  &.sent {
    justify-content: flex-end;

    div {
      background: lightgray;
    }
  }
}

</style>
