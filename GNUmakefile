# go option
GO        ?= $(shell which go)
ifeq ($(GO),)
$(error Please put go binary in path or set GO env variable with full path to binary)
endif
TAGS      :=
TESTS     := .
TESTFLAGS :=
LDFLAGS   := -w -s
GOFLAGS   :=

PROJ_NAME := github.com/itavy/go-helpers


CONTAINER_GO_BUILD := golang:1.14.0-stretch
CONTAINER_GO_BUILD_ALPINE := golang:1.14.0-alpine3.11

GO_SRC_FILES := $(shell find . -name '*.go')
HAVE_TO_GENERATE := 0

.EXPORT_ALL_VARIABLES:

.PHONY: all
all: test

.PHONY: test
test: pre-commit
test: TESTFLAGS += -race -v
test: test-unit


.PHONY: test-style
test-style:
	@scripts/utils/validate-license.sh


.PHONY: test-unit
test-unit:
	@echo
	@echo "==> Running unit tests <=="
	$(GO) test $(GOFLAGS) -ldflags '$(LDFLAGS)' -run $(TESTS) $(PROJ_NAME)/... $(TESTFLAGS)

.PHONY: fmt
fmt:
	gofmt -w .

include scripts/makefile/container.mk
include scripts/makefile/go_deps.mk
include scripts/makefile/pre_commit_hook.mk
