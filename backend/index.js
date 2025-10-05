const express = require('express');
const  mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const documentRouter = require('./routes/document');
const cors = require('cors');
const http = require('http');
const PORT = process.env.PORT || 3001;

const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);
const DB ="mongodb+srv://divyamdivesh13:b5QPqI8bIxMh29Mw@docusync.h9e77bb.mongodb.net/?retryWrites=true&w=majority&appName=DocuSync";

mongoose.connect(DB).then(()=>{
    console.log("Database connected successfully");
}).catch((err) => {
    console.error(err);
});

io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
  });

  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data);
  });

  socket.on("save", (data) => {
    saveData(data);
  });
});

const saveData = async (data) => {
  let document = await Document.findById(data.room);
  document.content = data.delta;
  document = await document.save();
};

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
