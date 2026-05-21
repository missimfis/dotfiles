# Stow Makefile for dotfiles management
# Usage: make install | uninstall | update | validate

.PHONY: install uninstall update validate

STOW_DIR := $(CURDIR)
STOW_PACKAGES := .config .local
TOP_LEVEL := .gitconfig .zshrc .zprofile .tmux.conf

install:
	@echo "Installing dotfiles with stow..."
	@cd "$(STOW_DIR)" && stow -v -t "$(HOME)" $(STOW_PACKAGES)
	@for f in $(TOP_LEVEL); do \
	  ln -sf "$(STOW_DIR)/$$f" "$(HOME)/$$f"; \
	done

uninstall:
	@echo "Uninstalling dotfiles with stow..."
	@cd "$(STOW_DIR)" && stow -v -t "$(HOME)" -D $(STOW_PACKAGES)
	@for f in $(TOP_LEVEL); do \
	  rm -f "$(HOME)/$$f"; \
	done

update: uninstall install

validate:
	@echo "Validating shell scripts..."
	@for f in .local/bin/*; do \
	  zsh -n "$$f" 2>/dev/null || echo "FAIL: $$f"; \
	done
	@zsh -n .zshrc 2>/dev/null || echo "FAIL: .zshrc"
	@zsh -n .config/zsh/exports.zsh 2>/dev/null || echo "FAIL: exports.zsh"
	@zsh -n .config/zsh/aliases.zsh 2>/dev/null || echo "FAIL: aliases.zsh"
	@echo "Done."
