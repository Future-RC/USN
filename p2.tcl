set ns [new Simulator]
set ntrace [open p2.tr w]
$ns trace-all $ntrace
set namfile [open p2.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns ntrace namfile
$ns flush-trace
close $ntrace
close $namfile
exec nam p2.nam &
exec echo "The no. of TCP pkts sent are " &
exec grep "^+" p2.tr | cut -d " " -f 5 | grep -c "tcp" &
exec echo "The no. of UDP pkts sent are " &
exec grep "^+" p2.tr | cut -d " " -f 5 | grep -c "cbr" &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.07Mb 20ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 set type_ FTP
$ftp0 attach-agent $tcp0

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set type_ CBR
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 0.01Mb
$cbr0 set random_ false  
$cbr0 attach-agent $udp0

$ns at 0.1 "$cbr0 start"
$ns at 6.0 "$ftp0 start"
$ns at 5.0 "$cbr0 stop"
$ns at 10.0 "$ftp0 stop"
$ns at 11.0 "finish"
$ns run

