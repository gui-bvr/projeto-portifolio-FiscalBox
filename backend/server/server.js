const express = require('express');
const cors = require('cors');
// Notas físcais de teste
const mockNotasFiscais = require('./data/mockData.js');

// Cria uma instância do aplicativo Express
const app = express();
// Define a porta do servidor
const PORT = process.env.PORT || 3000;

// --- Middleware ---
// (Conexões com o Flutter)

// Habilita o CORS para todas as requisições
app.use(cors());
// Habilita o Express para parsear JSON no corpo das requisições
app.use(express.json());

// --- Rotas da API ---

// Rota de teste simples para verificar se o servidor está funcionando
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
    // Captura a chave de acesso da URL
    const chaveAcesso = req.params.chaveAcesso;
    console.log(`Requisição para a chave de acesso: ${chaveAcesso}`);

    const notaFiscal = mockNotasFiscais[chaveAcesso];

    if (notaFiscal) {
        // Se a nota fiscal for encontrada, retorna os dados com status 200 (OK)
        res.status(200).json(notaFiscal);
    } else {
        // Se a nota fiscal não for encontrada, retorna um erro 404 (Não Encontrado)
        res.status(404).json({ message: 'Nota fiscal não encontrada para a chave de acesso fornecida.' });
    }
});

// --- Iniciar o Servidor ---
app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});