set ns [new Simulator]
set tr [open out.tr w]
$ns trace-all $tr

set ftr [open out.nam w]
$ns namtrace-all $ftr

set cwind [open win2.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 2Mb 4ms DropTail
$ns duplex-link $n2 $n3 2Mb 4ms DropTail
$ns duplex-link $n3 $n4 2Mb 4ms DropTail
$ns duplex-link $n4 $n5 2Mb 4ms DropTail
$ns duplex-link $n4 $n6 2Mb 4ms DropTail

$ns duplex-link-op $n1 $n3 orient right-down
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down


set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n6 $sink1

$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink2

$ns connect $tcp2 $sink2

set ftp [new Application/FTP]
$ftp attach-agent $tcp1

set telnet [new Application/Telnet]
$telnet attach-agent $tcp2

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
	
	$ns at 2.0 "plotWindow $tcp1 $cwind"
	$ns at 5.5 "plotWindow $tcp2 $cwind"

proc finish {} {
	global ns tr ftr
	$ns flush-trace
	close $tr
	close $ftr
	puts "runninf nam...."
	puts "ftp packets......"
	puts "telnet packets...."
	exec nam out.nam &
	exec xgraph win2.tr &
	exit
}

$ns at 1.2 "$ftp start"
$ns at 1.5 "$telnet start"
$ns at 10.0 "finish"
$ns run

#BEGIN {
#	st_time=0
#	end_time=0
#	psize=0
#	flag=0
#}
#{
#	if($5=="tcp" && $1=="r" && $4=="5")
#	{
#		psize+=$6
#		if(flag==0)
#		{
#			st_time=$2
#			flag=1
#		}
#		end_time=$2
#	}
#}
#END {
#	printf("Throughput = %f Mbps \n", (psize*8/1000000)/(end_time-st_time))
#	printf("start time = %f , end time = %f \n",st_time,end_time)
#}
