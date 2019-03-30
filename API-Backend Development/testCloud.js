const vision = require('@google-cloud/vision');
const { Image } = require('canvas')

const client = new vision.ImageAnnotatorClient({
    projectId: 'stepify-solutions',
    keyFilename: './Stepify-439387aa8ef3.json',
});

const fs = require('fs');
let buff = fs.readFileSync('./busticket.jpg');  
let base64data = buff.toString('base64');

const myImage = new Image();
myImage.src = base64data;

let imdageData = "data:image/jpeg;base64," + base64data;

client
  .labelDetection(base64data)
  .then(results => {
    const labels = results[0].labelAnnotations;

    console.log('Labels:');
    labels.forEach(label => console.log(label.description));
  })
  .catch(err => {
    console.error('ERROR:', err);
  });

//console.log(myImage);
// const [result] = client.textDetection(myImage);
// const detections = result.textAnnotations;
// console.log(detections);

const getInfo = async () => {
    const [result] = await client.textDetection(myImage);
    const detections = result.textAnnotations;
    console.log("Tags collected");
    let jsonValues = [];
    try {
        detections.forEach(texts => { 

            console.log(texts.description);
        });
    

    }
    catch(error) {
        console.log(error);
    };
    
}
//getInfo();