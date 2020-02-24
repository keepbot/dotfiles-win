for /F %remote in ('git branch -r') do ( git branch --track %remote) && git fetch --all && git pull --all
