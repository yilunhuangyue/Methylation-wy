#perl ../../script/methy_level_context_gene.pl FCHC7WGCCXY_L1_CITmkoHAAAAAAA-19_1_val_1_bismark_bt2_pe.deduplicated.CX_report.txt.gz /data7/huangyue/reference/ZK/ZK.gene.model_20180615.gff3 3 gene_methy.txt
($in1,$in2,$in3,$out)=@ARGV;
open(IN1,"gzip -dc $in1|");
open IN2,"$in2";
open OUT, ">$out";
while (chomp($line=<IN1>)) {
    @tmp=split(" ",$line);
	$chr=$tmp[0];
	$pos=$tmp[1];
	$id=$chr."_".$pos;
    $methy=$tmp[3];
    $unmethy=$tmp[4];
    $context=$tmp[5];
    $depth=$methy+$unmethy;
    if ($depth>$in3) {
            if ($context eq "CG") {
                $hash_CG_depth{$id}=$depth;
				$hash_CG_methy{$id}=$methy;
            }
            if ($context eq "CHG") {
                $hash_CHG_depth{$id}=$depth;
				$hash_CHG_methy{$id}=$methy;
            }
            if ($context eq "CHH") {
                $hash_CHH_depth{$id}=$depth;
				$hash_CHH_methy{$id}=$methy;
            }
    }
}
while(chomp($line=<IN2>)){
	@tmp=split(" ",$line);
	$chr=$tmp[0];
	$feature=$tmp[2];
	$start=$tmp[3];
	$end=$tmp[4];
	$strand=$tmp[6];
	
	if($feature eq "gene"){
		if($line=~/(.*)ID=(.*?);(.*)/){
			$gene=$2;
		}
		if ($strand eq "+") {
            $start1=$start-2001;
            $end1=$start-1;
		}
		if ($strand eq "-") {
            $start1=$end+1;
            $end1=$end+2001;
		}
		$gene_CG_methy=0;
		$gene_CG_depth=0;
		$gene_CHG_methy=0;
		$gene_CHG_depth=0;
		$gene_CHH_methy=0;
		$gene_CHH_depth=0;
		foreach($start1..$end1){
			$id=$chr."_".$_;
			if(exists($hash_CG_depth{$id})){
				$gene_CG_methy=$gene_CG_methy+$hash_CG_methy{$id};
				$gene_CG_depth=$gene_CG_depth+$hash_CG_depth{$id};
			}
			if(exists($hash_CHG_depth{$id})){
				$gene_CHG_methy=$gene_CHG_methy+$hash_CHG_methy{$id};
				$gene_CHG_depth=$gene_CHG_depth+$hash_CHG_depth{$id};
			}
			if(exists($hash_CHH_depth{$id})){
				$gene_CHH_methy=$gene_CHH_methy+$hash_CHH_methy{$id};
				$gene_CHH_depth=$gene_CHH_depth+$hash_CHH_depth{$id};
			}
		}
		if($gene_CG_depth>0){
			$CG_ratio=$gene_CG_methy/$gene_CG_depth;
		}
		else{
			$CG_ratio="NA";
		}
		if($gene_CHG_depth>0){
			$CHG_ratio=$gene_CHG_methy/$gene_CHG_depth;
		}
		else{
			$CHG_ratio="NA";
		}
		if($gene_CHH_depth>0){
			$CHH_ratio=$gene_CHH_methy/$gene_CHH_depth;
		}
		else{
			$CHH="NA";
		}
		print OUT "$gene\t$CG_ratio\t$CHG_ratio\t$CHH_ratio\n";
	}
}