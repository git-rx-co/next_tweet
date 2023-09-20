const mongoose = require('mongoose');


const Message = mongoose.Schema({
    conversionid:{
        type:String,

    },
    msg:{
        type:String,
        
    },
    senderid:{
        type:String,

    },
    time:{
        type:Date,
        default:Date.now
    }
});

module.exports =  Message;