FROM alpine:latest
MAINTAINER techmovers@glia.com

RUN apk add --update \
        bash \
        curl \
        git \
        openssl \
        py-pip \
        python

WORKDIR /
RUN \
    apk add --no-cache --virtual .build-deps \
    gcc \
    python-dev \
    musl-dev \
    libffi-dev \
    openssl-dev 

RUN git clone https://github.com/lukas2511/dehydrated.git 
RUN (cd dehydrated && git checkout tags/v0.6.5) 
 # need to install boto3 explicitly. For some reason dns-lexicon[route53] doesn't seem to do it
RUN pip install pip --upgrade
RUN pip install dns-lexicon==3.3.0 dns-lexicon[route53]==3.3.0 boto3 
RUN apk del .build-deps

ADD https://raw.githubusercontent.com/AnalogJ/lexicon/d30759754272c8fa2e7426b0fe0980022318083e/examples/dehydrated.default.sh /dehydrated/
RUN chmod +x /dehydrated/dehydrated.default.sh

ADD dns-certbot.sh /dns-certbot.sh
RUN chmod +x /dns-certbot.sh

# slim things down now that we've done the build/install
RUN apk del $DEV_PKGS

CMD  [ "/dns-certbot.sh" ]
