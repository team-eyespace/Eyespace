'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const chrono = require('chrono-node');
const keyFile = require('./key.js');
const request = require('request');
const automl = require('@google-cloud/automl');
admin.initializeApp();

/*

  Cloud functions Catalog 

  detectIntent(data, context) : Dialogflow

  detectOCR(data, context) : For bus tickets, date and time detection

  detectGenContext(data, context) : General Context Tags  

  detectPothole(data, context) : Detecting potholes with autoMl API

  getTranslate : Helper Function for Translating strings for every language

*/

exports.detectIntent = functions.https.onCall((data, context) => {

  const dialogflow = require('dialogflow');

  const sessionClient = new dialogflow.SessionsClient();

  if (!data.query || !data.query.length) {
    return 'Bad Request';
  }
  const sessionPath = sessionClient.sessionPath(data.projectID, data.sessionID);

  let promise;

  // The text query request.
  const request = {
    session: sessionPath,
    queryInput: {
      text: {
        text: data.query,
        languageCode: data.languageCode,
      },
    },
  };

  console.log(`Sending query "${data.query}"`);
  promise = sessionClient.detectIntent(request);

  try {
    console.log('Detected intent');
    return (promise);
  } catch (err) {
    console.error('ERROR: ' + err);
  }
});

exports.detectOCR = functions.https.onCall((data, context) => {

  //data.query being the base64 encoded string

  const vision = require('@google-cloud/vision');
  const client = new vision.ImageAnnotatorClient();

  const request = {
    image: {
      content: data.query
    }
  };

  return client.textDetection(request).then(response => {

    let jsonAPIresponse = response[0].textAnnotations;
    let jsonValues = [];

    console.log("OCR tags collected");

    for (let i in jsonAPIresponse) {

      try {
        let chronoResult = chrono.parse(jsonAPIresponse[i].description);
        jsonValues.push(chronoResult[0].text);


      } catch (error) {
        continue;
      };

    }

    let timeValues = {};

    for (let i in jsonAPIresponse) {
      try {

        let chronotimeResult = chrono.parse(jsonAPIresponse[i].description);
        timeValues[chronotimeResult[0].start.knownValues.hour] = chronotimeResult[0].start.knownValues.minute;

      } catch (error) {
        continue;
      };

    }

    console.log("Parsed date and time")

    let hour = 200;
    let minute = 0;

    for (let timeKey in timeValues) {
      try {

        if (timeKey != undefined && timeValues[timeKey] != undefined && timeKey < hour) {

          hour = timeKey;
          minute = timeValues[timeKey];

        }

      } catch (error) {
        continue;
      };
    }

    let highest = 0;
    let finalDate;
    for (let i = 0; i < jsonValues.length; i++) {

      if (jsonValues[i].length > highest) {

        highest = jsonValues[i].length;
        finalDate = jsonValues[i];

      }

    }
    finalDate = finalDate.trim();

    if (hour == 200) {

      hour = 0;

    }
    let time = hour + ":" + minute;

    console.log("Date: " + finalDate);
    console.log("Time: " + time);

    let finalResponse = "The date detected is " + finalDate + " The time detected is " + time;

    console.log(finalResponse);

    return finalResponse;


  });


});


exports.detectPothole = functions.https.onCall((data, context) => {

  const client = new automl.PredictionServiceClient();
  const projectId = 'stepify-solutions';
  const computeRegion = 'us-central1';
  const modelId = 'ICN4347665193349957054';

  const modelFullId = client.modelPath(projectId, computeRegion, modelId);
  const params = {};
  const payload = {};
  payload.image = {
    imageBytes: data.query
  };

  return client.predict({
    name: modelFullId,
    payload: payload,
    params: params,
  }).then(response => {

    console.log("Response from autoML API: " + reponse.payload);

    if (response.payload[0].displayName == "Pothole") {

      return "true";

    } 
    
    else {

      return "false";

    }

  });

});

exports.detectGenContext = functions.https.onCall((data, context) => {

  const vision = require('@google-cloud/vision');
  const client = new vision.ImageAnnotatorClient();

  const request = {
    image: {
      content: data.query
    }
  };

  return client.labelDetection(request)
    .then(response => {

      let jsonAPIResponse = response[0].labelAnnotations;
      let jsonValues = [];
      let generalContext = "";

      console.log("General Context Tags Collected");

      for (let i in jsonAPIResponse) {

        jsonValues.push(jsonAPIResponse[i].description);

      }

      for (let i = 0; i < 5; i++) {

        if (jsonValues[i] != undefined) {

          generalContext = generalContext + jsonValues[i] + " ";

        }

      }

      generalContext = "The following are present in the scene " + generalContext;

      return generalContext;
    });

});

const getTranslate = async (inputString) => {

  let text = inputString
  const {
    Translate
  } = require('@google-cloud/translate');

  const translate = new Translate({
    projectId: 'stepify-solutions',
    keyFilename: './Stepify-439387aa8ef3.json'
  });

  const target = 'pt';

  const [translation] = await translate.translate(text, target);

  return translation;

}