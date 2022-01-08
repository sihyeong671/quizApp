import mongoose from "mongoose";
import validator from "express-validator";


mongoose.connect('mongodb://localhost:27017/test')
  .then(()=>console.log("Connected to MongoDB"))
  .catch((err)=> console.log(err))

const UserSchema = new mongoose.Schema({
    nickName:{
        type: String,
        trim: true
    },
    img:{
        type: String,
    },
    score:{
        type: Number,
        default: 0
    },
    createdDay: {
        type: Date,
        default: Date.now
    }
})

const Users = mongoose.model("User", UserSchema)

// module.exports = User;

export default Users;

