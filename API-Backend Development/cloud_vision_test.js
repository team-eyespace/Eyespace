// Imports the Google Cloud client library
const vision = require('@google-cloud/vision');

// Creates a client
const client = new vision.ImageAnnotatorClient({
  projectId: 'web-search-3a00b',
  keyFilename: './Web-Search-3baaad80cafd.json',
});

// Performs label detection on the image file
client
  .webDetection('./AI.jpg')
  .then(results => {
     const labels = results[0]["webDetection"];
     console.log(labels["webEntities"][0].description);

    //console.log('Labels:');
    //labels.forEach(label => console.log(label.description));
    //console.log(labels[0].description);

  })
  .catch(err => {
    console.error('ERROR:', err);
  });