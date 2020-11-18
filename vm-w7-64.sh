#!/bin/bash

CWD=$(dirname $0)

# VM configuration
# ------------------------------

VM_NAME="W7-64"
VM_SNAPSHOT="Baseline"


function manage () {
    source ${CWD}/engine/vm-manager.sh $@
}

manage $@
