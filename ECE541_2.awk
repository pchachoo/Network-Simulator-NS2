#!/usr/bin/awk -f

BEGIN {
losscounter = 0;
packetcounter = 0;
}
#body
{
event = $1
time = $2
dest = $4
app = $5
pkt_size = $6

#printf("before if");
packetcounter++;
if( event == "d"){  # && app == "cbr"# && time > 0 && time < 10 ) {
#	printf("going into if");
        losscounter++;
    }
}

END { printf("%d %d\n", packetcounter, losscounter); }
