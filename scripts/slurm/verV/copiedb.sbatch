#!/bin/bash

for i in {0..127..2}; do
    cat > copiedb.$i.slurm << EOT
#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J copiedb.$i
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=copiedb.$i.o%j
#SBATCH --error=copiedb.$i.e%j

ver=V;
dir="/nfs/home/audris/work/c2fb/";

for i in {$i..$((i+1))}; do
    zcat \${dir}b2tPFull\${ver}\$i.s |
    cut -d\; -f1,3 | 
    uniq |
    LC_ALL=C LANG=C sort -T ./tmp/ -t\; -u |
    cut -d\; -f1 | 
    uniq -d | 
    gzip > data/b2tPFull\${ver}\$i.copied;
done;

EOT

sbatch copiedb.$i.slurm;
done;
