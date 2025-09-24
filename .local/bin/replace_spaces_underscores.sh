#!/bin/bash
for FILE in *; do mv "$FILE" "$(echo $FILE | sed -e 's/ /_/g')"; done
