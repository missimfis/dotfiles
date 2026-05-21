# Stow Makefile for dotfiles management
# Usage: make install | uninstall | update

.PHONY: install uninstall update clean

STOW_DIR := $(HOME)/dotfiles
STOW_PACKAGES := .config .local
TOP_LEVEL := .gitconfig .zshrc .zprofile .tmux.conf

install:
	@echo "Installing dotfiles with stow..."
	@cd $(STOW_DIR) && stow -v -t $(HOME) $(STOW_PACKAGES)
	@for f in $(TOP_LEVEL); do \
	  ln -sf $(STOW_DIR)/$$f $(HOME)/$$f; \
	done

uninstall:
	@echo "Uninstalling dotfiles with stow..."
	@cd $(STOW_DIR) && stow -v -t $(HOME) -D $(STOW_PACKAGES)
	@for f in $(TOP_LEVEL); do \
	  rm -f $(HOME)/$$f; \
	done

update: uninstall install

clean:
	@echo "Cleaning up..."
	@rm -f $(HOME)/.stow.log
