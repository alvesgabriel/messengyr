import React from "react";
import ReactDOM from "react-dom";

import { connect } from "react-redux";

import MenuMessage from "./menu-message";

import { setRooms, selectRoom, addRoom } from "../actions";

class MenuContainer extends React.Component {
  componentDidMount() {
    fetch("/api/rooms", {
      headers: {
        Authorization: "Bearer " + window.jwtToken,
      },
    })
      .then((response) => {
        response.json().then((data) => {
          let rooms = data.rooms;
          this.props.setRooms(rooms);

          let firstRoom = rooms[0];

          if (firstRoom) {
            this.props.selectRoom(firstRoom.id);
          }
        });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  createRoom() {
    let username = prompt("Enter an username: ");

    let data = new FormData();
    data.append("counterpartUsername", username);

    fetch("/api/rooms", {
      method: "POST",
      headers: {
        Authorization: "Bearer " + window.jwtToken,
      },
      body: data,
    })
      .then((response) => {
        response.json().then((data) => {
          let room = data.room;

          this.props.addRoom(room);
        });
      })
      .catch((err) => {
        console.log(err);
      });
  }

  render() {
    let getRoomDate = (room) => {
      let date;

      if (room.lastMessage) {
        date = room.lastMessage.sentAt;
      } else {
        date = room.createdAt;
      }

      return new Date(date);
    };

    let rooms = this.props.rooms.sort((a, b) => {
      return getRoomDate(b) - getRoomDate(a);
    });

    rooms = this.props.rooms.map((room) => {
      return <MenuMessage key={room.id} room={room} />;
    });

    return (
      <div className="menu">
        <div className="header">
          <h3>Messages</h3>
          <button
            className="compose"
            onClick={this.createRoom.bind(this)}
          ></button>
        </div>

        <ul>{rooms}</ul>
      </div>
    );
  }
}

MenuContainer.defaultProps = {
  rooms: [],
};

const mapStateToProps = (state) => {
  return {
    rooms: state,
  };
};

const mapDispatchToProps = {
  setRooms,
  selectRoom,
  addRoom,
};

MenuContainer = connect(mapStateToProps, mapDispatchToProps)(MenuContainer);

export default MenuContainer;
