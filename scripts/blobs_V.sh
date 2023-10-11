#!/usr/bin/bash

ver=V;
dir="/nfs/home/audris/work/c2fb/";

# copiedb or B
for i in {0..127}; do
    zcat ${dir}b2tPFull${ver}$i.s |
    cut -d\; -f1,3 | 
    uniq |
    LC_ALL=C LANG=C sort -T ./tmp/ -t\; -u |
    cut -d\; -f1 | 
    uniq -d | 
    gzip > data/b2tPFull${ver}$i.copied;
done;

# B2tP
for i in {0..127}; do 
    LC_ALL=C LANG=C join -t\; \
        <(zcat ${dir}b2tPFull${ver}$i.s) \
        <(zcat data/b2tPFull${ver}$i.copied) |
    gzip >data/B2tPFull${ver}$i.s;
done;
