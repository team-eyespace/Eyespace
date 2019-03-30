var request = require('request');



var requestData = {
  "requests": [{
    "image": {
      "source": {
        "gcsImageUri": "gs://stepify/busticket.jpg"
      }
    },
    "features": [{
      "type": "LABEL_DETECTION"
    }]
  }]
}

var options = {
  uri: 'https://vision.googleapis.com/v1/images:annotate?key=3baaad80cafd7ef8bd5ec33e4f83392542093b58',
  method: 'POST',
  json: requestData
};

request(options, function(error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body.id) // Print the shortened url.
  } else {

    console.log("Error");
  }
});