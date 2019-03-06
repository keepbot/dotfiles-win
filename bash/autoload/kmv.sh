check_iommu() {
    if [[ `dmesg | grep 'IOMMU enabled'` ]]; then
    echo "IOMMU is enabled. List of devices: "
        for d in /sys/kernel/iommu_groups/*/devices/*; do
            n=${d#*/iommu_groups/*}
            n=${n%%/*}
            printf 'IOMMU Group %s ' "$n"
            lspci -nns "${d##*/}"
        done
    else
        print_error "ERROR: IOMMU is disabled"
    fi
}
