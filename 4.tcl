set ns [new Simulator]
set tr [open out.tr w]
$ns trace-all $tr

set ftr [open out.nam w]
$ns namtrace-all $ftr

set cwind [open win4.tr w]

set n0 [$ns node]
set n1 [$ns node]

$ns color 1 Blue

$n0 label "server"
$n1 label "client"

$ns duplex-link $n0 $n1 2Mb 4ms DropTail

$ns duplex-link-op $n0 $n1 orient right

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

$tcp1 set packetSize_ 1500

set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1

$ns connect $tcp1 $sink1

set ftp [new Application/FTP]
$ftp attach-agent $tcp1

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
	exec xgraph win4.tr &
	exec nam out.nam &
	exit
}

$ns at 0.1 "$ftp start"
$ns at 1.1 "$ftp stop"
$ns at 2.0 "finish"
$ns run

#BEGIN {
#	count=0;
#	time=0;
#	total_bytes_sent=0;
#	total_bytes_received=0;
#}
#{
#	if($1=="r" && $4==1 && $5=="tcp")
#		total_bytes_received += $6;
#	if($1=="+" && $3==0 && $5=="tcp")
#		total_bytes_sent += $6;
#}
#END {
#	system("clear");
#	printf("transmission time %f\n",$2);
#	printf("actual data transfer is %f Mbps\n",(total_bytes_sent)/1000000);
#	printf("recieved data is %f Mbps",(total_bytes_received)/1000000);
#}


#BEGIN {
#	count=0;
#	time=0;
#}
#{
#	if($1=="r" && $4==1 && $5=="tcp")
#	{
#		count +=$6;
#		time=$2;
#		printf("\n %f \t %f",time,(count)/1000000);
#	}
#}
#END {

#} 
