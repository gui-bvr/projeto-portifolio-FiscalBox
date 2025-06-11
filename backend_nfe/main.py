from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = ["*"]  # Permitir qualquer origem (ajuste para produção)

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class NFeRequest(BaseModel):
    cpf_cnpj: str
    ult_nsu: str

@app.post("/consultar-nfe")
def consultar_nfe(request: NFeRequest):
    try:
        # Placeholder para integração real com o WebService da SEFAZ
        return {
            "cpf_cnpj": request.cpf_cnpj,
            "ult_nsu": request.ult_nsu,
            "mensagem": "Consulta simulada com sucesso."
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
