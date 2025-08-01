const express = require('express');
const  mongoose = require('mongoose');

const PORT = process.env.PORT || 3001;

const DB = process.env.MONGODB_URI || "";

mongoose.connect(DB).then(()=>{
    console.log("Database connected successfully");
}).catch((err) => {
    console.error(err);
});

const app = express();

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
