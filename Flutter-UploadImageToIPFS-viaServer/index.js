var expess = require("express");
var bodyParser = require("body-parser");
var fs = require("fs");
const IPFS = require("ipfs-api");
var app = expess();
const ipfs = new IPFS({
  host: "ipfs.infura.io",
  port: 5001,
  protocol: "https",
});

app.use(bodyParser.urlencoded({ extended: true, limit: "50mb" }));

app.post("/image", function (req, res) {
  var name = req.body.name;
  var img = req.body.image;
  var realFile = Buffer.from(img, "base64");
  ipfs.files.add(realFile, (e, result) => {
    if (e) console.log(e);
    else {
      console.log(result);

      res.send(result);
    }
  });
  fs.writeFile(name, realFile, function (err) {
    if (err) console.log(err);
  });
});

app.listen(3000);



/*To add json

const IPFS = require("ipfs-api");
const ipfs = new IPFS({
  host: "ipfs.infura.io",
  port: 5001,
  protocol: "https",
});

const input = [
  {
    id: "0x10",
    date: "14.07.2018",
  },
  {
    id: "0x20",
    date: "14.07.2018",
  },
  {
    id: "0x30",
    date: "14.07.2018",
  },
];

ipfs.files
  .add(Buffer.from(JSON.stringify(input)))
  .then((res) => {
    const hash = res[0].hash;
    console.log("added data hash:", hash);
    return ipfs.files.cat(hash);
  })
  .then((output) => {
    console.log("retrieved data:", JSON.parse(output));
  });

*/
