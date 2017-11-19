FROM alpine
MAINTAINER Adam Crews <adamc@slalom.com>

# Install Dependencies
RUN apk update && apk upgrade \
  && apk add nodejs \
  && apk add nodejs-npm \
  && apk add python \
  && apk add curl \
  && curl -sS https://bootstrap.pypa.io/get-pip.py | python \
  && pip install awscli \
  && npm install -g npm \
  && npm install -g coffee-script \
  && npm install -g yo generator-hubot \
  && apk --purge -v del py-pip \
  && rm -rf /var/cache/apk/*

RUN adduser -h /hubot -s /bin/bash -S hubot
USER hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="Adam Crews <adamc@slalom.com>" --name "ash" --description="There is an explanation for this, you know." --defaults
COPY package.json package.json
RUN npm install
COPY external-scripts.json external-scripts.json

EXPOSE 9090

# Just Do It!
ENTRYPOINT [ "/bin/sh", "-c", "bin/hubot --adapter slack"]

