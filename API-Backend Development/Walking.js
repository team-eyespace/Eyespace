// Imports the Google Cloud client library
const vision = require('@google-cloud/vision');

// Creates a client
const client = new vision.ImageAnnotatorClient({
    projectId: 'stepify-solutions',
    keyFilename: './Stepify-439387aa8ef3.json',
});

// Performs label detection on the image file
client
  .labelDetection('./test.jpg')
  .then(results => {
    const labels = results[0].labelAnnotations;

    labels.forEach(label => {

        if(label.description == "Road") {
            console.log(label.description);
        }
    }  
    );
  })
  .catch(err => {
    console.error('ERROR:', err);
  });