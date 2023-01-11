set ns [new Simulator]

set tracefile [open ex5.tr w]
$ns trace-all $tracefile

set namfile [open ex5.nam w]
$ns namtrace-all $namfile

set s [$ns node]
set c [$ns node]

$ns color 1 Blue

$s label "Server"
$c label "Client"

$ns duplex-link $s $c 100Mb 22ms DropTail

$ns duplex-link-op $s $c orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0
$tcp0 set packetSize 1500

set sink0 [new Agent/TCPSink]
$ns attach-agent $c $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$tcp0 set fid_ 1
proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam ex5.nam &
	exec awk -f transfer.awk ex5.tr &
	exec awk -f ex5convert.awk ex5.tr > convert &

}

$ns at 0.01 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"
$ns run
