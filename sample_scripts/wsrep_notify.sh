#!/bin/bash
# Command to call when node status or cluster membership changes. 
# Some or all of the following options will be passed:
# --status  - New status of node
# --uuid    - UUID of cluster
# --primary - Whether component is Primary ("yes" or "no")
# --members - Comma-separated list of members
# --index   - Index of node in list
	
echo "$@" >> /var/tmp/wsrep_notifications.log
