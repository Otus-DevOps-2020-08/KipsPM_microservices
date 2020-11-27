SHELL = /bin/sh
USER_NAME=kipspm

include ./docker/.env
export

build_comment:
	cd ./src/comment && bash ./docker_build.sh

build_post:
	cd ./src/post-py && bash ./docker_build.sh

build_ui:
	cd ./src/ui && bash ./docker_build.sh

build_prometheus:
	cd ./monitoring/prometheus && docker build -f Dockerfile -t kipspm/prometheus .

build_mongodbexporter:
	cd ./monitoring/mongodb_exporter && docker build -f Dockerfile -t kipspm/mongodb_exporter .

build_all: build_post build_comment build_ui build_mongodbexporter build_prometheus

start_all:
	echo '### starting environment ###'
	docker-compose --project-directory docker -f docker/docker-compose.yml up -d

stop_all:
	echo '### stopping environment ###'
	docker-compose --project-directory docker -f docker/docker-compose.yml down

push_comment:
	docker push $(USER_NAME)/comment:latest

push_post:
	docker push ${USER_NAME}/post:latest

push_ui:
	docker push ${USER_NAME}/ui:latest

push_prometheus:
	docker push ${USER_NAME}/prometheus:latest

push_mongodbexporter:
	docker push ${USER_NAME}/mongodb_exporter:latest

push_all: push_comment push_post push_ui push_mongodbexporter push_prometheus
