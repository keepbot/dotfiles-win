#!/usr/bin/env bash

iommu-list()
{
    if [[ `dmesg | grep 'IOMMU enabled'` ]]
    then
    echo "IOMMU is enabled. List of devices: "
        for d in /sys/kernel/iommu_groups/*/devices/*
        do
            n=${d#*/iommu_groups/*}
            n=${n%%/*}
            printf 'IOMMU Group %s ' "$n"
            lspci -nns "${d##*/}"
        done
    else
        print_error "ERROR: IOMMU is disabled"
    fi
}

iommu-list2()
{
    if [[ `dmesg | grep 'IOMMU enabled'` ]]
    then
        for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d)
        do
            echo "IOMMU group $(basename "$iommu_group")"
            for device in $(ls -1 "$iommu_group"/devices/)
            do
                echo -n $'\t'
                lspci -nns "$device"
            done
        done
    else
        print_error "ERROR: IOMMU is disabled"
    fi
}

vfio-bind()
{
    modprobe vfio-pci
    for dev in "$@"
    do
        vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
        device=$(cat /sys/bus/pci/devices/$dev/device)
        if [ -e /sys/bus/pci/devices/$dev/driver ]
        then
            echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
        fi
        echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
    done
}

alias check_iommu='dmesg | grep -e IOMMU -e DMAR'
