// Script - Converter certificado para Base64
const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'certificado.pfx');
const fileContent = fs.readFileSync(filePath);
const base64Content = fileContent.toString('base64');

console.log(base64Content);