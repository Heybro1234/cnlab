set ns [new Simulator]

set tf [open tra.tr w]
$ns trace-all $tf

set nf [open na.nam w]
$ns namtrace-all $nf

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

set cbr1 [new Application/CBR/Traffic]
$cbr1 attach-agent $udp1
$ns at 1.1 "$cbr1 start"

$ns at 0.1 "$ftp start"
$ns at 10.0 "finish"

proc finish {} {
	global ns tf nf
	$ns flush-trace 
	close $tf
	close $nf
	exec nam na.nam &
	exit 0
	}
$ns run

