const fs = require('fs');

let buff = fs.readFileSync('./test.jpg');  
let base64data = buff.toString('base64');

dict = {

    query: base64data

}


var dictstring = JSON.stringify(dict);

fs.writeFile("test.json", dictstring);

console.log()