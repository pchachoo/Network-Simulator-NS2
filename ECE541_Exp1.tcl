#Create a simulator object

set ns [new Simulator]

 

#Define different colors for data flows

$ns color 1 Blue

$ns color 2 Red

 

#Open the nam trace file

set nf [open ECE541_Exp11.nam w]

$ns namtrace-all $nf

 

set nd [open ECE541_Exp11.tr w]

$ns trace-all $nd

 

#Define a 'finish' procedure

proc finish {} {

        global ns nf nd

        $ns flush-trace

        #Close the trace file

        close $nf

        close $nd

        #Execute nam on the trace file
        #exec nam ECE541_Exp1.nam &

	#get total packet size
	exec awk -f ECE541_1.awk ECE541_Exp11.tr > ECE541_Exp11X.tr 
	#get total number of packets and packets lost
	exec awk -f ECE541_2.awk ECE541_Exp11.tr > ECE541_Exp11P.tr 

	#exec xgraph ECE541_Exp11X.tr -geometry 800x400 &

        exit 0

}

 

#Create four nodes

set n0 [$ns node]

set n1 [$ns node]

 

#Create links between the nodes

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

#Set queue size

$ns queue-limit $n0 $n1 50



#Create a UDP agent and attach it to node n0

set udp0 [new Agent/UDP]

$udp0 set class_ 2

$ns attach-agent $n0 $udp0

 

# Create a CBR over UDP connection 

set cbr [new Application/Traffic/CBR]

$cbr set packetSize_ 1500

$cbr set rate_ 0.1Mb

$cbr set type_ CBR

$cbr set random_ false

$cbr set interval_ 0.005

$cbr attach-agent $udp0


#Create a Null agent (a traffic sink) and attach it to node n1

set null1 [new Agent/Null]

$ns attach-agent $n1 $null1
 

#Connect the traffic sources with the traffic sink

$ns connect $udp0 $null1  
 

#Schedule events for the CBR agents

$ns at 0.5 "$cbr start"

$ns at 10.0 "$cbr stop"


#Call the finish procedure after 5 seconds of simulation time

$ns at 10.0 "finish"

 

#Run the simulation

$ns run
