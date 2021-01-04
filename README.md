# KipsPM_microservices
KipsPM microservices repository

#Homework 12
1. Установлен docker, docker-machine.
2. Исследованы основные команды docker.
3. Поднят docker host в yandex cloud.
4. Переиспользованы и доработаны терраформ скрипты с прошлых занятий для поднятия инстанса stage под докер.
5. Переиспользованы и доработаны ансибл плейбуки для провижионинга поднятого терраформом инстанса.
6. Переиспользованы и доработаны пакер шаблоны и ансибл плейбуки для создания образа убунты с поднятым докером.

#Homework 13
1. Установлен hadolint в докер-контейнере.
2. В процессе использования заготовленных докерфайлов пользовался линтером, но менял только ADD на COPY.
Полноценно воспользовался линтером при выполнении задания со *.
3. Изучил разные варианты запуска контейнеров:
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post kipspm/post:1.0
docker run -d --network=reddit --network-alias=comment kipspm/comment:1.0
docker run -d --network=reddit -p 9292:9292 kipspm/ui:1.0

Запуск с другими переменными (задание со *):
docker run -d --network=reddit --network-alias=post_db_new --network-alias=comment_db_new mongo:latest
docker run -d --network=reddit --network-alias=post_new --env POST_DATABASE_HOST=post_db_new kipspm/post:1.0
docker run -d --network=reddit --network-alias=comment_new --env COMMENT_DATABASE_HOST=comment_db_new kipspm/comment:1.0
docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=post_new --env COMMENT_SERVICE_HOST=comment_new kipspm/ui:1.0

4. Изучил варианты написания Докерфайлов и способы их оптимизации.
5. Для задания со звездочкой написал новые докерфайлы на alpine образах. Команды билд:
docker build -f ./post-py/Dockerfile.2 -t kipspm/post:2.0 ./post-py
docker build -f ./comment/Dockerfile.2 -t kipspm/comment:2.0 ./comment
docker build -f ./ui/Dockerfile.3 -t kipspm/ui:3.0 ./ui

Команды запуска (с подключенным docker volume):
docker volume create reddit_db
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db --volume reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post kipspm/post:2.0
docker run -d --network=reddit --network-alias=comment kipspm/comment:2.0
docker run -d --network=reddit -p 9292:9292 kipspm/ui:3.0

#Homework 14
1. Попробованы разные варианты сетевых драйверов: none, host, bridge
2. Проект был запущен в двух разных сетях.
3. Установлен докер компоуз.
4. Описана инфраструктура в компоуз файле docker-compose.yml
5. Для параметризации компоуза был использован файл .env
6. Для задания базового имени проекта в энвы была прописана переменная COMPOSE_PROJECT_NAME
7. Добавлен файл docker-compose.override.yml с данными volume и командами для запуска пумы для руби приложений в дебаг режиме с двумя воркерами.

#Homework 15
1. Установлен GitLab на docker-host в YC c помощью docker-machine
2. Сконфигурирован .gitlab-ci.yml для обеспечения CI/CD
3. На этап build добавлена сборка образа reddit и загрузка его в DH. docker-dind работает как-то нестабильно, редко проходит этот шаг без ошибок, пытался решить добавлением слипов, но все равно он часто падает и снова работает без видимых на то причин.
4. На этап review добавлен деплой reddit на хост.
5. Добавлен скрипт для запуска раннера.
6. Интегрирован вебхук для оповещений в слак. https://devops-team-otus.slack.com/archives/C01ABLPUF99

#Homework 16
1. Установлен и запущен Prometheus на docker-host в YC с помощью docker-machine
2. Настроен мониторинг микросервисов с помощью Prometheus.
3. Настроен node-exporter для мониторинга хоста.
4. Настроен mongodb_exporter (percona) для мониторинга MongoDB.
5. Настроен blackbox_exporter для мониторинга микросервисов.
6. Написан Makefile который билдит микросервисы reddit c помощью скриптов, а mongodb_exporter и Prometheus c помощью docker build. Команда запуска make build_all
7. Также Makefile поднимает все сервисы командой make start_all и пушит в докерхаб командой make push_all
8. Ссылки на образы:
https://hub.docker.com/repository/docker/kipspm/prometheus
https://hub.docker.com/repository/docker/kipspm/mongodb_exporter
https://hub.docker.com/repository/docker/kipspm/ui
https://hub.docker.com/repository/docker/kipspm/post
https://hub.docker.com/repository/docker/kipspm/comment

#Homework 17
1. Установлен EFK стэк.
2. Проведены эксперименты по настройке и просмотру структурированных логов.
3. Настроен парсер fluent для разбора неструктурированных логов с помощью регулярок и grok шаблона.
4. Для задания со звездочкой дописан еще один grok шаблон.
5. Установлен zipkin для разбора трейсов.
6. Для второго задания со звездочкой добавил сломанный код приложений и это не замедлило открытие постов, а сломало их к чертям. Видимо из-за древней версии сломанного кода.
7. С помощью диффа двух исходных кодов нашел, что подразумевалось, что работа замедлится с помощью строчки time.sleep(3) в коде пост-сервиса.
8. Добавил эту строчку в заведомо рабочий код и увидел долгий трейс в зипкине. Починить можно понятно как.

#Homework 18
1. Развернут кластер Kubernetes с помощью Kubeadm
2. Процесс развертывания описан в ансибл плейбуках
3. Порядок запуска плейбуков initial.yml, kube-dependencies.yml, master.yml, workers.yml

#Homework 19
1. Запущен локальный minikube с драйвером VirtualBox
2. Написаны манифесты для деплоя компонентов приложения в кубер
3. Приложение проверено и работает в minikube
4. Развернут кластер кубернетис в Яндекс.Клауд вручную.
5. Развернут кластер кубернетис в Яндекс.Клауд с помощью terraform (для задания со звездочкой)
6. Развернут dashboard k8s с помощью https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
Travis?



