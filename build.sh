#!/usr/bin/bash
DG=$1
if [ $DG ]; then
		docker --debug build . -t $DG
	else
		docker --debug build . -t sleechengn/llama.cpp:latest
fi
