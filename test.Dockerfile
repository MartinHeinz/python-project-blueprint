FROM python:3.8-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends build-essential gcc

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

WORKDIR ./tests
CMD ["pytest"]