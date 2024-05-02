#!/bin/bash

(
    echo -e "# WHATUP DOCUMENTATION\n\n" ;
    find . -maxdepth 1 -name \*.md -not -name README.md | sort -n | xargs ./gh-md-toc --no-backup | grep -E "^\s*\*"
) > README.md

