#!/usr/bin/env bash

alias wasm_build='emcc -o a.out.html -s STANDALONE_WASM=1 -s WASM_BIGINT=1 -O3 -v'
