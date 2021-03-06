use Math::Round;
opendir(DIR,"../books/book1/old_format") || die "can't: $!";
for(readdir DIR){
	next if /(^\.|^x)/;
	@a = undef;
	open(F,"../books/book1/old_format/$_")|| die "can't: $!";
	undef $/;
	$data=<F>;
	close F;
	
	@data=split(/\n/,$data);
	$file=$_;
	$file=~s/\..{2,3}/.png/;
	$prefix = qq(<entry>\n  <file>$file</file>\n  <height="5950"/>\n  <width="4020"/>\n  <view_width="1015"/>\n  <text_align="left"/>\n  <data>\n);

	foreach $line(@data){

		if($line=~/(line_num=")(.+?)(")/){
			$num = $2;
		}
		if($line=~/(top_left_x=")(.+?)(")/){
			$x1 = $2;
			$x1 = round($x1);
		}
		if($line=~/(top_left_y=")(.+?)(")/){
			$y1 = $2;
			$y1 = round($y1);
		}
		if($line=~/(point_1_x=")(.+?)(")/){
			$x2 = $2;
			$x2 = round($x2);
		}

		if($line=~/(box_height=")(.+?)(")/){
			$box_height = $2;
			$box_height = round($box_height);
		}

		if($line=~/(point_1_y=")(.+?)(")/){
			$y2 = $2;
			$y2 = round($y2)+$box_height;
		}

		if($line=~/(font_size=")(.+?)(")/){
			$font_size = $2;
		}


		if($line=~/(input_box_height=")(.+?)(")/){
			$box_height = $2;
		}

		if($line=~/(line_height=")(.+?)(")/){
			$line_height = $2;
		}
		if($line=~/(letter_spacing=")(.+?)(")/){
			$kern = $2;
		}

		if($line=~/(image_rotation=")(.+?)(")/){
			$rotation = $2;
		}
		if($line=~/(new_line=")(.+?)(")/){

			$text = $2;
			$text=~s/<font class='Apple-style-span' face='Charis Sil'>//g;
			$text=~s/<\/font>//g;
			$text=~s/^\s+//;
	
			$text= qq($text);
		}
		$new_line=qq(    <line num="$num" x1="$x1" y1="$y1" x2="$x2" y2="$y2" box_height="$box_height" font_size="$font_size" line_height="$line_height">$text</line>\n);
		push(@a,$new_line);
	}
print "opening $_\n";
    open(F,">../books/book1/xml2/$_")|| die "can't open ../books/book1/xml2/$_: $!";
    print F $prefix;
    print F @a;
 	print F qq(  </data>\n</entry>);
    close F;
}
