set ns [new Simulator]

set tr [open out.tr w]
$ns trace-all $tr

set ftr [open out.nam w]
$ns namtrace-all $ftr

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 4ms DropTail
$ns duplex-link $n1 $n2 2Mb 4ms DropTail
$ns duplex-link $n2 $n3 2Mb 4ms DropTail
$ns queue-limit $n0 $n2 5

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1

$ns connect $tcp1 $sink1

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n3 $null1

$ns connect $udp1 $null1

set ftp [new Application/FTP]
$ftp attach-agent $tcp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

$ns at 1.1 "$cbr1 start"

proc finish {} {
	global ns tr ftr
	$ns flush-trace
	close $tr
	close $ftr
	exec nam out.nam &
	exit
}


$ns at 0.1 "$ftp start"
$ns at 1.0 "$ftp stop"
$ns at 10.0 "finish"
$ns run

#BEGIN {
#	tcp_count=0;
#	udp_count=0;
#}
#{
#if($1=="d" && $5=="tcp")
#	tcp_count++;
#if($1=="d" && $5=="cbr")
#	udp_count++;
#}
#END {
#	printf("tcp packets lost = %d\n",tcp_count);
# printf("udp packet lost = %d\n",udp_count);
#}



