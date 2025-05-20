# Makefile for the scubatools SvelteKit project

# Variables
BUN = bun

# Phony targets (targets that don't represent actual files)
.PHONY: install dev build build-custom-element check format clean all deploy

# Default target: runs when `make` is called without arguments
default: dev

install:
	@echo "Installing dependencies..."
	$(BUN) install

dev:
	@echo "Starting development server..."
	$(BUN) run dev

build:
	@echo "Building SvelteKit application..."
	$(BUN) run build


check:
	@echo "Running checks (linting and type checking)..."
	$(BUN) run check
	$(BUN) run lint

format:
	@echo "Formatting code..."
	$(BUN) run format

clean:
	@echo "Cleaning build artifacts..."
	rm -rf dist
	rm -rf .svelte-kit
	rm -rf build
	@echo "Clean complete."

all: build
	@echo "All build tasks complete."

deploy: build
	@echo "Deploying to Netlify..."
	netlify deploy --prod

help:
	@echo "Available targets:"
	@echo "  install               - Install project dependencies"
	@echo "  dev                   - Start the development server (default)"
	@echo "  build                 - Build the SvelteKit application"
	@echo "  build-custom-element  - Build the NextUp.svelte component as a custom element"
	@echo "  check                 - Run linting and type checks"
	@echo "  format                - Format the codebase"
	@echo "  clean                 - Remove build artifacts (dist, .svelte-kit)"
	@echo "  all                   - Build both the SvelteKit app and the custom element"
	@echo "  deploy                - Build and deploy to Netlify"
	@echo "  help                  - Show this help message" 