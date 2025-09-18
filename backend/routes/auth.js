const express = require("express");
const User = require("../models/user");
const jwt = require("jsonwebtoken");
const authRouter = express();
const auth = require("../middlewares/auth");

authRouter.post("/api/signup", async(req,res)=>{
    try{
        const {name, email, profilePic} = req.body;

        let user = await User.findOne({email: email});

        if(!user){
            user = new User({
                name:name,
                email:email,
                profilePic:profilePic
            });

            user = await user.save();
        }
         const token = jwt.sign({ id: user._id }, "passwordKey");

        res.json({user:user, token: token});
    }catch(err){
        res.status(500).json({ error: err.message });
    }
});

authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ user, token: req.token });
});

module.exports = authRouter;