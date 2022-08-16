($in1,$in2,$in3,$in4,$in5,$in6,$out)=@ARGV;
open(IN1,"gzip -dc $in1|");
open(IN2,"gzip -dc $in2|");
open(IN3,"gzip -dc $in3|");
open(IN4,"gzip -dc $in4|");
open IN5, "$in5";
open OUT, ">$out";
while (chomp($line=<IN1>)) {
    @tmp=split(" ",$line);
    $chr=$tmp[0];
    $pos=$tmp[1];
    $methy=$tmp[3];
    $unmethy=$tmp[4];
    $context=$tmp[5];
    $depth=$unmethy+$methy;
    $id=$chr."_".$pos;
    if ($depth>=5 && $context eq "$in6") {
        $hash1{$id}++;
       # print "$id\n"; 
    }
}
while (chomp($line=<IN2>)) {
    @tmp=split(" ",$line);
    $chr=$tmp[0];
    $pos=$tmp[1];
    $methy=$tmp[3];
    $unmethy=$tmp[4];
    $context=$tmp[5];
    $depth=$unmethy+$methy;
    $id=$chr."_".$pos;
    if ($depth>=5 && $context eq "$in6") {
        $hash2{$id}++;
    }
}
while (chomp($line=<IN3>)) {
    @tmp=split(" ",$line);
    $chr=$tmp[0];
    $pos=$tmp[1];
    $methy=$tmp[3];
    $unmethy=$tmp[4];
    $context=$tmp[5];
    $depth=$unmethy+$methy;
    $id=$chr."_".$pos;
    if ($depth>=5 && $context eq "$in6") {
        $hash3{$id}++;
    }
}
while (chomp($line=<IN4>)) {
    @tmp=split(" ",$line);
    $chr=$tmp[0];
    $pos=$tmp[1];
    $methy=$tmp[3];
    $unmethy=$tmp[4];
    $context=$tmp[5];
    $depth=$unmethy+$methy;
    $id=$chr."_".$pos;
    if ($depth>=5 && $context eq "$in6") {
        $hash4{$id}++;
    }
}

while (chomp($line=<IN5>)) {
    @tmp=split(" ",$line);
    $chr=$tmp[0];
    $start=$tmp[1];
    $end=$tmp[2];
    $num1=0;
    $num2=0;
    $num3=0;
    $num4=0;
    
    foreach($start..$end){
        $id=$chr."_".$_;
        if (exists($hash1{$id})) {
            $num1++;
        }
        if (exists($hash2{$id})) {
            $num2++;
        }
        if (exists($hash3{$id})) {
            $num3++;
        }
        if (exists($hash4{$id})) {
            $num4++;
        }
       
    }
    if ($num1>=5 && $num2>=5 && $num3>=5 && $num4>=5 )
    {
        print OUT "$line\n";
    }

}
