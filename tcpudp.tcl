set ns [new Simulator]

set tf [open tra.tr w]
$ns trace-all $tf

set nf [open na.nam w]
$ns namtrace-all $nf
set cwind [open win2.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 10ms DropTail
$ns queue-limit $n0 $n2 5

#tcp agent

set tcp [new Agent/TCP]
$ns attach-agent $n3 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp


#udp agent

set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n2 $null1

$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$ns at 1.1 "$cbr1 start"

$ns at 0.1 "$ftp start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file" 
	}
	
	$ns at 2.0 "plotWindow $tcp $cwind"
	

proc finish {} {
	global ns tf nf
	$ns flush-trace 
	close $tf
	close $nf
	exec nam na.nam &
	exec xgraph win2.tr &
	exit 0
	}
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


