const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'certificado.pfx');

try {
    const fileContent = fs.readFileSync(filePath);
    const base64Content = fileContent.toString('base64');
    console.log('Conteúdo do certificado em Base64 (copie isto):');
    console.log(base64Content);
} catch (error) {
    console.error('Erro ao ler o arquivo do certificado:', error.message);
    console.error('Certifique-se de que o arquivo está na mesma pasta e o nome está correto.');
}