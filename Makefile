APP ?= ldap-ad-proxy
REPO ?= netaskd

.PHONY:  build tag start stop push exec log

all: build tag push

restart: stop start exec

build:
	@docker build -t ${APP} .

tag:
	@docker tag ${APP} ${REPO}/${APP}
	

push:
	@docker push ${REPO}/${APP}

start:
	@docker run -d \
	--name ${APP} \
	-p 389:389 \
	-p 636:636 \
	${APP} \
	/run.sh
stop:
	@docker rm -fv ${APP}

exec:
	@docker exec -it ${APP} bash

log:
	@docker logs -f ${APP}
