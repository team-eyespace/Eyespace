var http = require('http');
var option = {
    //hostname : "34.73.7.219" ,
    hostname: "localhost", //compute engine IP protected credentials 34.73.7.219
    port : 80, //port number for http requests (non local hosts) # reference
    method : "POST",
    path : "/"
} 

    var request = http.request(option , function(resp){
       resp.on("data",function(chunck){
           console.log(chunck.toString());
       }) 
    })
    request.on('error', function(err){
        console.log("error");
    });
    //request.write(postData);
    request.end();
