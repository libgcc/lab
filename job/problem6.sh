#!/bin/bash
# ECE 2524 Homework 4  Problem  1  Jane Doe 

out=problem6
rm -f $out
for file in $(ls *)
do
    [[ -f $file ]] || continue;
    echo "$file:" >> $out
    head -2 $file >> $out
    echo >> $out
done
