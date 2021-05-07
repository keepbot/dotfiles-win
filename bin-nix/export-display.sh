#!/bin/bash

ADDR=$(echo $SSH_CLIENT | awk '{print $1}')

if [ -z "$ADDR" ]
then
    export DISPLAY=localhost:0.0
else
    export DISPLAY=$ADDR:0.0
fi
