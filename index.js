const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("<h1>Hello from node, Hope you are doing well!</h1>");
});

const port = 3000 || process.env.PORT;

app.listen(port, () => {
  console.log("listening on port :", port);
});
