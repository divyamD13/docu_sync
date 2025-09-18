const express = require('express');
const  mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');

const PORT = process.env.PORT || 3001;

const app = express();
app.use(cors());
app.use(express.json());
app.use(authRouter);

const DB ="mongodb+srv://divyamdivesh13:b5QPqI8bIxMh29Mw@docusync.h9e77bb.mongodb.net/?retryWrites=true&w=majority&appName=DocuSync";

mongoose.connect(DB).then(()=>{
    console.log("Database connected successfully");
}).catch((err) => {
    console.error(err);
});



app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
