.PHONY: help crds

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Update CRDs from testkube-operator repository
crds: ## Update CRDs from testkube-operator repository
	@echo "🔄 Updating CRDs..."
	@./scripts/update_crds.sh
