set -g mouse on
set -g status off

set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

unbind C-b
set -g prefix M-Space

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
bind-key -n "M-h" if-shell "$is_vim" "send-keys M-h"  "select-pane -L"
bind-key -n "M-j" if-shell "$is_vim" "send-keys M-j"  "select-pane -D"
bind-key -n "M-k" if-shell "$is_vim" "send-keys M-k"  "select-pane -U"
bind-key -n "M-l" if-shell "$is_vim" "send-keys M-l"  "select-pane -R"
bind-key -n "M-p" previous-window
bind-key -n "M-n" next-window

bind-key -n "M-c" new-window -c "#{pane_current_path}"
bind-key -n "M-d" detach-client
bind-key -n "M-q" display-panes
bind-key -n "M-Q" kill-session
bind-key -n "M-t" clock-mode
bind-key -n "M-w" choose-window
bind-key -n "M-x" confirm-before -p "kill-pane #P? (y/n)" kill-pane
bind-key -n "M-z" resize-pane -Z
bind-key -n "M-%" split-window -h -c "#{pane_current_path}"
bind-key -n "M-\"" split-window -v -c "#{pane_current_path}"
bind-key -n "M-:" command-prompt
