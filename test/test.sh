#!/usr/bin/env bash

$(vessel bin)/moc $(vessel sources) -wasi-system-api -o Test.wasm Test.mo

wasmtime Test.wasm
