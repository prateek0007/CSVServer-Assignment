#!/bin/bash
start=$1
end=$2
> inputFile  # clear or create file
for i in $(seq $start $end)
do
  echo "$i, $((RANDOM % 1000))" >> inputFile
done

