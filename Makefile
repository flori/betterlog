DOCKER_IMAGE_LATEST = betterlog
DOCKER_IMAGE = $(DOCKER_IMAGE_LATEST):$(REVISION_SHORT)
PROJECT_ID = betterplace-183212
REMOTE_LATEST_TAG := eu.gcr.io/${PROJECT_ID}/$(DOCKER_IMAGE_LATEST)
REMOTE_TAG = eu.gcr.io/$(PROJECT_ID)/$(DOCKER_IMAGE)
REVISION := $(shell git rev-parse HEAD)
REVISION_SHORT := $(shell echo $(REVISION) | head -c 7)
GOPATH := $(shell pwd)/gospace
GOBIN = $(GOPATH)/bin

.EXPORT_ALL_VARIABLES:

all: betterlog-server

betterlog-server: cmd/betterlog-server/main.go betterlog/*.go
	go build -o $@ $<

local: betterlog-server
	REDIS_URL=$(REDIS_URL) ./betterlog-server

setup: fake-package
	go mod download

fake-package:
	rm -rf $(GOPATH)/src/github.com/betterplace/betterlog
	mkdir -p $(GOPATH)/src/github.com/betterplace
	ln -s $(shell pwd) $(GOPATH)/src/github.com/betterplace/betterlog

test:
	@go test

coverage:
	@go test -coverprofile=coverage.out

coverage-display: coverage
	@go tool cover -html=coverage.out

clean:
	@rm -f betterlog-server coverage.out tags

clobber: clean
	@rm -rf $(GOPATH)/*

tags: clean
	@gotags -tag-relative=false -silent=true -R=true -f $@ . $(GOPATH)

build-info:
	@echo $(DOCKER_IMAGE)

build:
	docker build --pull -t $(DOCKER_IMAGE) .
	$(MAKE) build-info

build-force:
	docker build --pull -t $(DOCKER_IMAGE) --no-cache .
	$(MAKE) build-info

debug:
	docker run --rm -it $(DOCKER_IMAGE) bash

pull:
	docker pull $(REMOTE_TAG)
	docker tag $(REMOTE_TAG) $(DOCKER_IMAGE)

push: build
	docker tag $(DOCKER_IMAGE) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

push-latest: push
	docker tag ${DOCKER_IMAGE} ${REMOTE_LATEST_TAG}
	docker push ${REMOTE_LATEST_TAG}
