#!/bin/bash

for i in {0..127..4}; do
    dep=$((i/4+950802));
    cat > Ptb2Pt.$i.slurm << EOT
#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J Ptb2Pt.$i
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=Ptb2Pt.$i.o%j
#SBATCH --error=Ptb2Pt.$i.e%j
#SBATCH --dependency=afterany:$dep

ver=V;

for i in {$i..$((i+3))}; do
    echo "File \$i" >&2;
    LC_ALL=C LANG=C join -t\; -o 1.3 1.2 1.1 2.2 2.3 \\
        <(zcat data/B2ftPFull\${ver}\$i.s) \\
        <(zcat data/B2PftFull\${ver}\$i.s) |
    awk -F\; '{if (\$1 != \$4) print}' |
    gzip >data/Ptb2PtFull\${ver}\$i.s;
    echo "Finished \$i";
done;

EOT

sbatch Ptb2Pt.$i.slurm;
done;
