# Hackintosh Multiboot Tips

**Lists**

- [Multiboot USB Procedure](https://github.com/theofficialcopypaste/Multiboot-Tips#multiboot-usb-procedure)
- [Prevent ACPI infusion on other operating systems](https://github.com/theofficialcopypaste/Multiboot-Tips#prevent-acpi-infusion-on-other-operating-systems)
- [Unmount non-supported storage formats automatically](https://github.com/theofficialcopypaste/Multiboot-Tips#unmount-non-supported-storage-formats-automatically)
- [Changing other OS label](https://github.com/theofficialcopypaste/Multiboot-Tips#changing-other-os-label)
- [UTC](https://github.com/theofficialcopypaste/Multiboot-Tips#utc)

---
### Multiboot USB Procedure

#### Installation

To perform multiboot install operating system, you need to consider one thing:
 * Which OS first to install?
 * What is current OS you have?
  
If your current OS is Windows, you may proceed to install macOS regularly as guided by Dortania. If Linux, same procedure. The problem is if you already has macOS installed. Windows will overwrite `EFI` partition if you not unplugged manually `SATA` or `NVME` which contain Linux and macOS in installation process.

#### What is the best procedure?

The best way is to install Windows first since macOS and Linux don't overwrite `EFI` partition. This methos is not applicable to Bootcamp. Separate disk is encourage.

#### Multiple USB Installation creation.

Using Ventoy as multiboot installation tool is great alternative to prevent an issue. There is a way to combine all operating system (Windows / Linux / macOS). To create this tools, make sure you have Windows and Linux as current operating system before you are doing fresh install.

#### Ventoy (Windows)

* First, create Ventoy USB as GPT format
* Spare at least 1.5GB space for other purpose. In this case, we spare the space for OpenCore purpose.
* After ventoy installation, format 1.5GB spare space using DiskGenius as ESP partition format. Usually this will format the space as fat32.

#### Ventoy (Linux)

* Same procedure as above, install Ventoy first using the same format as mention above. 
* Spare exactly the same space (1.5GB) to create extra EFI patition using gparted.

#### Moving the file

* Just move other operating system to the drive name Ventoy (Linux / Windows)
* Move openCore `EFI` folder to pare 1.5GB extra EFI partition.
* Move `com.apple.recovery.boot` exatcly at the same place where OpenCore `EFI` folder is located.

Below is an example:

![Settings_1](https://user-images.githubusercontent.com/72515939/205746086-d9bc7e87-f176-498b-8f7e-3d26c5adeae6.png)
![Settings_2](https://user-images.githubusercontent.com/72515939/205746100-85bfd440-196b-441c-b86b-436561cb154c.png)
![Settings_3](https://user-images.githubusercontent.com/72515939/205746111-53cdc7f2-3fa7-4e4e-abb2-53faf539befa.png)

---

### Prevent ACPI Infusion on Other Operating Systems

The `If _OSI ("Darwin")` is an implementation method to call Darwin kernel used by macOS. Reason to use this implementation.

- to provide the device `on/enable` and `off/disable` functions for different operating systems
- to prevent `BSOD` issues when booting into Windows.

The ACPI interface is not too complex for Linux. To resolve operating system issues, the majority of distribution use kernel patches submitted by developers.

![With](https://user-images.githubusercontent.com/72515939/202378529-b787b94e-2744-4a81-9bba-3b1ac78d93fa.png)

> **Note**: Additionally, combining SSDT with `_OSI` implementation + OpenCore quirks via `Kernel` > `Quirks` > `CustomSMBIOSGuid` = `Yes` and `PlatformInfo` > `UpdateSMBIOSMode` = `Custom` is the best approach to dual- or multiboot.

---

### Unmount non-supported storage formats automatically

Always mounting non-supported storage may:

- shorten the storage lifespan.
- cause read / write error.

This solution prevents the mac's automatically mounting the NTFS file format by utilizing `fstab` and `vifs`. The `fstab` is designed to ease the burden of mounting and unmounting file systems to a machine. The tools is a set of rules used to control how different filesystems are treated each time they are introduced to a system. It is allows the user to avoid load order errors that could eat up valuable time and energy. While `vifs`, is a utility to safely edit the `etc` / `fstab` file configuration file. It is actually from the fact that we are using the text editor `vi` to change our file.

> **Note**: `vim` and `nano` are two programmes that are quite similar to vifs.

##### Solution:

- Open `Disk Utility` > `Info`.
- Find File System `UUID`
- Select `UUID` and hit `CMD` + `C` to copy the value

![UUID](https://user-images.githubusercontent.com/72515939/202383431-9a3a26d5-a46b-4db6-be97-5f5ef0fe834b.png)

- Open terminal, type `sudo vifs` and hit Enter
- Press `o` to edit `/etc/fstab`.
- Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an example:

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

- Hit `Esc` to stop editing and press `Shift` + `ZZ` (twice) to exit `vifs`.
- Type `sudo automount -vc` to `reset` auto mounter
- Restart PC.

![UUID](https://user-images.githubusercontent.com/72515939/198338330-84c4f1bd-eb19-4709-b6d8-1ed3e88abd7e.png)

> **Note**: Using `vifs` is recommended by Apple. For Linux, storage with "ext4" and "btrfs" unmounts automatically. So, no need to worry about it. This method is not relevant for this format.

---

### Changing other OS label

**Requirement:**

- Disk must in `GPT`
- An operating system with `EFI` partition.

#### Generating disk label

Labeling can be done via macOS by:

- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Find `Utilities` / `disklabel` (unix executable file) inside OpenCore folder
- Run Terminal
- Drag the executable unix file disklabel (not the .exe) into the Terminal and hit Enter. Below is sample command to disk labeling:

```zsh
-e "Arch" .disk_label .disk_label_2x
```

- Hit `Enter`

> **Note**: The disk label file will be in the `home` folder, but it is hidden.

##### Moving the files to the correct location

- Use Finder, got to your Home Folder.
- Press "`cmd` + `shift` + `>`" to display hidden files. The process before should dumped copy of `.disk_label` and `.disk_label_x2`.
- Windows :
  - Move the `.disk_label` and `.disk_label_x2` label files into the `Microsoft` / `Boot` folder, the same path where `bootx64.efi` located.
- Linux :
  - Move the `.disk_label` and `.disk_label_x2` label files into the `EFI` / `boot`, which is the same path where `bootx64.efi` located.
- Press "`cmd` + `shift` + `>`" again to mask the hidden files. Now, adjust `PickerAttributes` on your config.plist.

![Settings](https://user-images.githubusercontent.com/72515939/205451151-2ab41327-dc53-489d-a2f0-0578331d2f77.png)

##### Adjusting PickerAttributes

- Open your [config.plist](https://dortania.github.io/OpenCore-Install-Guide/config.plist/) using [OCAT](https://github.com/ic005k/OCAuxiliaryTools)
- Go to Misc/PickerAttributes and click on Select (or just add 2 to the current value), Check `OC_ATTR_USE_DISK_LABEL_FILE`.
- Save and Reboot.

---

### UTC

Solution to fix clock for macOS and Windows

#### Introduction

If you work across time zones, it's important to understand UTC. UTC is the standard of time used all around the world to

- regulate clocks and...
- effectively the "center" of our timekeeping.

##### Solution

- Open [Hackintool](https://github.com/headkaze/Hackintool) and go to Utilities.

![Utilities](https://user-images.githubusercontent.com/72515939/202380813-0753ac51-31ae-4ece-9b69-5830b13e3416.png)

- Click on below-center to generate** .reg** key to be used on Windows.

![Utilities2](https://user-images.githubusercontent.com/72515939/202380902-3d2eb0c4-ed45-4154-9afd-4422febe224c.png)

- Registry key will be exported as:

  - [WinUTCOn.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOn.reg) - Install
  - [WinUTCOff.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOff.reg) - Uninstall

- Boot to Windows.
- Use `WinUTCOn.reg` to install and use `WinUTCOn.reg` to uninstall registry patches.
- Reboot to macOS and Windows to make sure the clock is properly sync via UTC.

---

### Acknowledgement

- [**Acidanthera**](https://github.com/acidanthera) for

```zsh
git clone https://github.com/acidanthera/OpenCorePkg.git
```

- [**Dortania**](https://dortania.github.io/OpenCore-Install-Guide/) for

```zsh
git clone https://github.com/dortania/OpenCore-Install-Guide.git
```

- [**benbaker76**](https://github.com/benbaker76) for

```zsh
https://github.com/benbaker76/Hackintool.git
```
