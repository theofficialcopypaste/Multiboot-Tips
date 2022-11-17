# Hackintosh Multiboot Tips

## Prevent ACPI issues on Multiboot (Windows + macOS)

Several steps must be taken to prevent modded ACPI from being injected into other operating systems:

| Bootloader        | Method                                                                     |
| ----------------- | -------------------------------------------------------------------------- |
| Clover            | Fix Darwin Option                                                          |
| Official OpenCore | If \_OSI ("Darwin") via ACPI, CustomSMBIOSGuid and UpdateSMBIOSMode Quirks |
| OpenCore Mod      | EnableforAll Quirks                                                        |

### Clover

#### Method: Fix Darwin

Open [Clover Configurator](https://mackie100projects.altervista.org/download-clover-configurator/) and look and mark for the **Fix Darwin** option in ACPI Section, which is equivalent to the `If OSI ("Darwin")` argument and save `config.plist`.

<div align=center>

![FixDarwin](https://user-images.githubusercontent.com/72515939/202373593-df4abcda-3d38-4548-a9ae-e5403a26b7db.png)

</div>

If you are not using [Clover Configurator](https://mackie100projects.altervista.org/download-clover-configurator/), you can use any plist editor to open the config.plist. Find:

`ACPI / DSDT / Fixes / FixDarwin = YES`.

<div align=center>

![FixD](https://user-images.githubusercontent.com/72515939/202375889-3fb50eea-8d79-496c-91ff-8ff1db673a25.png)

</div>

### Official OpenCore

#### Method: Enable If \_OSI ("Darwin")

To enable If \_OSI ("Darwin"), modded SSDTs need to be added with this argument to the entire patch. This is to prevent both operating systems from injecting modified `.aml` scripts. This is because macOS requirements are sometimes different from those of other operating systems. Below is an example:

<div align=center>

![Without](https://user-images.githubusercontent.com/72515939/202378334-31785783-1eeb-4bc1-82e8-03ccb90e4a6c.png)
![With](https://user-images.githubusercontent.com/72515939/202378529-b787b94e-2744-4a81-9bba-3b1ac78d93fa.png)

</div>

> **Note**: This require `Kernel` / `Quirks` / `CustomSMBIOSGuid` = `Yes` and `PlatformInfo` / `UpdateSMBIOSMode` = `Custom` via config.plist. Checkout my [SSDT-EXT_info](https://github.com/theofficialcopypaste/ASRockB460MSL-OC/blob/main/SSDT-EXT/SSDT-EXT_info.dsl) for an explanation.

### OpenCore Mod

#### Method: EnableforAll

If the EnableforAll quirks function is injected via config.plist, OpenCore Mod does not inject ACPI on other operating systems. Using SSDTs in the absence of OSI ("Darwin") is sufficient.

<div align=center>

![Without](https://user-images.githubusercontent.com/72515939/202378334-31785783-1eeb-4bc1-82e8-03ccb90e4a6c.png)

</div>

> **Note**: This require `ACPI` / `Quirks` / `EnableforAll` = `Yes` and `Booter` / `Quirks` / `EnableforAll` = `Yes` via config.plist. So, you may set `Kernel` / `Quirks` / `CustomSMBIOSGuid` = `No` and `PlatformInfo` / `UpdateSMBIOSMode` = `Create` via config.plist. Checkout my [SSDT-EXTNOACPI](https://github.com/theofficialcopypaste/ASRockB460MSL-OC/blob/main/SSDT-EXT/SSDT-EXTNOACPI.dsl) as an example.

<br>

---

## Unmount Unsupported Storage

<div align=justify>The NTFS partition will become corrupted due to the automatic mounting by an unsupported operating system, which will also probably shorten the storage lifespan. Especially on Apple MacOS, Linux partitions like ext4, btrfs, zfs and others are not mounted automatically. This has been performed to avoid an issue that might occur if other operating system took over and tampered with the disc write permissions. When Linux boots up with HFS+ or APFS, the same idea probably applies due to Apple Mac's somehow doesn't recognise this format. NTFS is different. This format mounts automatically to Apple Mac's. Here, this method is an approach to stops the Mac's mount automatically the NTFS. This is essential to use <code>vifs</code> when editing the <strong>fstab</strong>.</div>

### Supported and Unsupported System Format

| **Detail**  | **Type**                                                                                                                                                                                                                                                                          |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Supported   | APFS, APFS (Encrypted), APFS (Case-sensitive), APFS (Case-sensitive, Encrypted), Mac OS Extended (Journaled), Mac OS Extended (Journaled, Encrypted), Mac OS Extended (Case-sensitive, Journaled), Mac OS Extended (Case-sensitive, Journaled, Encrypted), MS-DOS (FAT) and ExFAT |
| Unsupported | Ext, Ext2, Ext3, Ext4, JFS, ReiserFS, XFS, btrfs, swap, ReFS and NTFS                                                                                                                                                                                                             |

#### What is fstab

<div align=justify>The fstab, is a configuration table designed to ease the burden of mounting and unmounting file systems to a machine. It is a set of rules used to control how different filesystems are treated each time they are introduced to a system. Consider USB drives, for example. Today, we are so used to the plug and play nature of our favorite external drives that we may completely forget that operations are going on behind the scenes to mount the drive and read/write data. In the time of the ancients, users had to manually mount these drives to a file location using the mount command. The fstab file became an attractive option because of challenges like this. It is designed to configure a rule where specific file systems are detected, then automatically mounted in the user's desired order every time the system boots. Not only is it less work over time, but it also allows the user to avoid load order errors that could eat up valuable time and energy.</div>

#### Why vifs?

The command `vifs` is a utility to safely edit the /etc/fstab file—the configuration file we are going to tell to not mount our partition. The `vi` part is actually from the fact that we are using the text editor `vi` to change our file.

> **Note**: Apple recommend `vifs` over `vim/other capable` editing apps to prevent an issue

#### Recommended Method:

- Open `Disk Utility` &rarr; `Info`
- Find `File System UUID` and `copy UUID value`

<div align=center>

![UUID](https://user-images.githubusercontent.com/72515939/202383431-9a3a26d5-a46b-4db6-be97-5f5ef0fe834b.png)

</div>

- Type `sudo vifs` on mac terminal
- Press `o` to edit /etc/fstab
- Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an `example`:

```zsh
#
# Warning - this file should only be modified with vifs(8)
#
# Failure to do so is unsupported and may be destructive.
#
UUID=5EB38DF0-4018-4876-8983-B48D089C91C7 none ntfs rw,noauto // Winslows
UUID=FF9DBDC4-F77F-3F72-A6C2-26676F39B7CE none hfs rw,noauto. // macOS HFS+
UUID=FF9DBDC4-F77F-3F72-A6C2-26676F39B7CE none apfs rw,noauto // macOS APFS
~
~
~
~
~
~
~
~
```

- Hit `Esc` to stop editing and press `Shift + ZZ` (double capital Z) to exit `vifs`
- Type `sudo automount -vc` to `reset` auto mounter
- Restart PC.

<div align=center>
	
<img width="1120" alt="2022-10-27_23-49-33" src="https://user-images.githubusercontent.com/72515939/198338330-84c4f1bd-eb19-4709-b6d8-1ed3e88abd7e.png">

</div>

> **Note**: Use at your own risk!

<br>

---

## Changing Windows Disk Label in BootPicker

### Generating disk label files

- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Find `/Utilities/disklabel` inside OpenCore folder
- Run Terminal
- Drag the executable unix file disklabel (not the .exe) into the Terminal and hit Enter. Below is sample command to disk labeling:

  ```zsh
  -e "nameofyourdisk" .disk_label .disk_label_2x
  ```

- The complete line should look like below:

  ```zsh
  -e "Winslow" .disk_label .disk_label_2x
  ```

- Hit enter

The disk label files will be stored in your home folder but they are hidden

#### Moving the files to the correct location

- In Finder, got to your Home Folder
- Press `Cmd+Shift+.` to display hidden files. The process before should dumped copy of `.disk_label` and `.disk_label_x2`
- As example, Windows EFI partition. Mount the EFI containing the "Microsoft" Folder
- Paste/Move the `.disk_label` and `.disk_label_x2` label files into the Microsoft/Boot folder.
- Press `Cmd+Shift+.` again to mask the hidden files. Now, adjust `PickerAttributes`

#### Adjusting PickerAttributes

- Open your [config.plist](https://dortania.github.io/OpenCore-Install-Guide/config.plist/) using [OCAT](https://github.com/ic005k/OCAuxiliaryTools)
- Go to Misc/PickerAttributes and click on Select (or just add 2 to the current value), Check `OC_ATTR_USE_DISK_LABEL_FILE`
- Save and Reboot

> **Note**: Credits to [5T33Z0](https://github.com/5T33Z0), for writing this to us

<br>

---

## Fix Clock on Multiboot (most common, MacOS + Windows)

### How do I fix this?

#### Hackintool

- Boot to macOS
- Open [Hackintool](https://github.com/headkaze/Hackintool), &rarr; Utilities

<div align=center>

![Utilities](https://user-images.githubusercontent.com/72515939/202380813-0753ac51-31ae-4ece-9b69-5830b13e3416.png)

</div>

- Click on Below-Center icon to generate ".reg" file, called WinUTCOff.reg and WinUTCOn.reg
  - [WinUTCOff.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOff.reg) is to disable UTC registry patch
  - [WinUTCOn.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOn.reg) is to enable UTC registry patch

<div align=center>

![Utilities2](https://user-images.githubusercontent.com/72515939/202380902-3d2eb0c4-ed45-4154-9afd-4422febe224c.png)

<img width="1125" alt="2022-10-13 15_25_55-UTC" src="https://user-images.githubusercontent.com/72515939/195530554-455d58cd-8efd-4eed-8306-2af0eaac23f3.png">

</div><br>

- Boot to Windows.
- Merge or double click WinUTCOn.reg to install and enable registry.
- Reboot to macOS and Windows to make sure the clock is properly sync via UTC.

> **Note**: Please set back exact time online via Windows or Mac.

<br>

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

- [**headkaze**](https://github.com/headkaze) for

```zsh
git clone https://github.com/headkaze/Hackintool.git
```
