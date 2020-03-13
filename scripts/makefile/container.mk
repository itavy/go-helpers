ifeq ($(CONTAINER_REPOSITORY),)
CONTAINER_IMAGE := $(CONTAINER_REGISTRY)/$(CONTAINER_NAME):$(PROJ_VERSION)
else
CONTAINER_IMAGE := $(CONTAINER_REGISTRY)/$(CONTAINER_REPOSITORY)/$(CONTAINER_NAME):$(PROJ_VERSION)
endif

CONTAINER_BUILD_ID ?= id-$(GIT_COMMIT_SHORT)
CONTAINER_EXISTING = $(shell docker images -q $(CONTAINER_IMAGE))

.PHONY: container-build
container-build:
	docker build \
	-t $(CONTAINER_IMAGE) \
	--build-arg CONTAINER_GO_BUILD=$(CONTAINER_GO_BUILD) \
	--build-arg CONTAINER_RELEASE_SUPPORT=$(CONTAINER_RELEASE_SUPPORT) \
	--build-arg BUILD_VERSION=$(BUILD_VERSION) \
	--build-arg CONTAINER_USER=$(CONTAINER_USER) \
	--build-arg CONTAINER_MAINTAINER=$(CONTAINER_MAINTAINER) \
	--build-arg CONTAINER_GO_BUILD_ALPINE=$(CONTAINER_GO_BUILD_ALPINE) \
	--build-arg BUILD_ID=$(CONTAINER_BUILD_ID) \
	.

.PHONY: container-cleanup-intermediate
container-cleanup-intermediate:
	docker images -q --filter "label=stage=$(CONTAINER_BUILD_ID)" | xargs docker rmi

.PHONY: container-push
container-push:
	@docker login -u $(CONTAINER_REGISTRY_USER) -p $(CONTAINER_REGISTRY_API_TOKEN) $(CONTAINER_REGISTRY)
	docker push $(CONTAINER_IMAGE)

.PHONY: container-delete
container-delete:
ifeq ($(CONTAINER_EXISTING),)
	@echo "$(CONTAINER_IMAGE) does not exist. no need to remove"
else
	docker rmi --force $(CONTAINER_EXISTING)
endif

.PHONY: container-prereq
container-prereq:
	docker rmi $(CONTAINER_GO_BUILD) || true
	docker rmi $(CONTAINER_RELEASE_SUPPORT) || true
	docker rmi $(CONTAINER_GO_BUILD_ALPINE) || true
