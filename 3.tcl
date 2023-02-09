set ns [new Simulator]
set tr [open out.tr w]
$ns trace-all $tr

set ftr [open out.nam w]
$ns namtrace-all $ftr

set cwind [open win3.tr w]
$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 2Mb 4ms DropTail
$ns duplex-link $n0 $n2 2Mb 4ms DropTail
$ns duplex-link $n1 $n4 2Mb 4ms DropTail
$ns duplex-link $n2 $n3 2Mb 4ms DropTail
$ns duplex-link $n4 $n5 2Mb 4ms DropTail
$ns duplex-link $n3 $n5 2Mb 4ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n3 $n5 orient right-up

$ns queue-limit $n1 $n4 10
$ns queue-limit $n2 $n3 10

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1

$ns connect $tcp1 $sink1

set ftp [new Application/FTP]
$ftp attach-agent $tcp1

$tcp1 set fid_ 1

$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
	
	$ns at 1.0 "plotWindow $tcp1 $cwind"

proc finish {} {
	global ns tr ftr
	$ns flush-trace
	close $tr
	close $ftr
	puts "running nam..."
	exec xgraph win3.tr &
	exec nam out.nam &
	exit
}

$ns at 0.1 "$ftp start"
$ns at 12.0 "finish"
$ns run


