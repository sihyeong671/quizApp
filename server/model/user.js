import mongoose from "mongoose";
// const mongoose = require('mongoose');
import validator from "express-validator";

const UserSchema = new mongoose.Schema({
    nickName:{
        type: String,
        trim: true,
        unique: true
    },
    // img:{
    //     data: Buffer,
    //     contentType: String
    // },
    createdDay: {
        type: Date,
        default: Date.now
    }
})

const User = mongoose.model("User", UserSchema)

// module.exports = User;

export default User;

