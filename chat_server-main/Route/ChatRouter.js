const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
// bcrypt = require('bcryptjs');
const {sign} = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const Authchack = require('../Middlware/AuthChack')
// Mongoose Schema

const UserSchema = require('../Schema/User')
const ConvvversionSchema = require('../Schema/Conversion')
const MessageSchema = require('../Schema/Message')


// Mongoose Model

const UserModel = mongoose.model("User", UserSchema);
const Conversion = mongoose.model("Conversion",ConvvversionSchema);
const MessageModel = mongoose.model("Message",MessageSchema);


// basr path

const baseurl = "v1/private-chat/api/v2/user/user-auth/ur";


// ..............MULTER ..............SET.UP


const storage = multer.diskStorage({
  destination:(res,file,cb)=>{
      cb(null,"./uplod/images");
  },
  filename:(req,file,cb)=>{
   const ext = path.extname(file.originalname);
   const org = file.originalname;
   const filename  =
   org.replace(ext,"")
   .toLowerCase()
    .split(" ")
    .join('-')+"-"+Date.now();
   cb(null,filename+ext);
  }
});

var uplod =  multer({
  storage:storage,
 fileFilter: (req,file,cb)=>{

     if(file.fieldname === 'img'){
         if(file.mimetype === "image/png"||
     file.mimetype === "image/jpg"||
     file.mimetype === "image/jpeg"

 ){
     cb(null,true);
 }else {
     cb("Its not image Formet try again");
 }
     }else if(file.fieldname === 'doc'){
         if(file.mimetype === "video/mp4"


 ){
     cb(null,true);
 }else {
     cb("Its not Video Formet try again");
 }
     }
 }
});

 // ........... USER REGISTER .............


router.post(`/${baseurl}/userregister`, async(req,res)=>{

      const username = req.body.username;
      const  email = req.body.email;
      const  password = await req.body.password;
      try{
        bcrypt.hash(password,10)
        .then(async(hashPassword)=>{
          console.log(hashPassword);
           const user =  UserModel({
               username:username,
               email:email,
               password:hashPassword,
               userProfile :''
           });
           const result = await user.save().catch((err)=>{
              res.status(200).json(err);
              console.log(`Error is : ${err}`);
          })
          console.log(result);
          if(result){
              res.status(200).json(result);
          }else{
              res.status(200).json("User data Not Valid");
          }

        }).catch((e)=>{
          console.log(e);
          res.status(200).json(`Have ERROR : ${e}`);
        });
      }catch(e){
        console.log(`Now Error is : ${e}`);
        res.status(500).json(`Have ERROR 2 : ${e}`);
      }


});

//.......... Register user Profile Update .........

  let useremail;
 
router.post(`/${baseurl}/userprofile`,uplod.single('img'),async(req,res)=>{
  

  console.log(req.body.email);
  console.log(req.file);
  const filename = `/file/images/${req.file.filename}`;
  console.log(`/file/images/${req.file.filename}`);
  console.log(req.body.email);


     const response = await UserModel.findOneAndUpdate({
       email:req.body.email
     },
    {
      $set: {
        userProfile: filename,
      }
    }
     );

      res.status(200).send(`image uoloded`);
} );
router.post(`/${baseurl}/userdata` ,async(req,res)=>{

  useremail = req.body.email;

        res.send("user data recived");
  } );



// .... ChackRoute ...............


router.post(`/okchack` ,async(req,res)=>{

 
  console.log(req.body.name);
  console.log(req.body.school);



        res.send("user data recived");
  } );


   
 // ........... USER LOGIN .............
router.post(`/${baseurl}/userlogin`,async(req,res)=>{
 
    const  email = req.body.email;
    const  password = req.body.password;
    console.log(email);

           const finduser = await UserModel.findOne({email:email}).catch((err)=>{ if(err){

            res.status(200).json(err);
        } });


         if(finduser){
            console.log(finduser);
            console.log(finduser.password);
            await bcrypt.compare(password,finduser.password)
            .then(async(result)=>{

              if(result){
                  const jwt = sign({username:finduser.username,id:finduser._id},"ruxzomprychat0971@ok");
                  if(jwt){
                    res.status(200).json({user:finduser,token:jwt,id:finduser._id});
                  }else{
                    res.status(500).json("Somthing Wrong");
                  }

              }else{
                  res.status(200).json("password not match");
              }

            });


         }else{
            res.status(200).json("user not Found");
         }


});
//................ All User Get ..........//
router.get(`/${baseurl}/alluser`, Authchack ,async(req,res)=>{
    console.log(req.body.id);

    const id = req.body.id;
    if(id){
         const user = await UserModel.find();
         res.status(200).json(user);
    }else{
         res.status(500).json("Sorry somthing rong")
    }
});
//................  Each User Get ..........//

router.post(`/${baseurl}/eachuser`, Authchack ,async(req,res)=>{
  console.log(`each block ${req.body.id}`);
  const userid = req.body.userid;
  const id = req.body.id;
  if(id){
    const finduser = await UserModel.findById(userid).catch((err)=>{ if(err){

      res.status(200).json(err);
  } });
  res.status(200).json(finduser);
  }else{
       res.status(200).json("Sorry somthing rong")
  }
});


// .................. ADD CONVERSION SCHEMA .................

router.post(`/${baseurl}/addconversion`, Authchack, async(req,res)=>{
  const mambers = req.body.mambers;
  console.log(mambers);
  if(mambers){
    const ConversionU = await Conversion({mambers:mambers});
    ConversionU.save();
    console.log(ConversionU);
    res.status(200).json(ConversionU);
  }else{
    res.status(200).json('Sorry somthings wrong');
  }

})

// .................. GET CONVERSION SCHEMA .................

router.post(`/${baseurl}/conversions`, Authchack, async(req,res)=>{
  const mambersid = req.body.cid;
  console.log(mambersid);
  if(mambersid){
    const ec =  await Conversion.find({mambers:{$in:[mambersid]}})
    // .catch((e)=>console.log(e))
    console.log(ec);
    res.status(200).json(ec);


  }else{
    res.status(500).json('Sorry somthings wrong');
  }

})
//................ Set Message onMongodb ..........//

router.post(`/${baseurl}/addmessage`, Authchack,async(req,res)=>{
   console.log(req.body.id);
  const conversionId = req.body.conversionid;
  const msg = req.body.msg;
  console.log(msg);
  // const conversionId = req.body.conversionid;
  // const conversionId = req.body.conversionid;

  if(msg != null){
    const msgIn = await MessageModel({
      conversionid:conversionId,
      msg:msg,
      senderid:req.body.id
    
    });
   await msgIn.save();
 
    console.log(msgIn);
    res.status(200).json(msgIn);
  }else{
    res.status(200).json('Sorry somthings wrong');
  }

});
//................ Get Message onMongodb ..........//

router.get(`/${baseurl}/getmessage`, Authchack,async(req,res)=>{
  console.log(req.body.id);
 const conversionId = req.header('id');
  
 console.log(conversionId);
 // const conversionId = req.body.conversionid;
 // const conversionId = req.body.conversionid;

 if(conversionId != null){
   const getCMsg = await MessageModel.find({conversionid:conversionId});
 
   console.log(getCMsg);
   res.status(200).json(getCMsg);
 }else{
   res.status(200).json('Sorry somthings wrong');
 }

});
module.exports = router;
