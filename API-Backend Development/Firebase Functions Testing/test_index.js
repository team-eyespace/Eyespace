var functions = require('firebase-functions');
var fetch = require('node-fetch');
var ocr = require('./ocr.js');

exports.ocr = functions.database().path('/messages/{room}/{id}').onWrite(function(event) {
  console.log('OCR triggered for /messages/'+event.params.room+'/'+event.params.id);

  if (!event.data || !event.data.exists()) return;
  if (event.data.ocr) return;
  if (event.data.val().text.indexOf("https://firebasestorage.googleapis.com/") !== 0) return; // only OCR images

  console.log(JSON.stringify(functions.env));

  return ocr.extract_text(event.data.val().text, functions.env.googlecloud.apikey).then(function(text) {
    return event.data.adminRef.update({ ocr: text });
  });
});