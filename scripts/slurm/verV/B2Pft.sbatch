#!/bin/bash

for i in {0..127..2}; do
    cat > B2Pft.$i.slurm << EOT
#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J B2Pft.$i
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=B2Pft.$i.o%j
#SBATCH --error=B2Pft.$i.e%j

ver=V;

for i in {$i..$((i+1))}; do
    echo "File \$i" >&2;
    zcat data/B2tPFull\${ver}\$i.s |
    awk -F\; '{OFS=";";print \$1,\$3,\$2}' |
    LC_ALL=C LANG=C sort -T ./tmp/ -t\; |
    perl -e '\$pbp="";
        while(<STDIN>){
            chop();
            (\$b,\$p,\$t)=split(/;/);
            \$bp="\$b;\$p";
            if(\$bp ne \$pbp){
                print "\$b;\$p;\$t\n";
                \$pbp=\$bp;
            }
        }
    ' |
    gzip >data/B2PftFull\${ver}\$i.s;
    echo "Finished \$i";
done;

EOT

sbatch B2Pft.$i.slurm;
done;
