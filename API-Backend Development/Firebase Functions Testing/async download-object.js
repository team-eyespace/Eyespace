// Imports the Google Cloud client library
const {
  Storage
} = require('@google-cloud/storage');

// Creates a client
const projectId = 'web-search-3a00b';

// Creates a client
const storage = new Storage({
  projectId: projectId,
});

/**
 * TODO(developer): Uncomment the following lines before running the sample.
 */
const bucketName = 'stepify';
const srcFilename = 'busticket.jpg';
const destFilename = './busticket.jpg';

(async () => {

  const options = {
    // The path to which the file should be downloaded, e.g. "./file.txt"
    destination: destFilename,
  };

  // Downloads the file
  await storage
    .bucket(bucketName)
    .file(srcFilename)
    .download(options);


})();

console.log(
  `gs://${bucketName}/${srcFilename} downloaded to ${destFilename}.`
);