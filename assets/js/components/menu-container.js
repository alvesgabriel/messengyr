import React from "react";
import ReactDOM from "react-dom";

import { connect } from "react-redux";

import MenuMessage from "./menu-message";

import { setRooms, selectRoom } from "../actions";

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

  render() {
    let rooms = this.props.rooms.map((room) => {
      return <MenuMessage key={room.id} room={room} />;
    });

    return (
      <div className="menu">
        <div className="header">
          <h3>Messages</h3>
          <button className="compose"></button>
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
};

MenuContainer = connect(mapStateToProps, mapDispatchToProps)(MenuContainer);

export default MenuContainer;
