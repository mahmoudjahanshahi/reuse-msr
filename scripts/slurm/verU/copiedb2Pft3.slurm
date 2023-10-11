#!/bin/bash
#SBATCH -A ACF-UTK0011 
#SBATCH -J copiedb2Pft3
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=copiedb2Pft3.o%j
#SBATCH --error=copiedb2Pft3.e%j

ver=U;

# copiedb2Pft
for i in {3..127..4}; do 
    zcat data/copiedb2PtFull${ver}$i.s |
    perl -e '$pbp="";
        while(<STDIN>){
            chop();
            ($b,$p,$t)=split(/;/);
            $bp="$b;$p";
            if($bp ne $pbp){
                print "$b;$p;$t\n";
                $pbp=$bp;
            }
        }
    ' |
    gzip >data/copiedb2PftFull${ver}$i.s;
    echo "File $i is finished!";
done;
