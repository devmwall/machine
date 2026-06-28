# ~/.bashrc managed by dev/machine

export EDITOR="nvim"
export VISUAL="code --wait"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

path_add() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_add "$HOME/.local/bin"
path_add "$HOME/.local/scripts"
path_add "$GOBIN"

alias vim="nvim"
alias ll="ls -alF"
