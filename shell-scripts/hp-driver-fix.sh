function fix() {
    local dmg_path=$1
    if [[ ! -f ${dmg_path} ]] || [[ ${dmg_path} != *.dmg ]]; then
        echo "${dmg_path} is not a valid file"
        return
    fi

    echo "Mountings ${dmg_path}"
    hdiutil attach ${dmg_path}
    if [[ $? != 0 ]]; then
        echo "Failed to mount ${dmg_path}. Exiting."
        return
    fi

    echo "Extracting pkg content"
    rm -rf /tmp/hp-expand
    pkgutil --expand /Volumes/HP_PrinterSupportManual/HewlettPackardPrinterDrivers.pkg /tmp/hp-expand
    if [[ $? != 0 ]]; then
        echo "Failed to extract ${dmg_path}. Exiting."
        return
    fi

    echo "Ejecting volume"
    hdiutil eject /Volumes/HP_PrinterSupportManual

    echo "Updating distribution requirement from 15 to 100"
    sed -i '' 's/15.0/100.0/' /tmp/hp-expand/Distribution

    echo "Recreating the pkg file"
    pkgutil --flatten /tmp/hp-expand "HewlettPackardPrinterDrivers_fixed.pkg"
    if [[ $? != 0 ]]; then
        echo "Failed to create new package file. Exiting."
        return
    fi

    echo "Created a HewlettPackardPrinterDrivers_fixed.pkg"
}

fix $1