const automl = require('@google-cloud/automl');

const predictionClient = new automl.PredictionServiceClient({
    projectId: 'stepify-solutions',
    keyFilename: './Stepify-439387aa8ef3.json',
});

const project = 'stepify-solutions';
const region = 'us-central1';
const automl_model = 'ICN4347665193349957054';

const fs = require('fs');
let buff = fs.readFileSync('./test.jpg');  
let base64data = buff.toString('base64');

callAutoMLAPI(base64data);

function callAutoMLAPI(b64img) {
    return new Promise((resolve, reject) => {
        const payload = {
            "image": {
              "imageBytes": b64img
            }
          }
        const reqBody = {
            name: predictionClient.modelPath(project, region, automl_model),
            payload: payload
        }
        predictionClient.predict(reqBody)
            .then(responses => {
                console.log('Got a prediction from AutoML API!', JSON.stringify(responses));
                resolve(responses);
            })
            .catch(err => {
                console.log('AutoML API Error: ',err);
                reject(err);
            });
    });
    
}