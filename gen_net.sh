#!/usr/bin/env bash
#set -euo pipefail

# Generate .netdev and .network files for systemd-networkd.
# Creates multiple VLANs for one bond and coresponding bridges
# Author: Jan Polák

start_ip=2
bond_num=2
bridge_num=60
ip_prefix="127.0.0"

for i in {1..12}; do

		#templates
		bond_netdev=(
					"[NetDev]"
					"Name=bond1.$i"
					"Kind=vlan"
					""
					"[VLAN]"
					"Id=$i"
					)

		bond_network=(
					"[Match]"
					"Name=bond1.$i"
					""
					"[Network]"
					"Description=\"VLAN $i\""
					"Bridge=br${i}"
					)

		br_netdev=(
					"[NetDev]"
					"Name=br${i}"
					"Kind=bridge"
					)

		br_network=(
					"[Match]"
					"Name=br${i}"

					"[Network]"
					"Address=${ip_prefix}.${start_ip}/30"
					)



        # make name
        bond_name="${bond_num}-bond1.${i}"
        bridge_name="${bridge_num}-br${i}"

        # write to files - bond vlan
        printf "%s\n" "${bond_netdev[@]}"  > "${bond_name}.netdev"
        printf "%s\n" "${bond_network[@]}" > "${bond_name}.network"

        # write to files - bridge
        printf "%s\n" "${br_netdev[@]}"  > "${bridge_name}.netdev"
        printf "%s\n" "${br_network[@]}" > "${bridge_name}.network"

        
        # increment values
        bond_num="$(("$bond_num" + 1))"
        bridge_num="$(("$bridge_num" + 1))"
        start_ip="$(("$start_ip" + 4))"



done
