import { Mongoose } from "mongoose";

mongoose.connect('mongodb://localhost:27017/test')
  .then(()=>console.log("Connected to MongoDB"))
  .catch((err)=> console.log(err));


const ImageQuizSchema = new mongoose.Schema({
    image: {
        type: String,
    },
    answer:{
        type: String,
        trim: true
    },
})

const ImageQuiz = mongoose.model("ImageQuiz", ImageQuizSchema)

export default ImageQuiz;

