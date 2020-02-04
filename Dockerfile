ARG PYTHON_VERSION=2.7

FROM python:${PYTHON_VERSION}-alpine as datamarket-alpine
RUN mkdir /install
RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    libffi-dev \
    libxml2-dev \
    unixodbc-dev \
    libxslt-dev \
    libmemcached-dev \
    musl-dev \
    postgresql-dev \
    g++ \
    make

WORKDIR /var/lib/datamarket/
COPY Pipfile* .
RUN pip install pipenv==2018.11.26 && \
    pipenv lock -r > requirements.txt && \
    pipenv lock -r -d > requirements-dev.txt
RUN pip install --no-cache-dir -r ./requirements.txt \
    && apk del --no-cache .build-deps \
    && apk --no-cache add libpq
COPY ./elam/ .
