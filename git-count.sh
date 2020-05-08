#!/usr/bin/env bash

# Run `sh git-count.sh` in git repo to get stats of all the authors combined
# Run `sh git-count.sh [author_name]` in git repo to get stats of the particular author

author_name=$1

git log --author=$author_name --numstat --no-merges --oneline |
gawk '{
    # commit tree is 7 characters long
    if (length($1) < 7) {
        files += 1;
        insertions += $1;
        deletions += $2
    } else {
        commits += 1;
    }
} END {
    printf "Files: %s \nCommits: %s \nInsertions: %s \nDeletions: %s\n", files, commits, insertions, deletions
}'

# run `git log --author="<author_name>" --shortstat --no-merges --oneline` in bash to see compact details of each commit tree
# run `git log --author="<author_name>" --numstat --no-merges --oneline` to see file details of each commit tree
