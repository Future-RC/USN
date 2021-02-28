set ns [new Simulator]
set ntrace [open p5.tr w]
$ns trace-all $ntrace
set namfile [open p5.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns ntrace namfile
$ns flush-trace
close $ntrace
close $namfile
exec nam p5.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n0 2Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n2 $null1
$ns connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2
$ns connect $udp2 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2

set udp3 [new Agent/UDP]
$ns attach-agent $n3 $udp3
set null3 [new Agent/Null]
$ns attach-agent $n0 $null3
$ns connect $udp3 $null3
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3

$ns at 0.0 "$cbr0 start"
$ns at 2.0 "$cbr1 start"
$ns at 3.0 "$cbr2 start"
$ns at 4.0 "$cbr3 start"

$ns at 2.0 "$cbr0 stop"
$ns at 3.0 "$cbr1 stop"
$ns at 4.0 "$cbr2 stop"
$ns at 5.0 "$cbr3 stop"
$ns at 10.0 "finish"
$ns run


