# The binary to build (just the basename).
MODULE := blueprint

# Where to push the docker image.
REGISTRY ?= docker.pkg.github.com/martinheinz/python-project-blueprint

IMAGE := $(REGISTRY)/$(MODULE)

# This version-strategy uses git tags to set the version string
TAG := $(shell git describe --tags --always --dirty)

BLUE='\033[0;34m'
NC='\033[0m' # No Color

run:
	@python -m $(MODULE)

test:
	@pytest

lint:
	@echo "\n${BLUE}Running Pylint against source and test files...${NC}\n"
	@pylint --rcfile=setup.cfg **/*.py
	@echo "\n${BLUE}Running Flake8 against source and test files...${NC}\n"
	@flake8
	@echo "\n${BLUE}Running Bandit against source files...${NC}\n"
	@bandit -r --ini setup.cfg

# Example: make build-prod VERSION=1.0.0
build-prod:
	@echo "\n${BLUE}Building Production image with labels:\n"
	@echo "name: $(MODULE)"
	@echo "version: $(VERSION)${NC}\n"
	@sed                                     \
	    -e 's|{NAME}|$(MODULE)|g'            \
	    -e 's|{VERSION}|$(VERSION)|g'        \
	    prod.Dockerfile | docker build -t $(IMAGE):$(VERSION) -f- .


build-dev:
	@echo "\n${BLUE}Building Development image with labels:\n"
	@echo "name: $(MODULE)"
	@echo "version: $(TAG)${NC}\n"
	@sed                                 \
	    -e 's|{NAME}|$(MODULE)|g'        \
	    -e 's|{VERSION}|$(TAG)|g'        \
	    dev.Dockerfile | docker build -t $(IMAGE):$(TAG) -f- .

# Example: make shell CMD="-c 'date > datefile'"
shell: build-dev
	@echo "\n${BLUE}Launching a shell in the containerized build environment...${NC}\n"
		@docker run                                                 \
			-ti                                                     \
			--rm                                                    \
			--entrypoint /bin/bash                                  \
			-u $$(id -u):$$(id -g)                                  \
			$(IMAGE):$(TAG)										    \
			$(CMD)

# Example: make push VERSION=0.0.2
push: build-prod
	@echo "\n${BLUE}Pushing image to GitHub Docker Registry...${NC}\n"
	@docker push $(IMAGE):$(VERSION)

grpc-gen:
	@python -m grpc_tools.protoc \
			-I $(MODULE)/proto \
			--python_out=./$(MODULE)/generated \
			--grpc_python_out=./$(MODULE)/generated \
			./$(MODULE)/proto/*.proto
	@sed -i -E 's/^import.*_pb2/from . \0/' ./$(MODULE)/generated/*.py

cluster:
	@if [ $$(kind get clusters | wc -l) = 0 ]; then \
		kind create cluster --config ./k8s/cluster/kind-config.yaml --name kind; \
	fi
	@kubectl cluster-info --context kind-kind
	@kubectl get nodes
	@kubectl config set-context kind-kind --namespace $(MODULE)

deploy-local:
	@kubectl rollout restart deployment $(MODULE)

cluster-debug:
	@echo "\n${BLUE}Current Pods${NC}\n"
	@kubectl describe pods
	@echo "\n${BLUE}Recent Logs${NC}\n"
	@kubectl logs --since=1h -lapp=$(MODULE)

cluster-rsh:
	# if your container has bash available
	@kubectl exec -it $$(kubectl get pod -l app=${MODULE} -o jsonpath="{.items[0].metadata.name}") -- /bin/bash

manifest-update:
	@kubectl apply -f ./k8s/app.yaml

version:
	@echo $(TAG)

.PHONY: clean image-clean build-prod push test

clean:
	rm -rf .pytest_cache .coverage .pytest_cache coverage.xml

docker-clean:
	@docker system prune -f --filter "label=name=$(MODULE)"