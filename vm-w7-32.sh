#!/bin/bash

CWD=$(dirname $0)

# VM configuration
# ------------------------------

VM_NAME="WIN7-32"
VM_SNAPSHOT="Clean"


function manage () {
    source ${CWD}/engine/vm-manager.sh $@
}

manage $@
