var express = require("express");
var jwt = require("jsonwebtoken");
var sqlite = require("sqlite3");
const bodyparser = require("body-parser");
var crypto = require("crypto");
const { response } = require("express");

const KEY = "MySecretKey";
var db = new sqlite.Database("users.sqlite3");
var app = express();
app.use(bodyparser());

app.post("/signup", (req, res) => {
  var password = crypto
    .createHash("sha256")
    .update(req.body.password)
    .digest("hex");

  var payload = {
    username: req.body.username,
  };

  var token = jwt.sign(payload, KEY, {
    algorithm: "HS256",
    expiresIn: "15s",
  });

  console.log(token);

  // db.get("SELECT FROM users WHERE username = ?", [req.body.username], function (
  //   err,
  //   row
  // ) {
  //   if (row != undefined) {
  //     console.error("can't create user " + req.body.username);
  //     res.status(409);
  //     res.send("An user with that username already exists");
  //   } else {
  //     console.log("Can create user " + req.body.username);
  //     db.run("INSERT INTO users(username, password) VALUES (?, ?)", [
  //       req.body.username,
  //       password,
  //     ]);
  //     res.status(201);
  //     res.send("Success");
  //   }
  // });

  res.json(token);
});

app.post("/login", express.urlencoded(), function (req, res) {
  console.log(req.body.username + " attempted login");
  var password = crypto
    .createHash("sha256")
    .update(req.body.password)
    .digest("hex");
  db.get(
    "SELECT * FROM users WHERE (username, password) = (?, ?)",
    [req.body.username, password],
    function (err, row) {
      if (row != undefined) {
        var payload = {
          username: req.body.username,
        };

        var token = jwt.sign(payload, KEY, {
          algorithm: "HS256",
          expiresIn: "15s",
        });
        console.log("Success");
        res.send(token);
      } else {
        console.error("Failure");
        res.status(401);
        res.send("There's no user matching that");
      }
    }
  );
});

app.get("/data", function (req, res) {
  var str = req.get("Authorization");
  try {
    const x = jwt.verify(str, KEY, { algorithm: "HS256" });
    console.log(x);
    console.log("keshavkeshavkeshav");
    res.send("Very Secret Data");
  } catch (e) {
    console.log(e);

    console.log("erroir");
    res.status(401);
    res.send(e);
  }
});

let port = process.env.PORT || 3000;
app.listen(port, function () {
  return console.log(
    "Started user authentication server listening on port " + port
  );
});
