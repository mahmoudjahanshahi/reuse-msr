#!/usr/bin/bash

ver=U;

# sanity check
dir="/nfs/home/audris/work/c2fb/";
for i in {10,50,109}; do
    echo "Test file $i";
    n1=$(zcat ${dir}b2tPFull${ver}$i.s | 
        cut -d\; -f1 | 
        uniq | 
        wc -l);
    echo "b2tP: $n1";
    nc=$(zcat data/b2tPFull${ver}$i.copied | 
        wc -l);
    nnc=$(zcat data/notCopiedb2PFull${ver}$i.s | 
        wc -l);
    n2=$((nc + nnc));
    echo "b2c-nc: $n2";
    echo ;
done;

# total blobs : 15,698,467,337
echo "total copied blobs:";
for i in {0..127}; do
    zcat data/b2tPFull${ver}$i.copied;
done |
wc -l; #1,084,211,945
echo "total not-copied blobs:";
for i in {0..127}; do
    zcat data/notCopiedb2PFull${ver}$i.s;
done |
wc -l; #14,614,255,392

# copiedb2tP
for i in {0..127}; do 
    LC_ALL=C LANG=C join -t\; \
        <(zcat ${dir}b2tPFull${ver}$i.s) \
        <(zcat data/b2tPFull${ver}$i.copied) |
    gzip >data/copiedb2tPFull${ver}$i.s;
    echo "File $i finished!"
done;

# copiedb2ftP
for i in {0..127..4}; do 
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

# copiedb2P
for i in {0..127}; do 
    zcat data/copiedb2tPFull${ver}$i.s |
    cut -d\; -f1,3 |
    LC_ALL=C LANG=C sort -T. -t\; -u |
    gzip >data/copiedb2PFull${ver}$i.s;
    n=$(zcat data/copiedb2PFull${ver}$i.s |
        wc -l);
    echo "File $i finished! count is: $n";
done;
# copy instances count: 24,998,544,215 - 1,084,211,945 = 23,914,332,270

# copiedb2Pt
for i in {0..127}; do 
    zcat data/copiedb2tPFull${ver}$i.s |
    awk -F\; '{print $1";"$3";"$2}' |
    LC_ALL=C LANG=C sort -T. -t\; |
    gzip >data/copiedb2PtFull${ver}$i.s;
    echo "File $i is finished!";
done;

# copiedb2Pft
for i in {0..127}; do 
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

# orgP
for i in {0..127}; do
    zcat data/copiedb2ftPFull${ver}$i.s |
    cut -d\; -f3 |
    LC_ALL=C LANG=C sort -T. -u;
done |
LC_ALL=C LANG=C sort -T. -u |
gzip >data/orgP.s; #31,706,416

# copiedb2desP
for i in {0..127}; do
    LC_ALL=C LANG=C join -v1 \
        <(zcat data/copiedb2PFull${ver}$i.s) \
        <(zcat data/copiedb2ftPFull${ver}$i.s | cut -d\; -f1,3) |
    gzip >data/copiedb2desPFull${ver}$i.s;
    echo "Finished File $i";
done;
echo;
echo "Total copy instances:";
for i in {0..127}; do
    zcat data/copiedb2desPFull${ver}$i.s ;
done | wc -l;
for i in {0..127}; do
    zcat data/copiedb2desPFull${ver}$i.s |
    cut -d\; -f2 |
    LC_ALL=C LANG=C sort -T. -u ;
done |
LC_ALL=C LANG=C sort -T. -u |
gzip >data/desP.s; #86,483,266
echo;
echo "Finished!";
