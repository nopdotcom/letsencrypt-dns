FROM alpine:3.8
# MAINTAINER techmovers@salemove.com
MAINTAINER nop@nop.com

ARG LEXICON_VERSION=3.2.5

#ARG DEHYDRATED_REPO=https://github.com/lukas2511/dehydrated.git
ARG DEHYDRATED_REPO=https://github.com/nopdotcom/dehydrated.git

#ARG DEFAULT_LEX_SCRIPT=https://raw.githubusercontent.com/AnalogJ/lexicon/5deaca503010e1cc0dfca10e31f3ffd17e7fc749/examples
ARG DEFAULT_LEX_SCRIPT=https://raw.githubusercontent.com/nopdotcom/lexicon/letsencrypt-dns/examples

ARG RUN_PKGS="\
	bash \
	curl \
        libffi \
        openssl \
	python3 \
	py3-lxml \
"

ARG DEV_PKGS="\
	git \
	gcc \
	libc-dev \
	libffi-dev \
	openssl-dev \
	python3-dev \
"

RUN apk add --update $RUN_PKGS $DEV_PKGS

RUN cd / \
 && git clone --branch v0.6.2 --depth 1 $DEHYDRATED_REPO \
 && pip3 install dns-lexicon[full]==${LEXICON_VERSION}

ADD $DEFAULT_LEX_SCRIPT/dehydrated.default.sh /dehydrated/
RUN chmod +x /dehydrated/dehydrated.default.sh

ADD dns-certbot.sh /dns-certbot.sh
RUN chmod +x /dns-certbot.sh

# slim things down now that we've done the build/install
RUN apk del $DEV_PKGS

CMD  [ "/dns-certbot.sh" ]
