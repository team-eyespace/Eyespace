const request = require('request');

const fs = require('fs');
let buff = fs.readFileSync('./test.jpg');  
let base64data = buff.toString('base64');

var options = {
    uri:'https://automl.googleapis.com/v1beta1/projects/stepify-solutions/locations/us-central1/models/ICN4347665193349957054:predict',
    method:'POST',
    json:{
        "payload": {
          "image": {
            "imageBytes": base64data
          }
        }
      },
    keyFilename: 'stepifyCloudVisionAuth.json'
};  

request(options, function (error, response, body) {
    try {
            
        console.log(response.body);

    }
    catch(error) {
        console.error(error);
    };
        
});

