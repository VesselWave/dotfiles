if status is-interactive
    function sync_history --on-event fish_prompt
        history --merge
    end
end

set fish_greeting

fish_add_path /usr/local/go/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.nvm/versions/node/v22.18.0/bin
fish_add_path $HOME/apps/flutter/bin  
fish_add_path $HOME/.npm-global/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

alias ll="ls -lah"

set -gx EDITOR vim

source ~/.config/fish/conf.d/conda.fish

# export OPENROUTER_API_KEY=""
# export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
# export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
# export ANTHROPIC_API_KEY=""
# 
# # Override Opus (Complex reasoning tasks)
# export ANTHROPIC_DEFAULT_OPUS_MODEL="nvidia/nemotron-3-super-120b-a12b:free"
# 
# # Override Sonnet (General coding tasks)
# export ANTHROPIC_DEFAULT_SONNET_MODEL="openrouter/free"
# 
# # Override Haiku (Quick completions/edits)
# export ANTHROPIC_DEFAULT_HAIKU_MODEL="openrouter/free"
# 
# # Override Subagents (Spawned by Claude Code)
# export CLAUDE_CODE_SUBAGENT_MODEL="openrouter/free"
# 
# export OPENAI_BASE_URL="https://openrouter.ai/api/v1"
# export OPENAI_API_KEY="$OPENROUTER_API_KEY"
# export CONSTRAIN_BACKEND=openai
# export CONSTRAIN_MODEL=nvidia/nemotron-3-super-120b-a12b:free

command -v kiro && \
	string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)

# source $HOME/.local/bin/env.fish

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# 1. Configuration: Set your threshold here (in seconds)
set -g LONG_RUNNING_SEC 600

function notify_long_running --on-event fish_postexec
    # Convert seconds to milliseconds for CMD_DURATION comparison
    set -l threshold (math $LONG_RUNNING_SEC x 1000)
    set -l last_cmd $argv[1]

    # Extract the program name
    set -l cmd_name (string split -f 1 " " $last_cmd)

    # Exclusions
    set -l excluded_cmds vim vi nvim nano less man ssh top htop tmux screen git-log agy claude pi open
    if contains $cmd_name $excluded_cmds
        return
    end

    # Check Duration
    if test $CMD_DURATION -gt $threshold
        set -l time_secs (math -s1 $CMD_DURATION / 1000)

        if test $status -eq 0
            notify-send -u normal -i terminal \
                "Task Finished ($time_secs s)" \
                "$last_cmd"
        else
            notify-send -u critical -i error \
                "Task Failed ($time_secs s)" \
                "$last_cmd"
        end
    end
end

# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<
