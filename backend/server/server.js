const express = require('express');
const cors = require('cors');
const forge = require('node-forge');
require('node-forge/lib/pkcs12');
const crypto = require('crypto');
require('dotenv').config();

const mockNotasFiscais = require('../data/notasData/mockData.js');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: '5mb' }));

console.log('Conteúdo de forge.pkcs12:', forge.pkcs12);

// Configuração da Criptografia (NÃO COLOCAR EM PRODUÇÃO)
const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY;
const IV_LENGTH = 16;

if (!ENCRYPTION_KEY || ENCRYPTION_KEY.length !== 64) {
    console.error('ERRO: Chave de criptografia (ENCRYPTION_KEY) não definida ou inválida (precisa ter 32 caracteres para AES-256).');
    process.exit(1);
}

/**
 * Criptografar um texto usando AES-256-CBC.
 * @param {string} text - O texto que sera criptografado.
 * @returns {string} - O texto criptografado em formato IV:encryptedText (Base64).
 */
function encrypt(text) {
    const iv = crypto.randomBytes(IV_LENGTH);
    const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return iv.toString('hex') + ':' + encrypted;
}

/**
 * Descriptografar um texto criptografado usando AES-256-CBC.
 * @param {string} text - O texto criptografado em formato IV:encryptedText (Base64).
 * @returns {string} - O texto original.
 */

function decrypt(text) {
    const textParts = text.split(':');
    const iv = Buffer.from(textParts.shift(), 'hex');
    const encryptedText = Buffer.from(textParts.join(':'), 'hex');
    const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
    let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
}

let encryptedCertificado = null;
let encryptedSenha = null;

app.get('/', (req, res) => {
    res.send('API de Consulta de Nota Fiscal está funcionando!');
});

/**
 * @route GET /nota-fiscal/:chaveAcesso
 * @description Retorna as informações de uma nota fiscal com base na chave de acesso.
 * @param {string} chaveAcesso - A chave de acesso da nota fiscal.
 * @returns {object} - Objeto JSON com os dados da nota fiscal ou mensagem de erro.
 */

app.get('/nota-fiscal/:chaveAcesso', (req, res) => {
    const chaveAcesso = req.params.chaveAcesso;
    console.log(`Requisição para a chave de acesso: ${chaveAcesso}`);

    if (encryptedCertificado && encryptedSenha) {
        try {
            const decryptedCert = decrypt(encryptedCertificado);
            const decryptedSenha = decrypt(encryptedSenha);
            console.log('Certificado e senha descriptografados para uso.');

        } catch (cryptoError) {
            console.error('Erro ao descriptografar certificado/senha:', cryptoError.message);
            return res.status(500).json({ message: 'Erro interno ao processar certificado seguro.' });
        }
    } else {
        console.log('Nenhum certificado seguro carregado. A consulta de NF pode falhar se a API externa exigir.');
    }

    const notaFiscal = mockNotasFiscais[chaveAcesso];

    if (notaFiscal) {
        res.status(200).json(notaFiscal);
    } else {
        res.status(404).json({ message: 'Nota fiscal não encontrada para a chave de acesso fornecida.' });
    }
});

/**
 * @route POST /upload-certificado
 * @description Recebe o conteúdo do certificado (Base64) e a senha, e os armazena criptografados.
 * @body {string} certificadoBase64 - O conteúdo do certificado PKCS#12 codificado em Base64.
 * @body {string} senha - A senha do certificado.
 * @returns {object} - Mensagem de sucesso ou erro.
 */
app.post('/upload-certificado', (req, res) => {
    const { certificadoBase64, senha } = req.body;

    if (!certificadoBase64 || !senha) {
        return res.status(400).json({ message: 'Certificado (Base64) e senha são obrigatórios.' });
    }

    try {
        const p12Der = forge.util.decode64(certificadoBase64);
        const p12Asn1 = forge.asn1.fromDer(p12Der);
        const p12 = forge.pkcs12.pkcs12FromAsn1(p12Asn1, senha);
        console.log('Certificado PKCS#12 decifrado com sucesso com a senha fornecida.');

        encryptedCertificado = encrypt(certificadoBase64);
        encryptedSenha = encrypt(senha);
        console.log('Certificado e senha recebidos, validados e ARMAZENADOS CRIPTOGRAFADOS.');
        res.status(200).json({ message: 'Certificado e senha recebidos e processados com sucesso.' });

    } catch (error) {
        console.error('Erro ao processar/criptografar certificado:', error.message);
        if (error.message.includes('MAC check failed') || error.message.includes('Key derivation failed') || error.message.includes('Unsupported PKCS#12 integrity algorithm') || error.message.includes('Invalid password or PKCS#12 file')) {
            return res.status(401).json({ message: 'Senha do certificado incorreta ou certificado inválido/corrompido.' });
        }
        res.status(500).json({ message: 'Erro interno ao processar o certificado. Verifique o formato ou a senha.', error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});