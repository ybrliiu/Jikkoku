#自分兵種計算#

sub HS_KEISAN{
  my ($seme,$lastbattle,$type,$str,$int,$lea,$cha,$arm,$book,$mes) = @_;

  my $att = 0;
  my $def = 0;

  if($type eq "1"){
    $att = int($str*0.3);
    $def = int($str*(-0.5));
    if(!$seme && $lastbattle){
      $att = int($str*0.2);
      $def = 0;
    }
  }elsif($type eq "2"){
    $att = int($str*0.2);
    $def = int($str*0.2);
  }elsif($type eq "3"){
    $att = int($str*0.3);
    $def = int($str*0.1);
  }elsif($type eq "4"){
    $att = int($str*1.05);
    $def = int($str*(-0.4));
    if(!$seme && $lastbattle){
      $att = int($str*0.6);
      $def = 0;
    }
  }elsif($type eq "5"){
    $att = int(($int+$book)*0.8)-$str;
    $def = 0;
  }elsif($type eq "6"){
    $att = int($str*0.7);
    $def = int($str*(-0.2));
  }elsif($type eq "7"){
    $att = int(($int+$book)*1.05);
    $def = int(($int+$book)*(-0.3));
  }elsif($type eq "8"){
    $att = int($str*0.8);
    $def = int($str*(-0.4));
    if(!$seme && $lastbattle){
      $att = int($str*0.4);
      $def = 0;
    }
  }elsif($type eq "9"){
    $att = int(($int+$book)*1.3);
    $def = int(($int+$book)*(-0.45));
  }elsif($type eq "10"){
    $att = int(($int+$book)*1.4);
    $def = int(($int+$book)*0.4);
  }elsif($type eq "11"){
    $att = int($lea*1.0);
    $def = int($lea*(-0.1));
  }elsif($type eq "12"){
    if($seme && $lastbattle){
      $att = int($str*2.3)-$str;
      $def = int($str*2.0)+10;
    }else{
      $att = -$str;
      $def = 10;
    }
  }elsif($type eq "13"){
    $att = int($str*0.8);
    $def = int($str*0.7);
  }elsif($type eq "14"){
    $att = int($str*0.6);
    $def = int($str*0.1);
  }elsif($type eq "15"){
    $att = int($lea*0.5);
    $def = int($lea*0.2);
  }elsif($type eq "16"){
    $att = int($lea*1.0);
    $def = int($lea*0.2);
  }elsif($type eq "17"){
    $att = int($str*1.3);
    $def = int($str*0.1);
  }elsif($type eq "18"){
    $att = int($lea*1.7);
    $def = int($lea*0.7);
  }elsif($type eq "19"){
    $att = int($lea*0.85)-int($str*0.5);
    $def = int($lea*(-0.4));
  }elsif($type eq "20"){
    $att = int($lea*1.1);
    $def = int($lea*(-0.5));
  }elsif($type eq "21"){
    $att = int($lea*2.0);
    $def = int($lea*(-0.5));
  }elsif($type eq "22"){
    $att = int($str*1.4);
    $def = int($str*0.6);
  }elsif($type eq "23"){
    $att = int($lea*1.3);
    $def = int($lea*0.5);
  }elsif($type eq "24"){
    $att = int($lea*0.6);
    $def = int($lea*0.1);
  }elsif($type eq "25"){
    $att = int($cha*0.9);
    $def = int($cha*0.2);
  }elsif($type eq "26"){
    $att = int($cha*1.55);
    $def = int($cha*0.7);
  }elsif($type eq "27"){
    $att = int($cha*2.2);
    $def = int($cha*0.8);
  }elsif($type eq "28"){
    if($seme && $lastbattle){
      $att = int(($int+$book)*3.3);
      $def = int(($int+$book)*2.5)+70;
    }else{
      $att = 0;
      $def = 70;
    }
  }elsif($type eq "29"){
    if($seme && $lastbattle){
      $att = int(($int+$book)*3.9);
      $def = int(($int+$book)*3.0)+100;
    }else{
      $att = 0;
      $def = 100;
    }
  }elsif($type eq "30"){
    $att = int($lea*1.1);
    $def = int($lea*0.1);
  }elsif($type eq "31"){
    $att = int($str*0.65);
    $def = int($str*0.35);
  }elsif($type eq "32"){
    $att = int(($int+$book)*0.95);
    $def = int(($int+$book)*0.05);
  }elsif($type eq "33"){
    $att = int(($int+$book)*1.3);
    $def = int(($int+$book)*0.1);
  }elsif($type eq "34"){
    $att = int(($int+$book)*1.2);
    $def = int(($int+$book)*0.2);
  }elsif($type eq "35"){
    $att = int(($int+$book)*1.2);
    $def = int(($int+$book)*0.55);
  }elsif($type eq "36"){
    $att = int(($int+$book)*1.35);
    $def = int(($int+$book)*0.4);
  }elsif($type eq "37"){
    $att = int(($int+$book)*1.45);
    $def = int(($int+$book)*(-0.3));
  }elsif($type eq "38"){
    $att = int($cha*1.0);
    $def = int($cha*0.1);
  }elsif($type eq "39"){
    $att = int($cha*1.55);
    $def = int($cha*(-0.5));
  }elsif($type eq "40"){
    $att = int($cha*0.7)-$str;
    $def = 10;
  }elsif($type eq "41"){
    $att = int($cha*1.7);
    $def = int($cha*0.55);
  }elsif($type eq "42"){
    $att = int($cha*1.8);
    $def = int($cha*(-0.4));
  }elsif($type eq "43"){
    $att = int($cha*2.4);
    $def = int($cha*0.6);
  }elsif($type eq "44"){
    $att = int($cha*2.5);
    $def = int($cha*(-0.45));
  }elsif($type eq "45"){
    $att = int(($int+$book)*0.85);
    $def = int(($int+$book)*0.15);
  }elsif($type eq "46"){
    $att = int(($arm+$book)*1.4)+$cha+$int+int($lea*0.75);
    $def = int($arm + $book);
  }elsif($type eq "47"){
    $att = int($str*0.7);
    $def = int($str*0.3);
  }elsif($type eq "48"){
    $att = int($str*0.8);
    $def = int($str*0.1);
  }elsif($type eq "49"){
    $att = int($str*1.6);
    $def = int($str*(-0.45));
  }elsif($type eq "50"){
    $att = int($str*1.3);
    $def = int($str*0.8);
  }elsif($type eq "51"){
    $att = int($cha*2.0);
    $def = int($cha*0.35);
  }elsif($type eq "52"){
    $att = int($cha*2.1);
    $def = int($cha*0.7);
  }elsif($type eq "53"){
    $att = int($cha*2.35);
    $def = int($cha*(-0.35));
  }elsif($type eq "54"){
    $att = int($cha*2.45);
    $def = int($cha*0.8);
  }elsif($type eq "55"){
    $att = int($cha*2.75);
    $def = int($cha*(-0.45));
  }elsif($type eq "56"){
    $att = int($cha*2.45);
    $def = int($cha*0.6);
  }elsif($type eq "57"){
    $att = int($lea*1.4);
    $def = int($lea*0.6);
  }elsif($type eq "58"){
    $att = int($str*0.95);
    $def = int($str*0.55);
  }elsif($type eq "59"){
    $att = int($str*1.2);
    $def = int($str*0.8);
  }elsif($type eq "60"){
    $att = int($str*1.2);
    $def = int($str*0.6);
  }elsif($type eq "61"){
    $att = int($str*1.5);
    $def = int($str*(-0.45));
  }elsif($type eq "62"){
    $att = int($lea*1.2);
    $def = int($lea*0.6);
  }elsif($type eq "63"){
    $att = int($lea*1.4);
    $def = int($lea*(-0.4));
  }elsif($type eq "64"){
    $att = int($lea*1.9);
    $def = int($lea*0.5);
  }elsif($type eq "65"){
    $att = int(($int+$book)*1.3);
    $def = int(($int+$book)*0.5);
  }elsif($type eq "66"){
    $att = int(($int+$book)*1.35);
    $def = int(($int+$book)*0.1);
  }elsif($type eq "67"){
    $att = int(($int+$book)*1.5);
    $def = int(($int+$book)*(-0.25));
  }elsif($type eq "68"){
    if($seme && $lastbattle){
      $att = int(($int+$book)*2.6);
      $def = int(($int+$book)*2.0)+10;
    }else{
      $att = 0;
      $def = 10;
    }
  }elsif($type eq "69"){
    $att = int($cha*1.1);
    $def = int($cha*(-0.3));
  }elsif($type eq "70"){
    $att = int($cha*1.5);
    $def = int($cha*0.2);
  }elsif($type eq "71"){
    $att = int($cha*1.45);
    $def = int($cha*0.2);
  }elsif($type eq "72"){
    $att = int($cha*1.55);
    $def = int($cha*0.1);
  }

  return($att,$def);
}

1;
