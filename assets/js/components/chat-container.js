import React from "react";
import ReactDOM from "react-dom";
import { connect } from "react-redux";

import ChatMessage from "./chat-message";

class ChatContainer extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      draft: "",
    };
  }

  updateDraft(e) {
    this.setState({
      draft: e.target.value,
    });
  }

  sendMessage() {
    let message = this.state.draft;

    if (!message) return false;

    let room = this.props.room;

    room.channel.push("message:new", {
      text: message,
      room_id: room.id,
    });

    this.setState({
      draft: "",
    });
  }

  render() {
    let messages = this.props.messages.map((message) => {
      return <ChatMessage key={message.id} message={message} />;
    });

    return (
      <div className="chat">
        <ul>{messages}</ul>

        <div className="compose-box">
          <input
            placeholder="Type a message..."
            value={this.state.draft}
            onChange={this.updateDraft.bind(this)}
          />
          <button onClick={this.sendMessage.bind(this)}>Send</button>
        </div>
      </div>
    );
  }
}

ChatContainer.defaultProps = {
  messages: [],
};

const mapStateToProps = (state) => {
  let activeRoom = state.filter((room) => {
    return room.isActive;
  })[0];

  return {
    messages: activeRoom ? activeRoom.messages : [],
    room: activeRoom,
  };
};

ChatContainer = connect(mapStateToProps)(ChatContainer);

export default ChatContainer;
