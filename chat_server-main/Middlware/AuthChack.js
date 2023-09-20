const {verify} = require('jsonwebtoken');


const Authchack = (req,res,next)=>{
    const token = req.header('token');
    if(token){
        verify(token,"ruxzomprychat0971@ok",(err,result)=>{
            if(err){
        res.status(500).json({msg:"User not Authencationated",err:err});

            }else if(result){
                console.log(`username : ${result.username} id:${result.id}`);
               req.body.id = result.id;
               req.body.username = result.username;
               next();
            }else{
                 res.status(500).json({msg:"User not Authencationated"});

            }
        })
    }else{
        res.status(500).json({msg:"User not Authencationated"});
    }
};

module.exports = Authchack;