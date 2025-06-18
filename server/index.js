const express = require('express');
const path = require('path'); 
require('dotenv').config({ path: path.join(__dirname,  '..', 'config.env') })
const mongoose = require("mongoose");
const cors = require('cors');

const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');
const PORT = process.env.PORT || 3000;
const app = express();
const userName = process.env.DB_USERNAME;
const password = encodeURIComponent(process.env.DB_PASSWORD);


const DB = `mongodb+srv://${userName}:${password}@cluster0.1mrvp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
// middleware
app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

mongoose.connect(DB).then(()=>{
    console.log('Mongoose connected successfully');
}).catch((e) => {
    console.log(e);
})

app.get("/flutterzon" , (req, res) => {
    res.send("Welcome to Flutterzon!");
})

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port: ${PORT}`)
});


