#!/bin/bash
#SBATCH -A ACF-UTK0011
#SBATCH -J copiedb2tP2
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=copiedb2tP2.o%j
#SBATCH --error=copiedb2tP2.e%j

ver=U;
dir="/nfs/home/audris/work/c2fb/";


# copiedb2tP
for i in {2..127..4}; do 
    LC_ALL=C LANG=C join -t\; \
        <(zcat ${dir}b2tPFull${ver}$i.s) \
        <(zcat data/b2tPFull${ver}$i.copied) |
    gzip >data/copiedb2tPFull${ver}$i.s;
    echo "File $i finished!"
done;
