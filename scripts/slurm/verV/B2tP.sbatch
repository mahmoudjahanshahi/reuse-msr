#!/bin/bash

for i in {0..127..2}; do
    dep=$((i/2+942817));
    cat > B2tP.$i.slurm << EOT
#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J B2tP.$i
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=B2tP.$i.o%j
#SBATCH --error=B2tP.$i.e%j
#SBATCH --dependency=afterany:$dep

ver=V;
dir="/nfs/home/audris/work/c2fb/";

for i in {$i..$((i+1))}; do
    echo "File \$i" >&2;
    LC_ALL=C LANG=C join -t\; \\
        <(zcat \${dir}b2tPFull\${ver}\$i.s) \\
        <(zcat data/b2tPFull\${ver}\$i.copied) |
    gzip >data/B2tPFull\${ver}\$i.s;
    echo "Finished \$i";
done;

EOT

sbatch B2tP.$i.slurm;
done;
