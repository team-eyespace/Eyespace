//Node Packages
const functions = require('firebase-functions');
const vision = require('@google-cloud/vision');

const admin = require('firebase-admin');
admin.initializeApp();

//Variables

const bucketName = 'stepify';
const srcFilename = 'busticket.jpg';
const destFilename = '/tmp/busticket.jpg';


const {
  Storage
} = require('@google-cloud/storage');
const projectId = 'web-search-3a00b';

const storage = new Storage({
  projectId: projectId,
});


const client = new vision.ImageAnnotatorClient({
  projectId: 'web-search-3a00b',
  keyFilename: './Web-Search-3baaad80cafd.json',
});


exports.myFunctionName = functions.firestore
  .document('tags/img').onWrite((change, context) => {
    //download image

    //(async () => {

    const options = {
      destination: destFilename,
    };

    await storage
      .bucket(bucketName)
      .file(srcFilename)
      .download(options);


    //})();


    //run cloud vision on image - upload tags on firebase
    client
      .labelDetection('/tmp/busticket.jpg')
      .then(results => {
        const labels = results[0].labelAnnotations;
        var jsonTag = labels[0].description;

        var firebaseData = {
          tag: jsonTag
        }

        var setDoc = db.collection('img').doc('value').set(firebaseData);

      })
      .catch(err => {
        console.error('ERROR:', err);
      });

  });