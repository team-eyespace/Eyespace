var http = require('http');
    var server = http.createServer ( function(request,response){

    response.writeHead(200,{"Content-Type":"text\plain"});
    
    if(request.method == "POST")
        {
            // collectRequestData(req, result => {
            //     console.log(result);
            //     res.end(`Parsed data belonging to`);
            // });
            
            response.end("received POST request.");
            console.log("POST Received Server Side");
        }
    else
        {
            response.end("Undefined request .");
        }
});

server.listen(80);
console.log("Server running on port 80");