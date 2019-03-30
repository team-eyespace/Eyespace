var chrono = require('chrono-node');

let labels = {
    1: "21 february 2019",
    2: "hello world",
    3: "28th january 2018 8PM",
    4: "ahdahjsdh",
    5: "21st november"

};

let jsonValues = [];

for(let key in labels) {
    try {
        let results = chrono.parse(labels[key]);
        jsonValues.push(results[0].text);

    }
    catch(error) {
        continue;
    };


}

let highest = 0;
let final;
for(let i = 0; i < jsonValues.length; i++) {

    if(jsonValues[i].length > highest) {

        highest = jsonValues[i].length;
        final = jsonValues[i];

    }

}
console.log(final);



// labels.forEach(label => {
//     try {
        
//         let results = chrono.parse(label);
//         console.log(results[0].text);

//     }
//     catch(error) {
   
//     };
    
// });


// let highest = 0;
// let final;
// for(let value in jsonValues) {
//     if(value.length > highest) {
//         highest = value.length
//         final = value;
//     }

// }



  
