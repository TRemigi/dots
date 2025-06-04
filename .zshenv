if [[ -n $TMUX ]]; then
  export TERM=tmux-256color
else
  export TERM=xterm-ghostty
fi
