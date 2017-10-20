#!/bin/bash

cd all
cp `ls -A` ~/
if [ -d linux ]; then
	cd ../linux
	cp `ls -A` ~/
	cd ..
fi
