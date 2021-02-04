Vormetric agent upgrade checker script (linux)
==============================================
This script is specific to the Armor environment.

Problem Statement
-----------------
For Linux servers the Vormetric agent's kernel module is deeply coupled to the kernel version and as such kernels can only be upgraded once a Vormetric agent compatible with the kernel is installed, otherwise it will result in filesystem/OS instability. Kernels are pinned, and kernel/agent upgrades must be completed manualy as and when a new agent and compatible kernel are available.


Solution
--------
The scripting outlined can be used to check if a new agent is available and confirm the kernel compatibility, it produces a report that can be easily reviewed and decision can be made to upgrade the vormetric agent and kernel. It can be automated to check on a regular interval. The scripting is compatible with both Ubuntu and Centos.


Output details
--------------
Calling the script from a shell outputs the following detail:

If there is a new agent available:

* Current agent version
* New Agent Version
* Hostname
* IP address(es)
* Operating system
* Current running kernel
* Latest available kernel
* Compatibility check for new agent with running kernel and latest available kernel
* A list of all compatible kernels with new agent
* A short message telling the customer they can contact Armor support to arrange an agent/kernel upgrade



If there is NOT a new agent available:

* A short message saying the check is complete and no agent is available.
* Hostname

### Example output
```
[root@centosvormetric ~]# ./vorgrade.sh
 
New Vormetric agent available
 
Hostname:
centosvormetric
 
IP Address(es):
100.64.164.51
 
Operating system:       centos 7
Current kernel:         3.10.0-957.5.1.el7.x86_64
Latest kernel:          3.10.0-957.27.2.el7
 
Current agent version:  6.1.3.63
New agent version:      6.2.0.100
 
Current kernel supported by latest agent:       YES
Latest kernel supported by latest agent :       YES
 
Fully kernel compatibility list for latest agent:
 
# Red Hat Enterprise Linux 7 kernels supported by VTE
 
#Section: RHEL 7.0 Kernels
3.10.0-123.el7.x86_64
3.10.0-123.1.2.el7.x86_64
3.10.0-123.4.2.el7.x86_64
3.10.0-123.4.4.el7.x86_64
3.10.0-123.6.3.el7.x86_64
3.10.0-123.8.1.el7.x86_64
3.10.0-123.9.2.el7.x86_64
3.10.0-123.9.3.el7.x86_64
3.10.0-123.13.1.el7.x86_64
3.10.0-123.13.2.el7.x86_64
3.10.0-123.20.1.el7.x86_64
 
#Section: RHEL 7.1 Kernels
3.10.0-229.el7.x86_64
3.10.0-229.1.2.el7.x86_64
3.10.0-229.4.2.el7.x86_64
3.10.0-229.7.2.el7.x86_64
3.10.0-229.11.2.el7.x86_64
3.10.0-229.14.2.el7.x86_64
3.10.0-229.20.1.el7.x86_64
 
#Section: RHEL 7.2 Kernels
3.10.0-327.el7.x86_64
3.10.0-327.3.1.el7.x86_64
3.10.0-327.4.4.el7.x86_64
3.10.0-327.4.5.el7.x86_64
3.10.0-327.10.1.el7.x86_64
3.10.0-327.13.1.el7.x86_64
3.10.0-327.18.2.el7.x86_64
3.10.0-327.22.2.el7.x86_64
3.10.0-327.28.2.el7.x86_64
3.10.0-327.28.3.el7.x86_64
3.10.0-327.36.1.el7.x86_64
3.10.0-327.36.2.el7.x86_64
3.10.0-327.36.3.el7.x86_64
 
#Section: RHEL 7.3 Kernels
3.10.0-514.el7.x86_64
3.10.0-514.2.2.el7.x86_64
3.10.0-514.6.1.el7.x86_64
3.10.0-514.6.2.el7.x86_64
3.10.0-514.10.2.el7.x86_64
3.10.0-514.16.1.el7.x86_64
3.10.0-514.21.1.el7.x86_64
3.10.0-514.21.2.el7.x86_64
3.10.0-514.26.1.el7.x86_64
3.10.0-514.26.2.el7.x86_64
3.10.0-514.36.5.el7.x86_64
 
#Section: RHEL 7.4 Kernels
3.10.0-693.el7.x86_64
3.10.0-693.1.1.el7.x86_64
3.10.0-693.2.1.el7.x86_64
3.10.0-693.2.2.el7.x86_64
3.10.0-693.5.2.el7.x86_64
3.10.0-693.11.1.el7.x86_64
3.10.0-693.11.6.el7.x86_64
3.10.0-693.17.1.el7.x86_64
3.10.0-693.21.1.el7.x86_64
 
#Section: RHEL 7.4 EUS Kernels
3.10.0-693.43.1.el7.x86_64
3.10.0-693.44.1.el7.x86_64
 
#Section: RHEL 7.5 Kernels
3.10.0-862.el7.x86_64
3.10.0-862.2.3.el7.x86_64
3.10.0-862.3.2.el7.x86_64
3.10.0-862.3.3.el7.x86_64
3.10.0-862.6.3.el7.x86_64
3.10.0-862.9.1.el7.x86_64
3.10.0-862.11.6.el7.x86_64
3.10.0-862.14.4.el7.x86_64
 
#Section: RHEL 7.5 EUS Kernels
3.10.0-862.27.1.el7.x86_64
 
#Section: RHEL 7.6 Kernels
3.10.0-957.el7.x86_64
3.10.0-957.1.3.el7.x86_64
3.10.0-957.5.1.el7.x86_64
3.10.0-957.10.1.el7.x86_64
3.10.0-957.12.1.el7.x86_64
3.10.0-957.12.2.el7.x86_64
3.10.0-957.21.2.el7.x86_64
3.10.0-957.21.3.el7.x86_64
3.10.0-957.27.2.el7.x86_64
 
#Section: RHEL 7.7 Kernels
3.10.0-1062.el7.x86_64
 
#Please retain blank line at the end of file
 
Please contact Armor support by raising a support if you would like a vormetric agent/kernel upgrade.
Please include this output in the ticket to assist our engineers.
 
Kind regards,
 
Friendly Armor Support Script.
```

