.PHONY: scala
ALL_TARGETS  += scala
TOOL_TARGETS += scala

scala_TOOL := cs
scala_HINT := https://get-coursier.io/

# TODO: Install zsh completions for coursier?
# TODO: Install scalafix/scalafmt?

scala: ## Update coursier, install scalafmt/scalafix configs
	@$(call check-tool,$(scala_TOOL),$(scala_HINT))
	cs update
	./install_file.sh scala/scalafix.conf ~/.scalafix.conf
	./install_file.sh scala/scalafmt.conf ~/.scalafmt.conf
