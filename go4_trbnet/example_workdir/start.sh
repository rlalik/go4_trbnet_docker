#!/bin/bash

echo "container started"

echo "create main tmux session"

echo "run /conf/conf.sh"
. /conf/conf.sh # keep environment variables set in conf.sh

cd /workdir

# create new tmux session named "main"
tmux new -d -s main

# display some info
tmux new-window -t main -n "info" "cat /conf/conf_log.txt; cat info.txt; /bin/bash"

tmux link-window -s cts_gui:cts_gui -t main  # attach window opened by conf.sh
tmux link-window -s vnc:vnc -t main          # attach window opened by conf.sh



### start a dabc service ###
tmux new-window -t main -n "dabc" "dabc_exe TdcEventBuilder.xml;/bin/bash"

### start a go4 session  ###
#tmux new-window -t main -n "go4" "rm *.root;  go4 my_hotstart.hotstart;/bin/bash"

### start a go4analysis session with web server ###
GO4_WEB_PORT=8080
tmux new-window -t main -n "go4_ana" "rm *.root; go4analysis -stream localhost:6790 -http localhost:$GO4_WEB_PORT;/bin/bash"


### some new tabs to use for ... whatever ###
tmux new-window -t main -n "new" "/bin/bash"
tmux new-window -t main -n "new" "/bin/bash"
tmux new-window -t main -n "new" "/bin/bash"
tmux new-window -t main -n "new" "/bin/bash"
tmux new-window -t main -n "new" "/bin/bash"

# open CTS GUI and GO4 Web interface in firefox (running in VNC)
tmux new-window -t main -n "x11_apps" "lxpanel& sleep 5 && firefox -new-tab -url localhost:$CTS_GUI_PORT -new-tab -url localhost:$GO4_WEB_PORT& /bin/bash"



### select info tab ###
tmux select-window -t main:info

### finally attach tmux to the above configured session ###
tmux a -t main



### if tmux session closed ###
echo "drop user to shell"
/bin/bash

echo "terminate container"
