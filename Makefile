.PHONY: help dev prod prod-build down logs ps stats test clean

help:
	@echo "Available commands:"
	@echo "  make dev         - Start development environment"
	@echo "  make prod        - Start production environment (with limits)"
	@echo "  make prod-build  - Rebuild & start production environment"
	@echo "  make down        - Tear down active containers and networks"
	@echo "  make logs        - Tail logs from all containers"
	@echo "  make ps          - List running stack containers"
	@echo "  make stats       - Show live container resource stats"
	@echo "  make test        - Run automated smoke test suite"
	@echo "  make clean       - Remove unused containers and dangling images"

dev:
	sudo docker compose up -d

prod:
	sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

prod-build:
	sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build

down:
	sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml down

logs:
	sudo docker compose logs -f

ps:
	sudo docker compose ps

stats:
	sudo docker stats --no-stream

test:
	@./scripts/smoke_test.sh

clean:
	sudo docker system prune -f
