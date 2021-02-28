set ns [new Simulator]
set ntrace [open p8.tr w]
$ns trace-all $ntrace
set namfile [open p8.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns ntrace namfile
$ns flush-trace
exec nam p8.nam &
close $ntrace
close $namfile

set tcpsize [ exec grep "^r" p8.tr | grep "tcp" | tail -n 1 | cut -d " " -f 6]
set numtcp [ exec grep "^r" p8.tr | grep -c "tcp"]
set tcptime 4.0

set udpsize [ exec grep "^r" p8.tr | grep "cbr" | tail -n 1 | cut -d " " -f 6 ]
set numudp [ exec grep "^r" p8.tr | grep -c "cbr"]
set udptime 4.0
puts "The throughput of FTP is"
puts "[ expr ($numtcp*$tcpsize)/$tcptime] bytes per second"
puts "The throughput of CBR is"
puts "[ expr ($numudp*$udpsize)/$udptime] bytes per second"
exit 0
}


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set lan [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5 $n6 $n7" 5Mb 10ms LL Queue/DropTail channel ]
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$ns at 0.1 "$cbr start"
$ns at 2.0 "$ftp start"
$ns at 1.9 "$cbr stop"
$ns at 4.3 "$ftp stop"
$ns at 6.0 "finish"
$ns run
