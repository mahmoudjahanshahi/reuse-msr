#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J orgP
#SBATCH --time=0-24:00:00
#SBATCH --nodes=2
#SBATCH --ntasks=96
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=orgP.o%j
#SBATCH --error=orgP.e%j

ver=U;

# orgP
for i in {0..127}; do
    zcat data/copiedb2ftPFull${ver}$i.s |
    cut -d\; -f3 |
    LC_ALL=C LANG=C sort -T. -u;
done |
LC_ALL=C LANG=C sort -T. -u |
gzip >data/orgP.s; #31,706,416
