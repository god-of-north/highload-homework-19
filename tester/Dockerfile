FROM python:3.9.5-slim-buster

RUN mkdir -p /src
WORKDIR /src

RUN pip install --upgrade pip

COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./src /src
