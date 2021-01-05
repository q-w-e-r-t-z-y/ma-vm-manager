#!/bin/bash

NOW=$(date +"%Y%m%d%H%M%S")
CWD=$(dirname $0)

# Host configuration
# ------------------------------


function vm_dump () {
    local value_action=$1
    local value_name=$2
    local value_location=$3
    case $value_action in
        "--dump-v2") 
            if [[ "$#" -gt 2 ]]; then
                if VBoxManage showvminfo $VM_NAME --machinereadable | grep '^VMState="poweroff"$' > /dev/null ; then
                    printf "*** ERROR: - $VM_NAME is not running, exiting...\n"
                else
                    file="$value_location/$value_name/$NOW-$value_name-VBOX-MEM-DUMP"
                    file_elf="$file.elf"
                    file_raw="$file.raw"
                    printf "Dumping \"$VM_NAME\" memory contents into \"$file_elf\"...\n"
                    mkdir -p "$value_location/$value_name"
                    VBoxManage debugvm $VM_NAME dumpvmcore --filename "$file_elf"
                    size=0x$(objdump -h "$file_elf" | egrep -w load1 | awk '{print $3}')
                    off=0x$(echo "obase=16;ibase=16;`objdump -h "$file_elf" | egrep -w load1 | awk '{print $6}' | tr /a-z/ /A-Z/`" | bc)
                    printf "Converting from ELF64 to RAW: Offset=$off, Size=$size\n"
                    head -c $(($size+$off)) "$file_elf"| tail -c +$(($off+1)) > "$file_raw"
                    rm "$file_elf"
                    printf "Volatility 2 dump $file_raw is ready...\n"
                fi
            else
                printf "*** ERROR: - Missing parameter, exiting...\n" 
            fi
        ;;
        "--dump-v3") 
            if [[ "$#" -gt 2 ]]; then
                if VBoxManage showvminfo $VM_NAME --machinereadable | grep '^VMState="poweroff"$' > /dev/null ; then
                    printf "*** ERROR: - $VM_NAME is not running, exiting...\n"
                else
                    file="$value_location/$value_name/$NOW-$value_name-VBOX-MEM-DUMP"
                    file_elf="$file.elf"
                    printf "Dumping \"$VM_NAME\" memory contents into \"$file_elf\"...\n"
                    mkdir -p "$value_location/$value_name"
                    VBoxManage debugvm $VM_NAME dumpvmcore --filename "$file_elf"
                    printf "Volatility 3 dump $file_elf is ready...\n"
                fi
            else
                printf "*** ERROR: - Missing parameter, exiting...\n" 
            fi
        ;;
        *) 
            printf "*** ERROR: - Undefined [vm_dump] _value_: \"$value_action\", exiting...\n" 
        ;;
    esac
}

function vm_power () {
    local value_action=$1
    case $value_action in
        "--start") 
            if VBoxManage showvminfo $VM_NAME --machinereadable | grep -E 'VMState="poweroff"|VMState="saved"' > /dev/null ; then 
                VBoxManage startvm $VM_NAME --type headless 2>/dev/null
                printf "Boot timeout: "
                for timeout in {12..2}
                do
                    printf "$timeout, "
                    sleep 1
                done
                printf "1\n"
            else
                printf "\"$VM_NAME\" is already running, skipping power on...\n"
            fi
        ;;
        "--stop") 
            if ! VBoxManage showvminfo $VM_NAME --machinereadable | grep -E 'VMState="poweroff"|VMState="saved"' > /dev/null ; then 
                VBoxManage controlvm $VM_NAME acpipowerbutton 2>/dev/null
                while [ $(VBoxManage list runningvms | grep -c $VM_NAME) -gt 0 ]
                do
                    printf "Waiting for VM \"$VM_NAME\" to shutdown...\n"
                    sleep 1
                done
                    printf "\"$VM_NAME\" not running\n"
            else
                printf "\"$VM_NAME\" is not running, skipping power off...\n"
            fi
        ;;
        *) 
            printf "*** ERROR: - Undefined [vm_power] _value_: \"$value_action\", exiting...\n" 
        ;;
    esac
}

function vm_snapshot () {
    local value_action=$1
    case $value_action in
        "--baseline") 
            VBoxManage snapshot $VM_NAME restore "$VM_SNAPSHOT"
        ;;
        *) 
            printf "*** ERROR: - Undefined [vm_snapshot] _value_: \"$value_action\", exiting...\n" 
        ;;
    esac
}


# Main
# ------------------------------

function main () {
    case $action in
        "--dump-v2")
            vm_dump $action $parameters
        ;;
        "--dump-v3")
            vm_dump $action $parameters
        ;;
        "--start" | "--stop")
            vm_power $action
        ;;
        "--baseline")
            vm_power "--stop"
            vm_snapshot $action
        ;;
        *)
            printf "$0 - Option \"$action\" was not recognized...\n"
            printf "\n  Virtual Machine: $VM_NAME\n"
            printf "\n  * Main operations:\n"
            printf "    --start                     : Start VM\n"
            printf "    --stop                      : Shutdown VM\n"
            printf "    --dump-v2 [NAME] [LOCATION] : Dump VM memory as Volatility 2 compatible file [NAME] into [LOCATION]\n"
            printf "    --dump-v3 [NAME] [LOCATION] : Dump VM memory as Volatility 3 compatible file [NAME] into [LOCATION]\n"
            printf "\n  * Snapshot operations:\n"
            printf "    --baseline                  : Revert \"$VM_NAME\" to snapshot \"$VM_SNAPSHOT\"\n"
        ;;
    esac
}

action=$1
parameters=${*: 2}

main $action $parameters
