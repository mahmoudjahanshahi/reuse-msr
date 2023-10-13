#!/bin/bash

for i in {0..127..2}; do
    dep=$((i/2+947403));
    cat > B2ftP.$i.slurm << EOT
#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J B2ftP.$i
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=B2ftP.$i.o%j
#SBATCH --error=B2ftP.$i.e%j
#SBATCH --dependency=afterany:$dep

ver=V;

for i in {$i..$((i+1))}; do
    echo "File \$i" >&2;
    zcat data/B2tPFull\${ver}\$i.s |
    perl -e '\$pb="";
        while(<STDIN>){
            chop();
            (\$b,\$t,\$p)=split(/;/);
            if(\$b ne \$pb){
                print "\$b;\$t;\$p\n";
                \$pb=\$b;
            }
        }
    ' |
    gzip >data/B2ftPFull\${ver}\$i.s;
    echo "Finished \$i";
done;

EOT

sbatch B2ftP.$i.slurm;
done;
