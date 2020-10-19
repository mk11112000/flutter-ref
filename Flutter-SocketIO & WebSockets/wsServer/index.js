const express = require("express");
const http = require("http");
const socketio = require("socket.io");
const WebSocket = require("ws");

const server = http.createServer((req, res) => {
  res.end("Connected");
});

const wss = new WebSocket.Server({ server });
wss.on("headers", (headers, req) => {
  console.log(headers);
});

wss.on("connection", (ws, req) => {
  console.log("Conbnect");
  ws.send("Connected");
  ws.on("message", (msg, req) => {
    console.log("message");
    console.log(msg);
  });
});

server.listen(8000, () => {
  console.log(`Server running 🔥`);
});
