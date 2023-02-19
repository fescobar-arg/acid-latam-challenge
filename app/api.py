from fastapi import FastAPI
import pickle
import pandas
import json, typing
from starlette.responses import Response

app = FastAPI()

#Cargar pkl file en memoria
unpickle = open("modelnew.pkl","rb")
PickleOutput=pickle.load(unpickle)
unpickle.close()

@app.get("/load_model")
async def load_model():
    return Response(PickleOutput.to_json(orient="columns"), media_type="application/json")