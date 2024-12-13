#!/bin/bash

myIP=$(bash myIP.bash)


# Helpmenu function that prints help for the script
function helpMenu(){
echo ""
echo "  HELP MENU  "
echo "-------------"
echo "-n: Add -n as an argument for this script to use nmap"
echo "  -n external: External NMAP scan"
echo "  -n internal: Inernal NMAP scan"
echo "-s: Add -s as an argument for this script to use ss"
echo "  -s external: External ss(Netstat) scan"
echo "  -s internal: Internal ss(Netstat) scan"
echo ""
echo "Usage: bash networkchecker.bash -n/-s external/internal"
echo "-------------"
echo ""
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "$rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "$rin"
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){
  extport=$(ss -ltpn | awk -F"[[:space:]:(),]+" '/'$myIP'/ {print $5,$9}' | tr -d "\"")
  echo "$extport"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
  ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
  echo "$ilpo"
}

# Prints the helpmenu if the program is not provided with exactly 2 arguments
if [ ! ${#} -eq 2 ]; then
helpMenu
exit;
fi

# Processing Arguments using getopts to accept -n and -s options w/ arguments
while getopts "n:s:" option; do
	case $option in
	n)
		# Determine if user wants to run an internal or external nmap scan, then run function
		if [[ "$2" == "internal" ]]; then
			InternalNmap
		elif [[ "$2" == "external" ]]; then
			ExternalNmap
		else
			helpMenu
		fi
	;;
 	s)
		# Determine if the user wantes to run an internal or external ss scan, then run function
		if [[ "$2" == "internal" ]]; then
			InternalListeningPorts
		elif [[ "$2" == "external" ]]; then
			ExternalListeningPorts
		else
			helpMenu
		fi
	;;
	\?)
		helpMenu
	esac
done
