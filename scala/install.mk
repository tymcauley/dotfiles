.PHONY: scala
ALL_TARGETS  += scala
TOOL_TARGETS += scala

scala_TOOL := cs
scala_HINT := https://get-coursier.io/

scala: ## Update coursier
	@$(call check-tool,$(scala_TOOL),$(scala_HINT))
	cs update
