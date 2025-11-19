NAME = inception

all: up	

up:
	mkdir -p /home/$(USER)/data/wordpress
	mkdir -p /home/$(USER)/data/mariadb
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down -v
	rm -rf /home/$(USER)/data/wordpress
	rm -rf /home/$(USER)/data/mariadb

fclean: clean
	docker image prune -af
	docker volume prune -f

re: fclean all

.PHONY: all up down clean fclean re
