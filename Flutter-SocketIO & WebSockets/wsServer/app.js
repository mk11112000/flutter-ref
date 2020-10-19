//socket.io Implementation
const express = require("express");
const http = require("http");
const socketio = require("socket.io");

const app = express();

const port = process.env.PORT || 5000;

const expressServer = app.listen(port, () => {
  console.log(`Server running on port ${port} 🔥`);
});
const io = socketio(expressServer);

app.get("/", (req, res) => {
  io.emit("messageFromServer", { data: "Welcome" });
  res.send("data");
});

io.on("connect", (socket) => {
  console.log("connect");
  socket.emit("messageFromServer", { data: "Welcome" });
  socket.on("dataToServer", (data) => {
    console.log(data);
  });
});
