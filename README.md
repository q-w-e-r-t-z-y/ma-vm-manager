# vm-manager

Virtual Box easy-peasy VM manager from command line
A simple shell script to easy the start/shutdown and memory dump of a VirtualBox VM

![](./screenshot/vm-manager.png)

  * Notes:
<p><b>vm-w7-32b-clean.sh:</b> is the VM to manage (1 file per VM)</p>
<p>Inside the vm file there are 2 variables:</p>
<p><b>VM_NAME="W7-32B-Clean"</b>: variable with VM name</p>
<p><b>VM_SNAPSHOT="Baseline"</b>: variable with snapshot name to revert to</p>

* Main operations:
<p>    --start                  : Start VM</p>
<p>    --stop                   : Shutdown VM</p>
<p>    --dump [NAME] [LOCATION] : Dump VM memory as file [NAME] into [LOCATION]</p>

* Snapshot operations:
<p>    --baseline               : Revert to snapshot<p>