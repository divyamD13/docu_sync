const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const http = require("http");
const socketIO = require("socket.io");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const Document = require("./models/document");

const PORT = process.env.PORT || 3001;
const DB =
  "mongodb+srv://divyamdivesh13:b5QPqI8bIxMh29Mw@docusync.h9e77bb.mongodb.net/?retryWrites=true&w=majority&appName=DocuSync";

const app = express();
const server = http.createServer(app);

// Configure Socket.IO
const io = socketIO(server, {
  cors: {
    origin: "*", // You can replace '*' with your Flutter web URL in production
    methods: ["GET", "POST"],
  },
});

// Middlewares
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

// MongoDB connection
mongoose
  .connect(DB)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err));

// Socket.IO connection
io.on("connection", (socket) => {
  console.log("User connected:", socket.id);

  // Join a document room
  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log(`User joined room: ${documentId}`);
  });

  // Typing / collaborative changes
  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data);
  });

  // Auto-save
  socket.on("save", async (data) => {
    try {
      const document = await Document.findById(data.room);
      if (!document) return console.error("Document not found");
      document.content = data.delta;
      await document.save();
      console.log("Document saved:", data.room);
    } catch (err) {
      console.error("Error saving document:", err);
    }
  });

  // Disconnect
  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });
});

// Start server
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
