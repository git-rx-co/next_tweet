const mongoose = require('mongoose');

const User = mongoose.Schema({
    username:{
        type:String,
    },
    email:{
        type:String,
        require:[true,"email is required"],
        unique:true,
    },
     password:{
        type:String,
        require:[true,"password is required"],
       
    },
    userProfile:{
        type:String,
        
    },

},{timeStemp:true});

module.exports = User;