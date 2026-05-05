# Scripts

This directory contains automation scripts used for development workflows in this project.

All scripts are intentionally:

- silent (no interactive output)
- deterministic
- safe to run from any working directory
- CI-compatible

---

## 📁 Structure

### `dev/`
Development environment scripts used locally by developers.

- system setup
- project bootstrap
- runtime execution
- external tooling
- update workflows

---

## 🧱 Script Layers

### 1. System Setup (`dev/setup-system.sh`)
Installs global dependencies required on the host machine.

- Node Version Manager (nvm)
- Go toolchain

👉 Run once per machine setup or after OS/toolchain changes.

---

### 2. External Tools (`dev/install-meilisearch.sh`)
Installs project-specific external services.

- Meilisearch v1.43.0

👉 Run once per project setup or when resetting external services.

---

### 3. Project Bootstrap (`dev/init-dev.sh`)
Creates a fully working local development environment.

Includes:

- web (SvelteKit)
- docs (Astro)
- backend (Go)
- dependency installation and build steps

👉 Run when:
- cloning the repository for the first time
- `package.json`, `package-lock.json`, or `go.mod/go.sum` changes
- build system or dependencies change
- the local environment is broken or inconsistent

---

### 4. Development Runtime (`dev/run-dev.sh`)

Starts the full local development stack:

- Meilisearch (search service)
- PocketBase (backend/database)
- Web frontend (SvelteKit dev server)

Includes:

- environment variables for local development
- automatic process cleanup on exit (SIGINT / SIGTERM)
- unified logging prefix for web service output

👉 Run when:
- starting a new development session
- first time after boot / system restart
- services are not running yet

👉 Do NOT run when:
- you change frontend code (e.g. `web/src/**`) — hot reload handles updates automatically
- you change backend application code that supports hot reload (if PocketBase/watch mode is active)
- you modify Go dependencies or Node dependencies (in these cases `init-dev.sh` is required instead)
- you change build configuration or dependency files such as:
  - `web/package.json` or `package-lock.json`
  - `db/go.mod` or `go.sum`
  - `docs/package.json`
  → in these cases run `dev/init-dev.sh` instead
- you only modify environment variables and they are already loaded in the current session (restart only required if values affect running processes like Meilisearch or PocketBase)

👉 Restart is required only when:
- a service crashes or becomes unresponsive
- ports are blocked or already in use
- environment variables affecting runtime services were changed (e.g. `MEILI_MASTER_KEY`)
- new services are added to the stack or existing ones are removed

---

## 🚀 Usage

Run from project root directory:

```bash
bash scripts/dev/setup-system.sh
bash scripts/dev/install-meilisearch.sh
bash scripts/dev/init-dev.sh
bash scripts/dev/run-dev.sh