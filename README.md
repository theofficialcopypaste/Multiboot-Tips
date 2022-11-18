# Hackintosh Multiboot Tips

**Lists**

* [Prevent ACPI infusion on other operating systems](https://github.com/theofficialcopypaste/Multiboot-Tips#prevent-acpi-infusion-on-other-operating-systems)
* [Unmount non-supported storage formats automatically](https://github.com/theofficialcopypaste/Multiboot-Tips#unmount-non-supported-storage-formats-automatically)
* [Changing the Windows label in the bootpicker](https://github.com/theofficialcopypaste/Multiboot-Tips#changing-the-windows-label-in-the-bootpicker)
* [UTC fix](https://github.com/theofficialcopypaste/Multiboot-Tips#utc-fix)

------------

### Prevent ACPI Infusion on Other Operating Systems

Several steps must be taken to prevent modded ACPI from being injected into other operating systems:

| Bootloader        | Method                                                                   		  |
| ----------------- | ----------------------------------------------------------------------------------- |
| Clover            | Fix `Darwin Option`                                                        	  |
| Official OpenCore | `If \_OSI ("Darwin")` via ACPI, `CustomSMBIOSGuid` and `UpdateSMBIOSMode` Quirks.   |
| OpenCore Mod      | `EnableforAll` Quirks                                                       	  |

#### Clover
##### Fix Darwin option

Open [Clover Configurator](https://mackie100projects.altervista.org/download-clover-configurator/) and look and mark for the **Fix Darwin** option in ACPI Section, which is equivalent to the `If OSI ("Darwin")` argument and save `config.plist`.

![FixDarwin](https://user-images.githubusercontent.com/72515939/202373593-df4abcda-3d38-4548-a9ae-e5403a26b7db.png)

If you are not using [Clover Configurator](https://mackie100projects.altervista.org/download-clover-configurator/), you can use any plist editor to open the config.plist. Find `ACPI` / `DSDT` / `Fixes` / `FixDarwin` = `YES`.

![FixD](https://user-images.githubusercontent.com/72515939/202375889-3fb50eea-8d79-496c-91ff-8ff1db673a25.png)

> **Note**: You are encourage to use SSDT's which return with `0xFF` and `Zero` function by using this bootloader. Change DSDT name in ACPI section from `DSDT.aml` to `BIOS.aml` also reduce `asl` clutters (only when users patch DSDT's using Clover option, not recommend if using modding DSDT). Mark **Automerge** option to set all separate SSDT's patches merge with `BIOS.aml`. Refer the 1st images above.

#### OpenCore
##### OSI implementation

The `If _OSI ("Darwin")` is an implementation method to call Darwin kernel use by macOS. reason to use this implementation.

* To prevent both operating systems conflicted with modified SSDT.
* To ensure device working properly on multiple OS.

![Without](https://user-images.githubusercontent.com/72515939/202378334-31785783-1eeb-4bc1-82e8-03ccb90e4a6c.png)
![With](https://user-images.githubusercontent.com/72515939/202378529-b787b94e-2744-4a81-9bba-3b1ac78d93fa.png)

> **Note**: This require `Kernel` / `Quirks` / `CustomSMBIOSGuid` = `Yes` and `PlatformInfo` / `UpdateSMBIOSMode` = `Custom` via config.plist. Checkout my [SSDT-EXT_info](https://github.com/theofficialcopypaste/ASRockB460MSL-OC/blob/main/SSDT-EXT/SSDT-EXT_info.dsl) for an explanation. 

#### OpenCore Mod
##### EnableforAll approach

OpenCore Mod does not inject ACPI on other OS systems if the "EnableforAll" quirks are enabled via config.plist. Then, using SSDTs without `If _OSI ("Darwin")` implementation is sufficient.

![Without](https://user-images.githubusercontent.com/72515939/202378334-31785783-1eeb-4bc1-82e8-03ccb90e4a6c.png)

> **Note**: This require `ACPI` / `Quirks` / `EnableforAll` = `Yes` and `Booter` / `Quirks` / `EnableforAll` = `Yes` via config.plist. So, you may set `Kernel` / `Quirks` / `CustomSMBIOSGuid` = `No` and `PlatformInfo` / `UpdateSMBIOSMode` = `Create` via config.plist. Checkout my [SSDT-EXTNOACPI](https://github.com/theofficialcopypaste/ASRockB460MSL-OC/blob/main/SSDT-EXT/SSDT-EXTNOACPI.dsl) as an example.

------------

### Unmount non-supported storage formats automatically

Always mounting non-supported storage may:

- shorten the storage lifespan
- cause read / write error.

This solution prevents the Mac from automatically mounting NTFS. This is essential for using **vifs** when editing the **fstab**.

#### Supported and Unsupported System Format

| **Detail**  | **Type**                                                                                                                                                                                                                                                                          |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Supported   | APFS, APFS (Encrypted), APFS (Case-sensitive), APFS (Case-sensitive, Encrypted), Mac OS Extended (Journaled), Mac OS Extended (Journaled, Encrypted), Mac OS Extended (Case-sensitive, Journaled), Mac OS Extended (Case-sensitive, Journaled, Encrypted), MS-DOS (FAT) and ExFAT |
| Unsupported | Ext, Ext2, Ext3, Ext4, JFS, ReiserFS, XFS, btrfs, swap, ReFS and NTFS                                                                                                                                                                                                             

#### The fstab

- configuration table designed to ease the burden of mounting and unmounting file systems to a machine.
- set of rules used to control how different filesystems are treated each time they are introduced to a system. 

The fstab allows the user to avoid load order errors that could eat up valuable time and energy

#### The vifs

- utility to safely edit the `etc` / `fstab` file—the configuration file we are going to tell to not mount our partition. 
- it is actually from the fact that we are using the text editor `vi` to change our file.

> **Note**: Apple recommend `vifs` over `vim` editing apps to prevent an issue

##### Method:

- Open `Disk Utility` &rarr; `Info`
- Find `File System UUID` and `copy UUID value` by using `cmd + c`

![UUID](https://user-images.githubusercontent.com/72515939/202383431-9a3a26d5-a46b-4db6-be97-5f5ef0fe834b.png)

- Type `sudo vifs` on mac terminal
- Press `o` to edit /etc/fstab
- Add `UUID="Volume UUID" none ntfs rw,noauto`.

Example:
```zsh
#
# Warning - this file should only be modified with vifs(8)
#
# Failure to do so is unsupported and may be destructive.
#
UUID=5EB38DF0-4018-4876-8983-B48D089C91C7 none ntfs rw,noauto	// Windows
UUID=FF9DBDC4-F77F-3F72-A6C2-26676F39B7CE none hfs rw,noauto	// macOS HFS+
UUID=FF9DBDC4-F77F-3F72-A6C2-26676F39B7CE none apfs rw,noauto	// macOS APFS
~
~
~
```

- Hit `Esc` to stop editing and press `Shift + ZZ` (double capital Z) to exit `vifs`
- Type `sudo automount -vc` to `reset` auto mounter
- Restart PC.

![UUID](https://user-images.githubusercontent.com/72515939/198338330-84c4f1bd-eb19-4709-b6d8-1ed3e88abd7e.png)

> **Note**: Using vifs is recommended by Apple

------------

### Changing the Windows label in the bootpicker 

#### Generating disk label

- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Find `Utilities` / `disklabel` inside OpenCore folder
- Run Terminal
- Drag the executable unix file disklabel (not the .exe) into the Terminal and hit Enter. Below is sample command to disk labeling:

```zsh
-e "nameofyourdisk" .disk_label .disk_label_2x
```

- The complete line should look like below:

```zsh
-e "Window" .disk_label .disk_label_2x
```

- Hit enter

The disk label files will be stored in your home folder but they are hidden

##### Moving the files to the correct location

- In Finder, got to your Home Folder
- Press `Cmd+Shift+.` to display hidden files. The process before should dumped copy of `.disk_label` and `.disk_label_x2`
- As example, Windows EFI partition. Mount the EFI containing the "Microsoft" Folder
- Paste/Move the `.disk_label` and `.disk_label_x2` label files into the Microsoft/Boot folder.
- Press `Cmd+Shift+.` again to mask the hidden files. Now, adjust `PickerAttributes`

##### Adjusting PickerAttributes

- Open your [config.plist](https://dortania.github.io/OpenCore-Install-Guide/config.plist/) using [OCAT](https://github.com/ic005k/OCAuxiliaryTools)
- Go to Misc/PickerAttributes and click on Select (or just add 2 to the current value), Check `OC_ATTR_USE_DISK_LABEL_FILE`
- Save and Reboot

> **Note**: Credits to [5T33Z0](https://github.com/5T33Z0), for writing this to us

------------

### UTC fix

Solution to fix clock for macOS and Windows

#### Introduction

If you work across time zones, it's important to understand UTC. UTC is the standard of time used all around the world to 

- regulate clocks and
- effectively the "center" of our timekeeping

##### Hackintool

- Boot to macOS
- Open [Hackintool](https://github.com/headkaze/Hackintool) and go to Utilities

![Utilities](https://user-images.githubusercontent.com/72515939/202380813-0753ac51-31ae-4ece-9b69-5830b13e3416.png)

- Click on below-center to generate** .reg** key to be used on Windows.

![Utilities2](https://user-images.githubusercontent.com/72515939/202380902-3d2eb0c4-ed45-4154-9afd-4422febe224c.png)

- Registry key will be exported as

| File  | Key |
| ------------ | ------------ |
| [WinUTCOff.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOff.reg)  |  disable registry patch |
| [WinUTCOn.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOn.reg)  | enable registry patch |

![Reg](https://user-images.githubusercontent.com/72515939/195530554-455d58cd-8efd-4eed-8306-2af0eaac23f3.png)

- Boot to Windows.
- Merge or double click` WinUTCOn.reg` to install and enable registry.
- Reboot to macOS and Windows to make sure the clock is properly sync via UTC.

> **Note**: Please set back exact time online via Windows or Mac.

------------

### Acknowledgement

- [**Acidanthera**](https://github.com/acidanthera) for

```zsh
git clone https://github.com/acidanthera/OpenCorePkg.git
```

- [**Dortania**](https://dortania.github.io/OpenCore-Install-Guide/) for

```zsh
git clone https://github.com/dortania/OpenCore-Install-Guide.git
```

- [**headkaze**](https://github.com/headkaze) for

```zsh
git clone https://github.com/headkaze/Hackintool.git
```
