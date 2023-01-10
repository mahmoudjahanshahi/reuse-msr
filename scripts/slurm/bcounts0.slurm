#!/bin/bash
#SBATCH -A ACF-UTK0011
#SBATCH -J bcounts
#SBATCH --time=0-24:00:00
#SBATCH --nodes=6
#SBATCH --ntasks=288
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=bcounts.o%j
#SBATCH --error=bcounts.e%j

ver=U;

# sanity check
dir="/nfs/home/audris/work/c2fb/";
for i in {10,50,109}; do
    echo "Test file $i";
    n=$(zcat ${dir}b2tPFull${ver}$i.s | 
        cut -d\; -f1 | 
        uniq | 
        wc -l);
    echo "b2tP: $n";
    nc=$(zcat data/b2tPFull${ver}$i.copied | 
        wc -l);
    nnc=$(zcat data/notCopiedb2PFull${ver}$i.s | 
        wc -l);
    n=$((nc + nnc));
    echo "b2c-nc: $n";
    echo ;
done;

# total blobs
echo "total copied blobs:";
for i in {0..127}; do
    zcat data/b2tPFull${ver}$i.copied;
done |
wc -l;
echo "total not-copied blobs:";
for i in {0..127}; do
    zcat data/notCopiedb2PFull${ver}$i.s;
done |
wc -l;
