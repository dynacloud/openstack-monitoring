#!/bin/bash
#
# Neutron server monitoring script
#
# Copyright © 2013 eNovance <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
set -e

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

if ! which netstat >/dev/null 2>&1
then
    echo "netstat are not installed."
    exit $STATE_UNKNOWN
fi

failed=0
for i in $(ip netns | grep qrouter); do if ! KEY=$(ip netns exec $i netstat -lnopt | grep 9697); then echo neutron-ns-metadata-proxy not listening on port 9697 in namespace $i; failed=1; fi; done

if [ "$failed" == "1" ]; then
  exit $STATE_CRITICAL
fi

exit $STATE_OK
