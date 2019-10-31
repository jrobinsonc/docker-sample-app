config_default=-f docker-compose.yml
config_dev=-f docker-compose.yml -f docker-compose.dev.yml

ifeq (dev, $(env))
	config=$(config_dev)
else
	config=$(config_default)
endif

web_url=$(shell docker-compose $(config) port web 80 | sed 's/0.0.0.0/http:\/\/localhost/g')
web_url_https=$(shell docker-compose $(config) port web 443 | sed 's/0.0.0.0/https:\/\/localhost/g')
mail_url=$(shell docker-compose $(config_dev) port mailhog 8025 | sed 's/0.0.0.0/http:\/\/localhost/g')
db_url=$(shell docker-compose $(config_dev) port adminer 8080 | sed 's/0.0.0.0/http:\/\/localhost/g')

start-new:
	docker-compose $(config) up --force-recreate -d web
	sleep 1
	docker-compose $(config) ps

start:
	docker-compose $(config) up -d --no-recreate
	sleep 1
	docker-compose $(config) ps

stop:
	docker-compose $(config_dev) stop

destroy:
	docker-compose $(config_dev) down -v

ps:
	docker-compose $(config_dev) ps

shell:
	docker-compose $(config) exec web bash

open-web:
	open $(web_url)

open-web-https:
	open $(web_url_https)

open-mail:
	open $(mail_url)

open-db:
	open $(db_url)