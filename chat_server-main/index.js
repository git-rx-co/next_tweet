require('dotenv').config();
const express = require('express');
const app = express();
const path = require('path');
const PORT = process.env.PORT;
const mongoose = require('mongoose');
const cors = require('cors');
const ChatRouter = require('./Route/ChatRouter');
const router = express.Router();
const http = require('http');
const server = http.createServer(app);
const io = require("socket.io")(server);


// app use pluge

app.use(cors());
app.use(express.json());
app.use('/chat',ChatRouter);
app.use('/file', express.static(path.join(__dirname, 'uplod')));
app.get('/',(req,res)=>{
    return res.send('ok heroku');
})
// route



// mongoose Connected
// live server url = "mongodb+srv://raselislam:raselislam@cluster0.pek3u.mongodb.net/chat?retryWrites=true&w=majority"

mongoose.connect("mongodb+srv://raselislam:raselislam@cluster0.pek3u.mongodb.net/chat?retryWrites=true&w=majority",
{ useUnifiedTopology: true , useNewUrlParser: true},
   ()=>{
    console.log("Mongoose is Connected");}
)


 app.get('/',(req,res)=>{
    console.log("server response");
})

//user id and socket id Lst 

let user = [];

// add user
 const adduser = (userId,socketId)=>{
     !user.some(user=>user.userId === userId)
       user.push({userId,socketId});
}
// remove user
const removeuser = (socketId) =>{
    user = user.filter((user)=>user.socketId !== socketId );
}
//find user
const finsuder = (userId)=>{
    return user.find((user)=>user.userId === userId);
}

// Socket IO Connection 

io.on("connection", (socket) => {
 
    console.log(" Auser Connetct");
    console.log(`Socket is ${socket.id}`);

    socket.on('data',(data)=>{
        console.log(data);
    });
    socket.on('adduser',(userId)=>{
        adduser(userId,socket.id);
        socket.emit('getuser',user);
        console.log(user);
    })
  
    socket.on('disconnect', function (user) {
          removeuser(socket.id);
         console.log(user);

  
    });
    socket.on('sendmsg',({senderId,resiverId,msg})=>{
        console.log(msg)
        const Fuser =  finsuder(resiverId);
         console.log(`resivaer socket ${Fuser}`);
        if(Fuser != null){
            socket.to(Fuser.socketId).emit('sendmessage',{senderId,msg});
        }else{
            console.log('User Not active');
        }
       
    })
   
  });

 
// Express Server Run

server.listen(PORT,"0.0.0.0",()=>{
    console.log(`Server Run port is ${PORT} And Socket is Started`)
})