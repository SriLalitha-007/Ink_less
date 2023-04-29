const express = require("express");
const User = require("../models/user");


const authRouter = express.Router();
authRouter.post("/api/signup",async(req, res)=>{
    try{
       const {name, email, profilePic}= req.body;
        //email already exists?
       let user = await User.findOne({email: email});
       
       if(!user){
        user= new User({
            email,
            profilePic,
            name,
        });
        user = await user.save();
       }
       //store data
       res.json({ user });//404
    } catch(e){
       res.status(500).json({error: e.message});
    }
});

module.exports = authRouter;