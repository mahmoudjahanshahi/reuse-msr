#!/usr/bin/bash

ver=V;
dir="/nfs/home/audris/work/c2fb/";

for i in {0..127}; do
    zcat ${dir}b2tPFull${ver}$i.s |
    cut -d\; -f1,3 | 
    uniq |
    LC_ALL=C LANG=C sort -T ./tmp/ -t\; -u |
    cut -d\; -f1 | 
    uniq -d | 
    gzip > data/b2tPFull${ver}$i.copied;
done;
