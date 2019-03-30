var admin = require("firebase-admin");

var serviceAccount = require("path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "stepify.appspot.com"
});

var bucket = admin.storage().bucket();

// Imports the Google Cloud client library
// const {
//   Storage
// } = require('@google-cloud/storage');
//
// // Creates a client
// const storage = new Storage();

/**
 * TODO(developer): Uncomment the following lines before running the sample.
 */
const bucketName = 'stepify';
const filename = './hello/jpg';

// Uploads a local file to the bucket
await storage.bucket(bucketName).upload(filename, {
  // Support for HTTP requests made with `Accept-Encoding: gzip`
  gzip: true,
  metadata: {
    // Enable long-lived HTTP caching headers
    // Use only if the contents of the file will never change
    // (If the contents will change, use cacheControl: 'no-cache')
    cacheControl: 'private, max-age=0',
  },
});

console.log(`${filename} uploaded to ${bucketName}.`);