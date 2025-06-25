const fs = require('fs');
const https = require('https');
const soap = require('soap');
const path = require('path');

module.exports = async function consultarSefaz() {
    const pfx = fs.readFileSync(process.env.CERT_PATH);

    const agenteHttps = new https.Agent({
        pfx: pfx,
        passphrase: process.env.CERT_PASSWORD,
        rejectUnauthorized: false,
    });

    const wsdlPath = path.resolve(__dirname, '../wsdl/NFeDistribuicaoDFe.wsdl');

    return new Promise((resolve, reject) => {
        soap.createClient(wsdlPath, { httpsAgent: agenteHttps }, (err, client) => {
            if (err) return reject(err);

            const xmlRequisicao = `
                <nfeDistDFeInteresse xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.01">
                    <tpAmb>1</tpAmb>
                    <cUFAutor>35</cUFAutor>
                    <CPF>00000000191</CPF>
                    <distNSU>
                        <ultNSU>61678271845</ultNSU>
                    </distNSU>
                </nfeDistDFeInteresse>
            `;

            const args = {
                nfeCabecMsg: { versaoDados: '1.01', cUF: '35' },
                nfeDadosMsg: { _: xmlRequisicao },
            };

            client.nfeDistDFeInteresse(args, (err, result) => {
                if (err) return reject(err);
                resolve(result);
            });
        });
    });
};
