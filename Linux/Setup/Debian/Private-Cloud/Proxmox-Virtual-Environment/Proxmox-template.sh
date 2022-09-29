#!/bin/bash


# Vars
package="net-tools curl wget qemu-guest-agent"

# Function
function update {
    if [ -f /usr/bin/apt ]; then
        echo "Debian based system detected"
        sudo apt update
        sudo apt dist-upgrade -y
        echo "Install dependencies"
        sudo apt-get install -y $package
    elif [ -f /usr/bin/yum ]; then
        echo "Redhat based system detected"
        sudo yum update -y
        echo "Install dependencies"
        sudo yum install -y $package
    else
        echo "No package manager found"
        exit 1
    fi
}
function deletekeyhost {
    sudo rm -rf /etc/ssh/ssh_host_*
}
function deletekeyclient {
    if [ -d /home/*/.ssh ]; then
        sudo rm -rf /home/*/.ssh
    fi
}
function deletemachineid {
    if [ -f /etc/machine-id ]; then
        sudo truncate -s 0 /etc/machine-id
    fi
}
function deletehistory {
    if [ -f /root/.bash_history ]; then
        sudo rm -rf /root/.bash_history
    fi
    if [ -f /home/*/.bash_history ]; then
        sudo rm -rf /home/*/.bash_history
    fi
}
# Main
echo "Update and upgrade"
update
echo "Delete keys"
deletekeyhost
deletekeyclient
echo "Delete machine ID"
deletemachineid
echo "Delete history"
deletehistory




