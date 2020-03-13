PRECOMMIT_HOOK_FILE ?= .git/hooks/pre-commit

.PHONY: install-precommit-hook
install-precommit-hook:
	@echo "#!/usr/bin/env bash" > $(PRECOMMIT_HOOK_FILE)
	@echo "make pre-commit" >> $(PRECOMMIT_HOOK_FILE)
#	@cp scripts/utils/pre_commit_hook.sh $(PRECOMMIT_HOOK_FILE)
	@chmod +x $(PRECOMMIT_HOOK_FILE)
	@echo "pre-commit installed"

.PHONY: pre-commit
pre-commit:
	@scripts/utils/pre_commit_hook.sh
