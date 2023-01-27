#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J copiedb2Pt0
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=copiedb2Pt0.o%j
#SBATCH --error=copiedb2Pt0.e%j

ver=U;

# copiedb2Pt
for i in {0..127..4}; do 
    zcat data/copiedb2tPFull${ver}$i.s |
    awk -F\; '{print $1";"$3";"$2}' |
    LC_ALL=C LANG=C sort -T. -t\; |
    gzip >data/copiedb2PtFull${ver}$i.s;
    echo "File $i is finished!";
done;