Suggested use
--------------
The suggested use is to create a daily/weekly/monthly (depending on you requirements) task that executes the script to perform the check and emails the script output.

### Prerequisites
The "mail" utility must be installed and working on the server.
server must either have a configured mail relay or outbound port 25 access

### Configuration walkthrough
First add the script and confirm script is working by executing it.
```
[root@centosvormetric ~]# /opt/vorgrade/vorgrade.sh
.....
Output removed
.....
```

Create the email script and execute to ensure is working (email should be received)

```
[root@centosvormetric ~]# vim /opt/vorgrade/vorgrade_mail.sh
 
#! /bin/bash
/opt/vorgrade/vorgrade.sh | mail -s "Vormetric Upgrade Check Result" <email_address@domain.com>
echo "Upgrade check complete"
 
 
[root@centosvormetric ~]# chmod +x /opt/vorgrade/vorgrade_mail.sh
[root@centosvormetric ~]# /opt/vorgrade/vorgrade_mail.sh
```

Create systemd unit for the task:

```
[root@centosvormetric ~]# vim /etc/systemd/system/vorgrade.service
 
 
[Unit]
Description=Checks for vormetric upgrade and emails output
 
[Service]
ExecStart=/bin/bash /opt/vorgrade/vorgrade_mail.sh
KillMode=process
```

Load the new unit and the test the unit (email should be received)

```
[root@centosvormetric ~]# systemctl daemon-reload
[root@centosvormetric ~]# systemctl start vorgrade.service
```

Create systemd timer:

```
[root@centosvormetric ~]# vim /etc/systemd/system/vorgrade.timer
 
[Unit]
Description=Periodic Vormetric upgrade timer
 
[Timer]
OnCalendar=hourly
Persistent=true
 
[Install]
WantedBy=timers.target
"hourly" can be replaced with "daily", "weekly" or "monthly"
```

Start the timer and confirm it is running:

```
[root@centosvormetric ~]# systemctl start vorgrade.timer
[root@centosvormetric ~]# systemctl list-timers
NEXT                         LEFT         LAST                         PASSED  UNIT                         ACTIVATES
Mon 2019-08-26 13:00:00 UTC  34min left   n/a                          n/a     vorgrade.timer               vorgrade.service
Mon 2019-08-26 16:29:31 UTC  4h 4min left Sun 2019-08-25 16:29:31 UTC  19h ago systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service
 
2 timers listed.
Pass --all to see loaded but inactive timers, too.
```
