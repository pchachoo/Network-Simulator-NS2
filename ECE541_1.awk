#!/usr/bin/awk -f

BEGIN {
counter = 0;
}
#body
{
event = $1
time = $2
dest = $4
app = $5
pkt_size = $6

#printf("before if");
if( event == "r"){  # && app == "cbr"# && time > 0 && time < 10 ) {
#	printf("going into if");
        counter+=pkt_size;
	printf("%f %d\n", time, counter);
    }
}

END { ; }
