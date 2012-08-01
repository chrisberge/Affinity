#!/bin/bash

oldName=$1
newName=$2
mv $1-Info.plist $2-Info.plist
mv $1_Prefix.pch $2_Prefix.pch
mv $1.xcodeproj $2.xcodeproj
mv Classes/$1.sqlite Classes/$2.sqlite
mv Classes/$1.xcdatamodel Classes/$2.xcdatamodel
mv Classes/$1AppDelegate.h Classes/$2AppDelegate.h
mv Classes/$1AppDelegate.m Classes/$2AppDelegate.m

for fic in `grep -ilr $1 *`
do
	sed 's/'"$1"'/'"$2"'/g' $fic > $fic.new
	mv $fic.new $fic
done
