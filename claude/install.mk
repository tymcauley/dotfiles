.PHONY: claude
ALL_TARGETS += claude

CLAUDE_SETTINGS := $(HOME)/.claude/settings.json

claude: ## Install Claude Code statusline
	./install_file.sh claude/statusline-command.sh ~/.claude/statusline-command.sh
	@mkdir -p $(dir $(CLAUDE_SETTINGS))
	@[ -f $(CLAUDE_SETTINGS) ] || echo '{}' > $(CLAUDE_SETTINGS)
	@if ! grep -q statusLine $(CLAUDE_SETTINGS); then \
		tmp=$$(mktemp); \
		jq '. + {statusLine: {type: "command", command: "bash ~/.claude/statusline-command.sh"}}' $(CLAUDE_SETTINGS) > $$tmp \
			&& mv $$tmp $(CLAUDE_SETTINGS) \
			&& echo "added statusLine to $(CLAUDE_SETTINGS)"; \
	fi
