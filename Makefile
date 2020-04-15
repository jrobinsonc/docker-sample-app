https_url=$(shell docker-compose port web 443 | sed 's/0.0.0.0/https:\/\/localhost/g')
http_url=$(shell docker-compose port web 80 | sed 's/0.0.0.0/http:\/\/localhost/g')
mail_url=$(shell docker-compose port mailhog 8025 | sed 's/0.0.0.0/http:\/\/localhost/g')
db_url=$(shell docker-compose port adminer 8080 | sed 's/0.0.0.0/http:\/\/localhost/g')

start-new:
	docker-compose up --force-recreate --build -d

start:
	docker-compose up -d --no-recreate

stop:
	docker-compose stop

destroy:
	docker-compose down -v
	@echo "\n⚠️ Remember to remove the image built for the web container \nif you don't need it anymore; the name of the image should be \nprefixed with what is defined in COMPOSE_PROJECT_NAME.\n"

shell:
	docker-compose exec web bash

open-web:
	open $(http_url)
	# open $(https_url)

open-mail:
	open $(mail_url)

open-db:
	open $(db_url)