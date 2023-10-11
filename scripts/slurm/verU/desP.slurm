#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J desP
#SBATCH --time=0-24:00:00
#SBATCH --nodes=2
#SBATCH --ntasks=96
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=desP.o%j
#SBATCH --error=desP.e%j

ver=U;

# copiedb2desP
for i in {0..127}; do
    LC_ALL=C LANG=C join -v1 \
        <(zcat data/copiedb2PFull${ver}$i.s) \
        <(zcat data/copiedb2ftPFull${ver}$i.s | cut -d\; -f1,3) |
    gzip >data/copiedb2desPFull${ver}$i.s;
    echo "Finished File $i";
done;
echo;
echo "Total copy instances:";
for i in {0..127}; do
    zcat data/copiedb2desPFull${ver}$i.s ;
done | wc -l;
for i in {0..127}; do
    zcat data/copiedb2desPFull${ver}$i.s |
    cut -d\; -f2 |
    LC_ALL=C LANG=C sort -T. -u ;
done |
LC_ALL=C LANG=C sort -T. -u |
gzip >data/desP.s;
echo;
echo "Finished!";
