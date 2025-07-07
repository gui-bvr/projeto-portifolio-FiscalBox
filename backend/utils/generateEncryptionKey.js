const crypto = require('crypto');

const encryptionKey = crypto.randomBytes(32).toString('hex');
console.log('Chave de criptografia (32 bytes em formato hexadecimal):\n\n');
console.log(encryptionKey);
console.log('\n\nCopie esta chave e coloque no arquivo .env como ENCRYPTION_KEY.');