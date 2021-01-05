# vm-manager

Virtual Box easy-peasy VM manager from command line
A simple shell script to easy the start/shutdown and memory dump (Volatility 2 and 3 supported) of a VirtualBox VM

![](./screenshot/vm-manager.png)

  * Notes:
<p><b>vm-w7-64.sh:</b> is the VM to manage (1 file per VM)</p>
<p>Inside the vm file there are 2 variables:</p>
<p><b>VM_NAME=""</b>: variable with the VM name</p>
<p><b>VM_SNAPSHOT=""</b>: variable with snapshot name to revert to</p>

* Main operations:
<p>    --start                     : Start VM</p>
<p>    --stop                      : Shutdown VM</p>
<p>    --dump-v2 [NAME] [LOCATION] : Dump VM memory as Volatility 2 compatible file [NAME] into [LOCATION]</p>
<p>    --dump-v3 [NAME] [LOCATION] : Dump VM memory as Volatility 2 compatible file [NAME] into [LOCATION]</p>
* Snapshot operations:
<p>    --baseline                  : Revert to snapshot<p>