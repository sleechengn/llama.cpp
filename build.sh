#!/usr/bin/bash
DG=$1
if [ $DG ]; then
		docker build . -t $DG
	else
		docker build . -t sleechengn/ollama:latest
fi
