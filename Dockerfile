FROM python:3.8.0-alpine3.10

MAINTAINER Loïc Pauletto <loic.pauletto@gmail.com>
MAINTAINER Quentin de Longraye <quentin@dldl.fr>

COPY ./requirements.txt requirements.txt

RUN apk update && apk add build-base libzmq musl-dev python3 python3-dev zeromq-dev
RUN pip3 install pyzmq
# reduce image size by cleaning up the build packages
RUN apk del build-base musl-dev python3-dev zeromq-dev

RUN apk add --no-cache --virtual --update build-base py3-pip py3-zmq make wget ca-certificates ttf-dejavu openjdk8-jre graphviz \
    && pip install --upgrade pip \
    && pip install --no-cache-dir  -r requirements.txt

RUN wget http://downloads.sourceforge.net/project/plantuml/plantuml.jar -P /opt/ \
    && echo -e '#!/bin/sh -e\njava -jar /opt/plantuml.jar "$@"' > /usr/local/bin/plantuml \
    && chmod +x /usr/local/bin/plantuml

COPY ./server.py /opt/sphinx-server/
COPY ./.sphinx-server.yml /opt/sphinx-server/

WORKDIR /web

EXPOSE 8000 35729

CMD ["python", "/opt/sphinx-server/server.py"]
