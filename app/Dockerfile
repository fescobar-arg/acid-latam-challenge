FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

WORKDIR /app

COPY requirements.txt .

RUN pip install -U -r requirements.txt

COPY . .

RUN python model.py

EXPOSE 80

ENV PORT 80

CMD [ "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "80"]