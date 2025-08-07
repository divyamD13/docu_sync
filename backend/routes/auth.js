const express = require("express");

const authRouter = express();

authRouter.post("/api/signup", async(req,res)=>{
    try{
        const {name, email, profilePic} = req.body;

        let user = await User.findOne({email: email});

        if(!user){
            user = new User({
                name,
                email,
                profilePic
            });

            await user.save();
        }
        
        res.json({user});
    }catch(e){

    }
})