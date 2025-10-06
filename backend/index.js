const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");
const Document = require("./models/document"); // <-- make sure this path is correct

const PORT = process.env.PORT || 3001;
const DB =
  "mongodb+srv://divyamdivesh13:b5QPqI8bIxMh29Mw@docusync.h9e77bb.mongodb.net/?retryWrites=true&w=majority&appName=DocuSync";

const app = express();
const server = http.createServer(app);

// ✅ Proper Socket.IO setup with CORS for web clients
const io = new Server(server, {
  cors: {
    origin: "*", // you can restrict this to your deployed frontend domain later
    methods: ["GET", "POST"],
  },
});

// Middlewares
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

// Connect to MongoDB
mongoose
  .connect(DB)
  .then(() => {
    console.log("✅ Database connected successfully");
  })
  .catch((err) => {
    console.error("❌ MongoDB connection error:", err);
  });

// ✅ Socket.IO logic
io.on("connection", (socket) => {
  console.log("🟢 A user connected:", socket.id);

  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log(`User joined room: ${documentId}`);
  });

  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data);
  });

  socket.on("save", async (data) => {
    await saveData(data);
  });

  socket.on("disconnect", () => {
    console.log("🔴 A user disconnected:", socket.id);
  });
});

// ✅ Save function
const saveData = async (data) => {
  try {
    let document = await Document.findById(data.room);
    if (!document) return;
    document.content = data.delta;
    await document.save();
  } catch (err) {
    console.error("Error saving document:", err);
  }
};

// ✅ IMPORTANT: Use server.listen (not app.listen)
server.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
