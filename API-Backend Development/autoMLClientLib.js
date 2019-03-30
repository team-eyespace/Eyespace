const automl = require('@google-cloud/automl');
  const fs = require('fs');

  // Create client for prediction service.
  const client = new automl.PredictionServiceClient();

  /**
   * TODO(developer): Uncomment the following line before running the sample.
   */

  const projectId = 'stepify-solutions';
  const computeRegion = 'us-central1';
  const modelId = 'ICN4347665193349957054';
  const filePath = './busticket.jpg';
  //const scoreThreshold = '0.5';

  // Get the full path of the model.
  const modelFullId = client.modelPath(projectId, computeRegion, modelId);

  // Read the file content for prediction.
  const content = fs.readFileSync(filePath, 'base64');

  const params = {};

  // Set the payload by giving the content and type of the file.
  const payload = {};
  payload.image = {imageBytes: content};

  // params is additional domain-specific parameters.
  // currently there is no additional parameters supported.
  
  const autoMLprediction = async () => {
    try {
      const [response] = await client.predict({
        name: modelFullId,
        payload: payload,
        params: params,
      });
      console.log(`Prediction results:`);
      response.payload.forEach(result => {
        console.log(`Predicted class name: ${result.displayName}`);
        console.log(`Predicted class score: ${result.classification.score}`);
      });
  
    }
    catch(error) {
      console.error(error);
    };
    
  }

  autoMLprediction();
  




























// const automl = require('@google-cloud/automl').v1beta1;


// const fs = require('fs');
// let buff = fs.readFileSync('./test.jpg');  
// let base64data = buff.toString('base64');


// const client = new automl.v1beta1.PredictionServiceClient({
//   keyFilename: './Stepify-439387aa8ef3.json',
// });

// const formattedName = client.modelPath('stepify-solutions', 'us-central1', 'ICN4347665193349957054');
// const payload = {
//   image:{
    
//     imageBytes: base64data  
  
//   } 
// };

// const request = {
//   name: formattedName,
//   payload: payload,
// };

// client.predict(request)
//   .then(responses => {
//     const response = responses[0];
//     console.log(response);
//   })
//   .catch(err => {
//     console.error(err);
//   });


// const automl = require('@google-cloud/automl').v1beta1;

// // Create client for prediction service.
// const client = new automl.PredictionServiceClient({
//   projectId: 'stepify-solutions',
//   keyFilename: './Stepify-439387aa8ef3.json',

// });

// /**
//  * TODO(developer): Uncomment the following line before running the sample.
//  */

// const projectId = "stepify-solutions";
// const computeRegion = "us-central1";
// const modelId = "ICN4347665193349957054";
// // const filePath = `local text file path of content to be classified, e.g. "./resources/test.txt"`;
// //const scoreThreshold = "0.5";

// // Get the full path of the model.
// const modelFullId = client.modelPath(projectId, computeRegion, modelId);

// // Read the file content for prediction.
// //const content = fs.readFileSync(filePath, 'base64');

// const params = {};



// const fs = require('fs');
// let buff = fs.readFileSync('./test.jpg');  
// let base64data = buff.toString('base64');


// // Set the payload by giving the content and type of the file.
// const payload = {};
// payload.image = {imageBytes: base64data};

// // params is additional domain-specific parameters.
// // currently there is no additional parameters supported.

// const getInfo =  async () => {
    
//       try {  
//       const [response] = await client.predict({
//             name: modelFullId,
//             payload: payload,
//             params: params,
//           });
//           console.log(`Prediction results:`);
//           response.payload.forEach(result => {
//             console.log(result.displayName);
//             console.log(result.classification.score);
//           });
//         }
//       catch(error) {
//         console.error(error);
//       };
// }
// getInfo();