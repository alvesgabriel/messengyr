import React from "react";
import ReactDOM from "react-dom";
import "whatwg-fetch";

import { createStore } from "redux";
import { Provider } from "react-redux";

import ChatContainer from "./components/chat-container";
import MenuContainer from "./components/menu-container";

import "../css/app.scss";
import "../css/header.scss";
import "../css/messages.scss";

import rooms from "./reducers";

import DATA from "./mock-data";

const store = createStore(rooms);

class App extends React.Component {
  render() {
    const ROOMS = DATA.rooms;
    const MESSAGES = DATA.rooms[0].messages;

    return (
      <div>
        {/* <MenuContainer rooms={this.state.rooms} />
        <ChatContainer messages={this.state.messages} /> */}
        <MenuContainer />
        <ChatContainer />
      </div>
    );
  }
}

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById("app")
);
