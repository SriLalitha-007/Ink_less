//console.log("Hello World");
//console.dart is basically print in dart
const express = require('express');
const mongoose = require('mongoose');
const cors = require("cors");
const http = require('http');

const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");


const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server);



app.use(cors({
    origin: '*',
    allowedHeaders: 'X-Requested-With, Content-Type, x-auth-token',

}));
app.use(express.json());
app.use(authRouter);//middleware
app.use(documentRouter);

const DB = "mongodb+srv://SriLalitha:Applekai2004@cluster0.pazsiku.mongodb.net/?retryWrites=true&w=majority";


mongoose.connect(DB).then(() => {
    console.log('mongo db connection successful!');
}).catch((err) => {
    console.log(err)

});

//async -> await
// .then((data)) => print(data )

io.on("connection", (socket) => {
    console.log('123456789');
    socket.on("join", (documentId) =>{
        socket.join(documentId);
        console.log("joined!");
    });
});

// io.on("error", (socket) => {
//     socket.on("join", (documentId) =>{
//         socket.join(documentId);
//         console.log("joined!");
//     });
// });

server.listen(PORT, "0.0.0.0", function () {
    console.log(`connected at port ${PORT}`);
});
