const express = require("express");
const axios = require("axios");
const app = express();

app.set("view engine", "ejs");
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

/*


CASE 1: (Single EC2)
----------------------------------------
Frontend + Backend running on SAME EC2
Backend is on the same machine  use localhost

*/

//task1
//const BACKEND_URL = "http://localhost:5000";

/*
CASE 2:  (Separate EC2 Instances)
----------------------------------------
Frontend runs on EC2-B
Backend runs on EC2-A
Use BACKEND EC2 PUBLIC IP

Example:
const BACKEND_URL = "http://18.xxx.xxx.xxx:5000";


-
- Replace IP with your backend EC2 public IP
*/

//const BACKEND_URL = "http://BACKEND_EC2_PUBLIC_IP:5000";

//task 2
//const BACKEND_URL = ":http://3.87.95.220:5000 ";

//task 3
const BACKEND_URL = "http://3.236.149.113:5000";


  // HOME PAGE

app.get("/", (req, res) => {
  res.render("index", {
    result: null,
    items: null,
    count: null,
    error: null
  });
});


  // ADD ITEM

app.post("/submit", async (req, res) => {
  let resultData = null;

  try {
    const response = await axios.post(`${BACKEND_URL}/submit`, {
      item_id: req.body.item_id,
      name: req.body.name,
      description: req.body.description
    });

    resultData = response.data;

  } catch (err) {
   
    console.error("Backend response issue (non-fatal):", err.message);
  }

  if (resultData && resultData.status === "success") {
    return res.render("index", {
      result: resultData,
      items: null,
      count: null,
      error: null
    });
  }

  return res.render("index", {
    result: null,
    items: null,
    count: null,
    error: "Submission processed, but confirmation was not received"
  });
});

   //VIEW ALL ITEMS

app.get("/items", async (req, res) => {
  try {
    const response = await axios.get(`${BACKEND_URL}/items`);
    res.render("index", {
      result: null,
      items: response.data,
      count: null,
      error: null
    });
  } catch (err) {
    res.render("index", {
      result: null,
      items: null,
      count: null,
      error: "Failed to load items"
    });
  }
});


   //COUNT ITEMS

app.get("/count", async (req, res) => {
  try {
    const response = await axios.get(`${BACKEND_URL}/count`);
    res.render("index", {
      result: null,
      items: null,
      count: response.data.total_items,
      error: null
    });
  } catch (err) {
    res.render("index", {
      result: null,
      items: null,
      count: null,
      error: "Failed to count items"
    });
  }
});


  // FIND ITEM BY ID

app.post("/find", async (req, res) => {
  try {
    const response = await axios.get(
      `${BACKEND_URL}/items/${req.body.search_id}`
    );

    res.render("index", {
      result: { item: response.data },
      items: null,
      count: null,
      error: null
    });
  } catch (err) {
    res.render("index", {
      result: null,
      items: null,
      count: null,
      error: "Item not found"
    });
  }
});


   //START SERVER

app.listen(3000, () => {
  console.log("Frontend running on port 3000");
});
