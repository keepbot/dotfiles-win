#!/usr/bin/env bash

# URL-encode strings
alias urlencode='python -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));"'

# One of janmoesen's ProTips. Preinstall: cpan install lwp-request
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

# Weather
alias wet="curl http://wttr.in/"
alias wet2="curl http://v2.wttr.in/"
alias wetM="curl http://wttr.in/Moscow"
alias wetM2="curl http://v2.wttr.in/Moscow"
