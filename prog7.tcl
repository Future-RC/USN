set ns [new Simulator]
set ntrace [open prog6.tr w]
$ns trace-all $ntrace
set namfile [open prog6.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns ntrace namfile
$ns flush-trace
close $ntrace
close $namfile
exec nam prog6.nam &
exit 0
}

for {set i 0} {$i < 7} {incr i} {
  set n($i) [$ns node]
}

for {set i 0} {$i < 7} {incr i} {
$ns duplex-link $n($i) $n([ expr ($i+1)%7]) 1Mb 10ms DropTail
}

$ns rtproto LS
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

$ns at 0.0 "$cbr0 start"
$ns rtmodel-at 1.0 down $n(1) $n(2)
$ns rtmodel-at 2.0 up $n(1) $n(2)
$ns at 3.0 "$cbr0 stop"

$ns at 5.0 "finish"
$ns run
  
 
