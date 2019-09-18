FROM python:3-alpine

RUN apk update && \
  apk upgrade && \
  apk add curl bash coreutils wget --no-cache

RUN pip install --upgrade pip setuptools && \
  pip install --upgrade httpie

RUN \
  wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 --output-document="/usr/bin/jq" && \
  cd /usr/bin && \
  echo "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44 jq" | sha256sum -c - && \
  chmod +x jq

COPY assets/ /opt/resource/