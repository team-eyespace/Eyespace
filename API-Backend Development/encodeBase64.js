'use strict';

const fs = require('fs');
const { Image } = require('canvas')

let buff = fs.readFileSync('./busticket.jpg');  
let base64data = buff.toString('base64');
base64data = 'data:image/jpeg;base64,' + base64data;
//console.log('Image converted to base 64 is:\n\n' + base64data);  

const myImage = new Image();
myImage.src = base64data;
console.log("image stored to myimage");

const vision = require('@google-cloud/vision');
const chrono = require('chrono-node');

const client = new vision.ImageAnnotatorClient({
    projectId: 'stepify-solutions',
    keyFilename: './Stepify-439387aa8ef3.json',
});


const getInfo = async (pathParam) => {
    const [result] = await client.textDetection(pathParam);
    const detections = result.textAnnotations;
    console.log("Tags collected");
    let jsonValues = [];
    detections.forEach(texts => {
        
        try {
            let chronoResult = chrono.parse(texts.description);
            jsonValues.push(chronoResult[0].text);
            //console.log(chronoResult[0].text);
            
            //console.log(texts.description);
            
        }
        catch(error) {
        
        };
        
    });
    
    let timeValues = {};

    detections.forEach(texts => {
        
        try {
            let chronotimeResult = chrono.parse(texts.description);
            timeValues[chronotimeResult[0].start.knownValues.hour] = chronotimeResult[0].start.knownValues.minute;
            
        }
        catch(error) {
        
        };
        
    });
    let hour = 200;
    let minute = 0;
    
    for(let timeKey in timeValues) {
        try {
            
            if(timeKey != undefined && timeValues[timeKey] != undefined && timeKey < hour) {

                hour = timeKey;
                minute = timeValues[timeKey];

            }

        }
        catch(error) {
            continue;
        };
    }

    let highest = 0;
    let finalDate;
    for(let i = 0; i < jsonValues.length; i++) {

        if(jsonValues[i].length > highest) {

            highest = jsonValues[i].length;
            finalDate = jsonValues[i];

        }

    }
    finalDate = finalDate.trim();
    console.log("Date:");
    console.log(finalDate);
    if(hour == 200) {

        hour = 0;

    }
    let time = hour + ":" + minute;
    console.log("Time:");
    console.log(time);
    
   }
   getInfo(myImage);

// 'use strict';

// let data = './busticket.jpg';  
// let buff = new Buffer.from(data);  
// let base64data = buff.toString('base64');

// console.log('"' + data + '" converted to Base64 is "' + base64data + '"');  


// const image2base64 = require('image-to-base64');
// let base64Data = "data:image/jpeg;base64,";
// image2base64("./busticket.jpg") // you can also to use url
//     .then(
//         (response) => {
//             base64Data = base64Data + response;
//             console.log(typeOf.response)
//             //console.log(response); //cGF0aC90by9maWxlLmpwZw==
//         }
//     )
//     .catch(
//         (error) => {
//             console.log(error); //Exepection error....
//         }
//     )
    
//     console.log(base64Data);