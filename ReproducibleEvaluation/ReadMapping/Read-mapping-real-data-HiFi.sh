#!/bin/bash
#set -e

FASTQpath='m64011_190830_220126.fastq'


for i in {7..19..2}
do

    sbatch --exclusive -w kratos0 -c 40 -J bwa_hg38 -o "HiFi/Genome-on-Diet-GRCh38-HiFi-stats-command-out_SV_k19w$i.txt" --wrap="/usr/bin/time -v --output "HiFi/Genome-on-Diet-GRCh38-HiFi-stats-time-memory_SV_k19w$i.txt" GDiet-LongReads/GDiet_avx -t 40 --MD -ax map-hifi -Z 10 -W 2 -i 0.2 -k 19 -w $i -N 1 -r 1000 --vt_dis=650 --vt_nb_loc=5 --vt_df1=0.0106 --vt_df2=0.2 -s 400 --vt_cov 0.04 --max_min_gap=4000 --vt_f=0.04 --sort=merge --frag=no -F200,1 --secondary=yes -a -o "HiFi/Genome-on-Diet-GRCh38-HiFi-stats_SV_k19w$i.sam" GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta ${FASTQpath}"

    sbatch --exclusive -w kratos0 -c 40 -J bwa_hg38 --wrap="samtools stats --threads 40 "HiFi/Genome-on-Diet-GRCh38-HiFi-stats_SV_k19w$i.sam" | grep ^SN | cut -f 2- > "HiFi/Genome-on-Diet-GRCh38-HiFi-stats_SV_k19w$i.txt""

    sbatch --exclusive -w kratos1 -c 40 -J bwa_hg38 -o "HiFi/minimap2-GRCh38-HiFi-stats-command-out_k19w$i.txt" --wrap="/usr/bin/time -v --output "HiFi/minimap2-GRCh38-HiFi-stats-time-memory_k19w$i.txt" ./minimap2 -t 40 --MD -ax map-hifi -N 1 -a -k 19 -w $i --secondary=yes -o "HiFi/minimap2-GRCh38-HiFi-stats_k19w$i.sam" GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta ${FASTQpath}"
  
    sbatch --exclusive -w kratos1 -c 40 -J bwa_hg38 --wrap="samtools stats --threads 40 "HiFi/minimap2-GRCh38-HiFi-stats_k19w$i.sam" | grep ^SN | cut -f 2- > "HiFi/minimap2-GRCh38-HiFi-stats_k19w$i.txt""

done

cd HiFi/

grep 'seconds' minimap2-GRCh38-HiFi*.txt
grep 'mapped:' minimap2-GRCh38-HiFi*.txt | awk 'ORS=NR%3?FS:RS'
grep 'non-primary alignments' minimap2-GRCh38-HiFi*.txt
grep 'Maximum resident set size' minimap2-GRCh38-HiFi*.txt
grep 'PROFILING' minimap2-GRCh38-HiFi*.txt


grep 'seconds' Genome-on-Diet-GRCh38-HiFi*.txt
grep 'mapped:' Genome-on-Diet-GRCh38-HiFi*.txt | awk 'ORS=NR%3?FS:RS'
grep 'non-primary alignments' Genome-on-Diet-GRCh38-HiFi*.txt
grep 'Maximum resident set size' Genome-on-Diet-GRCh38-HiFi*.txt
grep 'PROFILING' Genome-on-Diet-GRCh38-HiFi*.txt
