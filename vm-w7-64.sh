#!/bin/bash

CWD=$(dirname $0)

# VM configuration
# ------------------------------

VM_NAME="W764B"
VM_SNAPSHOT="Baseline"


function manage () {
    source ${CWD}/engine/vm-manager.sh $@
}

manage $@
