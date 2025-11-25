DEV= docker compose -f docker-compose.dev.yaml
PROD= docker compose -f docker-compose.yaml

## For Development
dev-up:
	$(DEV) up --build

dev-down:
	$(DEV) down

dev-logs:
	$(DEV) logs -f api

## For Production
up:
	$(PROD) up --build -d

down:
	$(PROD) down

logs:
	$(PROD) logs -f api
