# Prevent `mise` from auto-activating. That file is in a `conf.d` directory,
# which runs before `config.fish`, so this setting needs to happen either in a
# universal variable or a `conf.d` file with a filename that gets sorted early.
set -gx MISE_FISH_AUTO_ACTIVATE 0
