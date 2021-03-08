import React from "react";
import ReactDOM from "react-dom";
import "moment";
import moment from "moment";

class MenuMessage extends React.Component {
  render() {
    let room = this.props.room;
    let counterpart = room.counterpart;

    let lastMessage = room.messages.slice(-1)[0];
    let sentAt = moment.utc(lastMessage.sentAt).fromNow();

    return (
      <li>
        <img className="avatar" />

        <div className="profile-container">
          <p className="name">{counterpart.username}</p>

          <time>{sentAt}</time>

          <p className="message">{lastMessage.text}</p>
        </div>
      </li>
    );
  }
}

export default MenuMessage;
