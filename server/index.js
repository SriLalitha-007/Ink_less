//console.log("Hello World");
//console.dart is basically print in dart
const express = require('express');
const mongoose = require('mongoose');
const authRouter = require("./routes/auth");


const PORT = process.env.PORT | 3001;

const app = express();

app.use(express.json());
app.use(authRouter);//middleware

const DB = "mongodb+srv://SriLalitha:Applekai2004@cluster0.pazsiku.mongodb.net/?retryWrites=true&w=majority";



mongoose.connect(DB).then(() => {
    console.log('connection successful!');
}).catch((err) => {
    console.log(err)

});

//async -> await
// .then((data)) => print(data )

app.listen(PORT, "0.0.0.0", function () {
    console.log(`connected at port ${PORT}`);
});
