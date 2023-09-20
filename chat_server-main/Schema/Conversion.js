const mongoose = require('mongoose');


const Conversion = mongoose.Schema({
    mambers:{
        type:Array,
    }
    ,
    time:{
        type:Date,
        default:Date.now
    }
});

module.exports = Conversion;