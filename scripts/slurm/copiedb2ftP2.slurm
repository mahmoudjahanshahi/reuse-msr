#!/bin/bash
#SBATCH -A ACF-UTK0011
#SBATCH -J copiedb2ftP2
#SBATCH --time=0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --partition=campus
#SBATCH --output=copiedb2ftP2.o%j
#SBATCH --error=copiedb2ftP2.e%j

ver=U;

# copiedb2ftP
for i in {2..127..4}; do 
    zcat data/copiedb2tPFull${ver}$i.s |
    perl -e '$pb="";
        while(<STDIN>){
            chop();
            ($b,$t,$p)=split(/;/);
            if($b ne $pb){
                print "$b;$t;$p\n";
                $pb=$b;
            }
        }
    ' |
    gzip >data/copiedb2ftPFull${ver}$i.s;
    echo "File $i is finished!";
done;
