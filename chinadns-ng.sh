#!/bin/bash
ipset -R < /chinadns-ng/chnroute.ipset
chinadns-ng -b 127.0.0.1 -l 5363 -c 192.168.1.1 -t 127.0.0.1#5353 -g /chinadns-ng/gfwlist.txt -m /chinadns-ng/chnlist.txt
