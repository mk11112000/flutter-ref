const express = require("express");
const upload = require("express-fileupload");
const ipfs = require("./ipfs");
const port = 3000;
const app = express();
app.use(upload());

app.post("/", async (req, res) => {
  console.log("req recieved");
  if (req.files) {
    try {
      console.log(req.files);
      const response = await ipfs.add(req.files.file.data);
      console.log(response);
    } catch (error) {
      console.log(error);
    }
  } else {
    console.log("noFiles");
  }

  res.json({ Hello: "World!" });
});
app.listen(port, () => console.log(`Example app listening on port 3000!`));
