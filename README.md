# Task Scheduler API

A task scheduling system built with Node, Express, TypeScript, Docker and PostgreSQL. Schedule tasks to run at specific times with priority handling and retry logic.

> "Einstein probably never said this, but time management is relative."

## Quick Start for Contributors

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & Docker Compose v2
- Git
- Make (optional but recommended)

### Setup

1. Clone the repository

```bash
git clone https://github.com/0xironclad/Task-Scheduler-API.git
cd Task-Scheduler-API
```

2. Set up environment variables

```bash
cp .env.example .env
```

3. Start the development environment

```bash
make dev-up
```

4. API is now running at `http://localhost:3000`

Test it:

```bash
curl http://localhost:3000
# {"message":"Hello World"}
```

## Available Commands

### Development

```bash
make dev-up      # Start dev environment with hot reload
make dev-down    # Stop dev environment
make dev-logs    # View development logs
```

### Production

```bash
make up          # Build & run production containers
make down        # Stop production containers
make logs        # View production logs
```

## Project Structure

```
src/
├── config/          # Database configuration
├── controller/      # Request handlers
├── data/            # SQL schemas and test utilities
├── middlewares/     # Validation and error handling
├── models/          # Database queries
└── routes/          # API routes
```

## Tech Stack

- **Runtime:** Node.js with TypeScript
- **Framework:** Express.js
- **Database:** PostgreSQL 16
- **Validation:** Joi
- **Dev Tools:** tsx for hot reload

## Contributing

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test locally with `make dev-up`
5. Submit a pull request

## API Endpoints

- `GET /` - Health check
- `GET /api/v1/tasks` - Get all tasks (with filters)
- `POST /api/v1/tasks` - Create a new task

More endpoints coming soon!
