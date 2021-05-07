#!/usr/bin/env bash

# Do not prompt using Windows native with WSL
export DONT_PROMPT_WSL_INSTALL='true'

if command -v code-insiders >/dev/null
then
    alias icode="code-insiders"
else
    alias icode="code"
fi
