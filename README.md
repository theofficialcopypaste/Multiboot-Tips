# Hackintosh Multiboot Tips

**Lists**

- [Multiboot USB Procedure](https://github.com/theofficialcopypaste/Multiboot-Tips#multiboot-usb-procedure)
- [Prevent ACPI infusion on other operating systems](https://github.com/theofficialcopypaste/Multiboot-Tips#prevent-acpi-infusion-on-other-operating-systems)
- [Unmount non-supported storage formats automatically](https://github.com/theofficialcopypaste/Multiboot-Tips#unmount-non-supported-storage-formats-automatically)
- [Changing other OS label](https://github.com/theofficialcopypaste/Multiboot-Tips#changing-other-os-label)
- [UTC](https://github.com/theofficialcopypaste/Multiboot-Tips#utc)

---

### Multiboot USB Procedure

![Screenshot_20221206_205233](https://user-images.githubusercontent.com/72515939/205917851-459df871-e66b-4fec-ae92-07f1bc2a5bba.png)

This guide is not applicable to **Bootcamp**. Separate disk is encourage.

#### Installation

* One thing needs to be kept in mind when doing a multiboot installation of an operating system:
  * Which OS first to install?
  * What is current OS you have?
  
* The following is the operating system sequence for the multiboot process.
  * **First**: Windows 
  * **Second**: Linux/macOS or both

* Why not macOS/Linux first? Windows GPT format installation is different from other operating systems. There are several reasons why the Windows installation starts first before other operating systems. The reason is:
  * Windows will share the EFI with other operating systems and cause an error if one of systems breaks.
  * Overwriting other operating system structure.
  * And of course, **BSOD**.
  
    ![Screenshot_20221206_202258](https://user-images.githubusercontent.com/72515939/205911607-0d9b12c9-d47a-4176-90bb-6a52971a9b41.png)

#### Multiboot USB creation.

* There are several tools that are suitable for multiboot purposes.
  * [YUMI](https://www.pendrivelinux.com/yumi-multiboot-usb-creator/) is a suitable tool. However, using this tools require a lot of work. Hence, YUMI only support windows as platform.
  * [Ventoy](https://www.ventoy.net/) is a free and open-source utility used for writing image files such as `.iso`, `.wim`, `.img`, `.vhd(x)`, and `.efi` files onto storage media to create bootable USB flash drives. Once Ventoy is installed onto a USB drive, there is no need to reformat the disk to update it with new installation files; it is enough to copy the `.iso`, `.wim`, `.img`, `.img(x)`, or `.efi` files to the USB drive and boot from them directly. Ventoy will present the user with a boot menu to select one of these files. The great things is, this tools support Windows and Linux platform.

* Method 1: Ventoy (Windows)

  * First, install Ventoy USB as GPT format.
  * Spare at least 1.5GB space for other purpose. In this case, we spare the space for OpenCore purpose.
  * After ventoy installation, format 1.5GB spare space using [DiskGenius](www.diskgenius.com) as ESP partition format. Usually this will format the space as fat32. Rename partition as `Install`. Marked partition as `boot` & `ESP`.
  * Just move other operating system `.iso`, `.img`, `.vhd` or etc to the drive named Ventoy.
  * Create OpenCore fat32 `.iso` or `.img` (+R/W support), rename as `OpenCore` which contain OpenCore `EFI` and move the image to Ventoy. 
  * Move `com.apple.recovery.boot` ([macOS online Recovery](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/winblows-install.html#making-the-installer-in-windows)) to extra 1.5GB partition
  
    ![Capture](https://user-images.githubusercontent.com/72515939/206798635-6758fdc7-3988-4dd4-bdf3-d193d5648be1.PNG)

* Method 2: Ventoy (Linux)

  * Same procedure as above, install Ventoy to USB as GPT format. Extract and hook Ventoy folder in terminal ie: `cd /home/copypaste/Desktop/ventoy-1.0.84` then, `sudo sh ./Ventoy2Disk.sh -i -r 1500MB -g /dev/sdx`. `x` is your usb path. You may run/execute `VentoyGUI.x86_64` for Graphic user interface session.
  * Spare at least 1.5GB space for other purpose. In this case, we spare the space for OpenCore purpose.
  * Create extra EFI patition using [gparted](https://gparted.org/). Usually this will format the space as fat32. Rename partition as `Install`. Manage flags as `boot` & `esp`.
  
    ![Screenshot_20221206_201057](https://user-images.githubusercontent.com/72515939/205910901-6456de42-b739-493d-80ca-a0269c6d4388.png)
  
  * Just move other operating system `.iso`, `.img`, `.vhd` or etc to the drive named Ventoy.
  * Create OpenCore fat32 `.iso` or `.img` (+R/W support), rename as `OpenCore` which contain OpenCore `EFI` and move the image to Ventoy. 
  * Move `com.apple.recovery.boot` ([macOS online Recovery](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/linux-install.html#making-the-installer-in-linux)) to extra 1.5GB partition.
  
* Both method will produce 3 partition:
  * VentoyEFI (Ventoy boot).
  * Ventoy (Operating system `.iso`, `.img`, `.vhd` or etc) - `Windows`/`Linux`/`PE`.
  * Install (OpenCore boot) - `com.apple.recovery.boot`
  
* BIOS option
  * Choose the boot option from the boot screen. There will be two `UEFI` choices available from the `same USB`. You can select [Ventoy](https://www.ventoy.net/) to boot to mosts `.iso`, `.img`, `.vhd` and etc.
  
* Below is an example:

  ![2022-12-10_07-27-16](https://user-images.githubusercontent.com/72515939/206811501-fa5b5e09-f2dd-40a8-8702-95813cfb06e1.png)
  
  > **Note**: Boot Ventoy USB and select OpenCore.iso or OpenCore.img. Wfter OpenCore booting, press `spacebar` to reveal macOS online recovery. In this case ie: `Install` (dmg).

---

### Prevent ACPI Infusion on Other Operating Systems

* The `If _OSI ("Darwin")` is an implementation method to call Darwin kernel used by macOS. Please make sure compiled SSDT's is using `_OSI ("Darwin")` on all patched device. Reason to use this implementation is:

  * to provide the device `on/enable` and `off/disable` (variable) functions for different operating systems
  * to prevent `BSOD` issues when booting into Windows.

    ![With](https://user-images.githubusercontent.com/72515939/202378529-b787b94e-2744-4a81-9bba-3b1ac78d93fa.png)

    > **Note**: Additionally, combining SSDT with `_OSI` implementation + OpenCore quirks via `Kernel` > `Quirks` > `CustomSMBIOSGuid` = `Yes` and `PlatformInfo` > `UpdateSMBIOSMode` = `Custom` is the best approach to multiboot. Refer [SSDT-EXTv2](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/SSDT/SSDT-EXTv2.dsl) as an example for `If _OSI ("Darwin")` implementation.

---

### Unmount non-supported storage formats automatically

* Always mounting non-supported storage may:
  * shorten the storage lifespan.
  * cause read/write error.

* This solution prevents the mac's automatically mounting the NTFS file format by utilizing `fstab` and `vifs`. The `fstab` is designed to ease the burden of mounting and unmounting file systems to a machine. The tools is a set of rules used to control how different filesystems are treated each time they are introduced to a system. It is allows the user to avoid load order errors that could eat up valuable time and energy. While `vifs`, is a utility to safely edit the `etc`/`fstab` file configuration file. It is actually from the fact that we are using the text editor `vi` to change our file.

> **Note**: `vim` and `nano` are two programmes that are quite similar to vifs.

* Solution:

  * Open `Disk Utility` > `Info`.
  * Find File System `UUID`
  * Select `UUID` and hit `CMD` + `C` to copy the value

    ![UUID](https://user-images.githubusercontent.com/72515939/202383431-9a3a26d5-a46b-4db6-be97-5f5ef0fe834b.png)

  * Open terminal, type `sudo vifs` and hit Enter
  * Press `o` to edit `/etc/fstab`.
  * Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an example:
  
    ```zsh
    #
    # Warning - this file should only be modified with vifs(8)
    #
    # Failure to do so is unsupported and may be destructive.
    #
    UUID=5EB38DF0-4018-4876-8983-B48D089C91C7 none ntfs rw,noauto	// ntfs filesystem
    UUID=FF9DBDC4-F77F-3F72-A6C2-26676F39B7CE none hfs rw,noauto	// hfs+ filesystem
    UUID=FF9DBDC4-F77F-3F72-A6C2-26676F39B7CE none apfs rw,noauto	// apfs file system
    UUID=FB039552-CC4B-396C-A33C-345EE2613818 none msdos rw,noauto  // fat32 file system
    ~
    ~
    ~
    ```

  * Hit `Esc` to stop editing and press `Shift` + `ZZ` (twice) to exit `vifs`.
  * Type `sudo automount -vc` to `reset` auto mounter
  * Restart PC.

    ![UUID](https://user-images.githubusercontent.com/72515939/198338330-84c4f1bd-eb19-4709-b6d8-1ed3e88abd7e.png)

    > **Note**: Using `vifs` is recommended by Apple. For Linux, storage with `ext4` and `btrfs` unmounts automatically. So, no need to worry about it. This method is not relevant for this format.

---

### Changing other OS label

* Requirement:

  * Disk must in `GPT`
  * An operating system with `EFI` partition.

#### Generating disk label

* Labeling can be done via macOS by:

  * Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
  * Find `Utilities`/`disklabel` (unix executable file) inside OpenCore folder
  * Run Terminal
  * Drag the executable unix file disklabel (not the .exe) into the Terminal and hit Enter. Below is sample command to disk labeling:

    ```zsh
    -e "Arch" .disk_label .disk_label_2x
    ```

  * Hit `Enter`

  > **Note**: The disk label file will be in the `home` folder, but it is hidden.

* Moving the files to the correct location

  * Use Finder, got to your Home Folder.
  * Press `cmd` + `shift` + `>` to display hidden files. The process before should dumped copy of `.disk_label` and `.disk_label_x2`.
  * Windows :
    * Move the `.disk_label` and `.disk_label_x2` label files into the `Microsoft`/`Boot` folder, the same path where `bootx64.efi` located.
  * Linux :
    * Move the `.disk_label` and `.disk_label_x2` label files into the `EFI`/`boot`, which is the same path where `bootx64.efi` located.
  * Press "`cmd` + `shift` + `>`" again to mask the hidden files. Now, adjust `PickerAttributes` on your config.plist.

    ![Settings](https://user-images.githubusercontent.com/72515939/205451151-2ab41327-dc53-489d-a2f0-0578331d2f77.png)

* Adjusting PickerAttributes

  * Open your [config.plist](https://dortania.github.io/OpenCore-Install-Guide/config.plist/) using [OCAT](https://github.com/ic005k/OCAuxiliaryTools)
  * Go to Misc/PickerAttributes and click on Select (or just add 2 to the current value), Check `OC_ATTR_USE_DISK_LABEL_FILE`.
  * Save and Reboot.

---

### UTC

* Solution to fix clock for macOS and Windows

#### Introduction

* If you work across time zones, it's important to understand UTC. UTC is the standard of time used all around the world to

  * regulate clocks and...
  * effectively the "center" of our timekeeping.

##### Solution

* Open [Hackintool](https://github.com/headkaze/Hackintool) and go to Utilities.

  ![Utilities](https://user-images.githubusercontent.com/72515939/202380813-0753ac51-31ae-4ece-9b69-5830b13e3416.png)

* Click on below-center to generate** .reg** key to be used on Windows.

  ![Utilities2](https://user-images.githubusercontent.com/72515939/202380902-3d2eb0c4-ed45-4154-9afd-4422febe224c.png)

* Registry key will be exported as:

  * [WinUTCOn.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOn.reg) - Install
  * [WinUTCOff.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOff.reg) - Uninstall

* Boot to Windows.

  * Use `WinUTCOn.reg` to install and use `WinUTCOn.reg` to uninstall registry patches.
  * Reboot to macOS and Windows to make sure the clock is properly sync via UTC.

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
