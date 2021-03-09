import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.jwtToken } });

socket.connect();

export default socket;
