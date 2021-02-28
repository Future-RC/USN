set ns [new Simulator]
set ntrace [open p4.tr w]
$ns trace-all $ntrace
set namfile [open p4.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns ntrace namfile
$ns flush-trace
close $ntrace
close $namfile
exec nam p4.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "$from recieved ping answer from node [$node_ id] with round trip time $rtt ms"
}

set p0 [new Agent/Ping]
$ns attach-agent $n0 $p0
set p1 [new Agent/Ping]
$ns attach-agent $n2 $p1
$ns connect $p0 $p1

$ns at 0.2 "$p0 send"
$ns at 0.4 "$p1 send"
$ns at 1.2 "$p0 send"
$ns at 1.7 "$p1 send"
$ns at 1.8 "finish"
$ns run
