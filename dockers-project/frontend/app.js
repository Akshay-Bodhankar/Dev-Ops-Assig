const express = require("express");
const axios = require("axios");
const app = express();

app.set("view engine", "ejs");
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.render("form");
});

app.post("/submit", async (req, res) => {
  try {
    await axios.post("http://backend:5000/submittodoitem", req.body);
    res.send("Data sent to backend successfully!");
  } catch (err) {
    res.send("Error sending data");
  }
});

app.listen(3000, () => console.log("Frontend running on port 3000"));