# tools
GOLANGCI_VER ?= v1.16.0
GOLANGCI_CMD ?= $(CURDIR)/third_party/golangci-lint

.PHONY: golangci
golangci: third_party/golangci-lint-$(GOLANGCI_VER)

third_party/golangci-lint-$(GOLANGCI_VER):
	rm -rf ./third_party/golangci-lint*
	curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | BINDIR=$(CURDIR)/third_party sh -s $(GOLANGCI_VER)
	mv ./third_party/golangci-lint ./third_party/golangci-lint-$(GOLANGCI_VER)
	ln -s $(CURDIR)/third_party/golangci-lint-$(GOLANGCI_VER) $(GOLANGCI_CMD)

