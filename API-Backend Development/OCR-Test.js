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
   getInfo("./busticket3.jpg");


// detections.forEach(text => {
        
    //     //console.log(text.description);
    //     try {
    //         let results = chrono.parse(text.description);
    //         jsonValues.push(results);
    
    //     }
    //     catch(error) {
        
    //     };
        
    // }
    // );


    // for(let text in detections) {
    //     try {
    //         //let results = chrono.parse(text.description);
    //         //jsonValues.push(results);
    //         console.log(text);
    
    //     }
    //     catch(error) {
    //         continue;
    //     };
    
    // }






// Performs text detection on the local file

// if(text.description == "Date" || text.description == "date") {
        //     //counter = 2;
        //     console.log(text.description);
        // }

        // if(counter != 0) {

        //     date = date + text.description;
        //     counter--;

        // }
        //console.log(text.description);
