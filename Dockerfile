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
	py3-attrs \
	py3-cffi \
	py3-chardet \
	py3-click \
	py3-cryptography \
	py3-dateutil \
	py3-defusedxml \
	py3-dnspython \
	py3-docutils \
	py3-future \
	py3-lxml \
	py3-lxml \
	py3-openssl \
	py3-prompt_toolkit \
	py3-pygments \
	py3-requests \
	py3-requests-toolbelt \
	py3-tz \
	py3-urllib3 \
	py3-wcwidth \
	py3-yaml \
"

ARG DEV_PKGS="\
	git \
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
