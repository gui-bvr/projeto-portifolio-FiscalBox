import requests
from lxml import etree
from signxml import XMLSigner
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.serialization import pkcs12

CERT_PATH = "certs/certificado_teste.pfx"
CERT_PASSWORD = "1234"  # Senha fictícia
SEFAZ_NACIONAL_HOMOLOG = "https://hom.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx"

def load_cert_and_key(pfx_path, password):
    with open(pfx_path, 'rb') as f:
        pfx_data = f.read()
    private_key, certificate, additional_certificates = pkcs12.load_key_and_certificates(
        pfx_data, password.encode()
    )
    cert_pem = certificate.public_bytes(encoding=serialization.Encoding.PEM)
    key_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption()
    )
    return cert_pem, key_pem

def build_nfe_dist_xml(cpf, ult_nsu):
    envelope = f"""<?xml version="1.0" encoding="utf-8"?>
<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.01">
    <tpAmb>2</tpAmb>
    <cUFAutor>35</cUFAutor>
    <CNPJ></CNPJ>
    <CPF>{cpf}</CPF>
    <distNSU>
        <ultNSU>{ult_nsu}</ultNSU>
    </distNSU>
</distDFeInt>"""
    return envelope.encode('utf-8')

def assinar_xml(xml_data, cert_pem, key_pem):
    signer = XMLSigner(method='enveloped-signature', digest_algorithm='sha1')
    doc = etree.fromstring(xml_data)
    signed_doc = signer.sign(doc, key=key_pem, cert=cert_pem)
    return etree.tostring(signed_doc, xml_declaration=True, encoding='utf-8')

def consultar_nfe_sefaz(cpf, ult_nsu):
    cert_pem, key_pem = load_cert_and_key(CERT_PATH, CERT_PASSWORD)
    xml = build_nfe_dist_xml(cpf, ult_nsu)
    signed_xml = assinar_xml(xml, cert_pem, key_pem)

    headers = {
        "Content-Type": "application/soap+xml; charset=utf-8",
    }

    soap_envelope = f"""<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                 xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <nfeDistDFeInteresse xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe">
      <nfeDadosMsg>
        {signed_xml.decode('utf-8')}
      </nfeDadosMsg>
    </nfeDistDFeInteresse>
  </soap12:Body>
</soap12:Envelope>"""

    response = requests.post(
        SEFAZ_NACIONAL_HOMOLOG,
        data=soap_envelope.encode('utf-8'),
        headers=headers,
        cert=(CERT_PATH, CERT_PATH),
        verify=True
    )

    return response.text

# Teste básico
if __name__ == "__main__":
    cpf_exemplo = "12345678909"
    ult_nsu = "0"
    print(consultar_nfe_sefaz(cpf_exemplo, ult_nsu))