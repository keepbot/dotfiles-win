#!/usr/bin/env bash

alias wasm_build='emcc -o a.out.html -s STANDALONE_WASM=1 -s WASM_BIGINT=1 -O3 -v'

wasm_debug()
{
    case $1 in
    On|on)
        export EMCC_DEBUG=1
        ;;
    Off|off)
        export EMCC_DEBUG=0
        ;;
    *)
        echo "ERROR: Wrong operation...."
        echo "  Usage: wasm_debug <On|Off>"
        echo
        ;;
    esac
}
