import express from 'express'
import cors from 'cors'
import mongoose from 'mongoose'
require('dotenv').config()

const {PORT} = process.env

const app = express()
app.use(cors())
app.use(express.json()) //body-parser와 동일

// DB
// mongoose.connect(
//   'mongodb://localhost/test',
//   {
//     useNewURLParser: true,
//     useFindAndModify: false,
//     useUnifiedTopolgy: true
//   }
// )


// app.get('/', (req, res) => {
//   res.send('Hello')
// })

app.listen(PORT, (err) => console.log(err))