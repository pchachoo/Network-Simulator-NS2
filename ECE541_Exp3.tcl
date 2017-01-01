#Create a simulator object

set ns [new Simulator]

 

#Define different colors for data flows

$ns color 1 Blue

$ns color 2 Red

 

#Open the nam trace file

set nf [open ECE541_Exp36.nam w]

$ns namtrace-all $nf

 

set nd [open ECE541_Exp36.tr w]

$ns trace-all $nd

 

#Define a 'finish' procedure

proc finish {} {

        global ns nf nd

        $ns flush-trace

        #Close the trace file

        close $nf

        close $nd

        #Execute nam on the trace file
        #exec nam ECE541_Exp12.nam &

	#get total packet size
	exec awk -f ECE541_1.awk ECE541_Exp36.tr > ECE541_Exp36X.tr 
	#get total number of packets and packets lost
	exec awk -f ECE541_2.awk ECE541_Exp36.tr > ECE541_Exp36P.tr 

        exit 0

}

#Create four nodes

set n0 [$ns node]

set n1 [$ns node]


#Create links between the nodes

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

#Set queue size

$ns queue-limit $n0 $n1 100 



#Create a UDP agent and attach it to node n0

set udp0 [new Agent/UDP]

$udp0 set packetSize_ 1500

$udp0 set class_ 1

$ns attach-agent $n0 $udp0

 

# Create a Poisson traffic source and attach it to udp0

set Poi0 [new Application/Traffic/Poisson]

$Poi0 set packetSize_ 1500

$Poi0 set rate_ 0.95Mb

$Poi0 attach-agent $udp0



#Create a Null agent (a traffic sink) and attach it to node n1

set null1 [new Agent/Null]

$ns attach-agent $n1 $null1
 

#Connect the traffic sources with the traffic sink

$ns connect $udp0 $null1  
 

#Schedule events for the CBR agents

$ns at 0.5 "$Poi0 start"

$ns at 10.0 "$Poi0 stop"


#Call the finish procedure after 10 seconds of simulation time

$ns at 10.0 "finish"

 

#Run the simulation

$ns run
