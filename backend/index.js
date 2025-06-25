require('dotenv').config();
const express = require('express');
const sefazClient = require('./src/sefazClient');

const app = express();
const PORT = 3000;

app.get('/consulta-nota', async (req, res) => {
    try {
        const resposta = await sefazClient();
        res.send(resposta);
    } catch (error) {
        console.error('Erro na consulta completa:', error);
        res.status(500).send(`Erro ao consultar nota na SEFAZ: ${error.message || 'Erro desconhecido'}`);
    }
});

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});
