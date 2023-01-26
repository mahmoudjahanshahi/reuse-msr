#!/bin/bash
#SBATCH -A ACF-UTK0011
#SBATCH -J copiedb2P1
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=copiedb2P1.o%j
#SBATCH --error=copiedb2P1.e%j

ver=U;

# copiedb2P
for i in {1..127..4}; do 
    zcat data/copiedb2tPFull${ver}$i.s |
    cut -d\; -f1,3 |
    LC_ALL=C LANG=C sort -T. -t\; -u |
    gzip >data/copiedb2PFull${ver}$i.s;
    n=$(zcat data/copiedb2PFull${ver}$i.s |
        wc -l);
    echo "File $i finished! count is: $n";
done;
