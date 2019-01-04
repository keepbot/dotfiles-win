#!/usr/bin/env bash

# URL-encode strings
alias urlencode='python -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));"'

# One of janmoesen's ProTips. Preinstall: cpan install lwp-request
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done
