import express from 'express'

const app = express()

app.get('/', (req, res) => {
  res.json([
    {
      id: 1,
      name: 'K'
    },
    {
      id: 2,
      name: 'L'
    }
  ])
})

app.listen(5000, (err) => console.log(err))