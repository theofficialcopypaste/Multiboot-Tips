# Hackintosh Tips

## Post Install (Optional)

### Unmount Unsupported Storage

<div align="justify">The NTFS partition will become corrupted due to the automatic mounting by an unsupported operating system, which will also probably shorten the storage lifespan. Especially on Apple MacOS, Linux partitions like ext4, btrfs, zfs and others are not mounted automatically. This has been performed to avoid an issue that might occur if other operating system took over and tampered with the disc write permissions. When Linux boots up with HFS+ or APFS, the same idea probably applies due to Apple Mac's somehow doesn't recognise this format. NTFS is different. This format mounts automatically to Apple Mac's. Here, this method is an approach to stops the Mac's mount automatically the NTFS. This is essential to use <code>vifs</code> when editing the <strong>fstab</strong>.</div>

#### Supported and Unsupported System Format

| **Detail**      | **Type**                                                                                                                                                                                                                                                                          |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Supported**   | APFS, APFS (Encrypted), APFS (Case-sensitive), APFS (Case-sensitive, Encrypted), Mac OS Extended (Journaled), Mac OS Extended (Journaled, Encrypted), Mac OS Extended (Case-sensitive, Journaled), Mac OS Extended (Case-sensitive, Journaled, Encrypted), MS-DOS (FAT) and ExFAT |
| **Unsupported** | Ext, Ext2, Ext3, Ext4, JFS, ReiserFS, XFS, btrfs, swap, ReFS and NTFS                                                                                                                                                                                                             |

#### What is fstab

<div align="justify">The fstab, is a configuration table designed to ease the burden of mounting and unmounting file systems to a machine. It is a set of rules used to control how different filesystems are treated each time they are introduced to a system. Consider USB drives, for example. Today, we are so used to the plug and play nature of our favorite external drives that we may completely forget that operations are going on behind the scenes to mount the drive and read/write data. In the time of the ancients, users had to manually mount these drives to a file location using the mount command. The fstab file became an attractive option because of challenges like this. It is designed to configure a rule where specific file systems are detected, then automatically mounted in the user's desired order every time the system boots. Not only is it less work over time, but it also allows the user to avoid load order errors that could eat up valuable time and energy.</div>

#### Why vifs?

The command `vifs` is a utility to safely edit the **/etc/fstab** file—the configuration file we are going to tell to not mount our partition. The `vi` part is actually from the fact that we are using the text editor `vi` to change our file.

> **Note:** Apple recommend `vifs` over `vim/other capable` editing apps to prevent an issue

#### Recommended Method:

- Open `Disk Utility` &rarr; `Info`
- Find `File System UUID` and `copy UUID value`

<div align=center>

<img width="700" alt="2022-10-11_04-51-31" src="https://user-images.githubusercontent.com/72515939/194950887-fb8b0de2-eec9-4872-9223-a49d55d96e1e.png">

</div>

- Type `sudo vifs` on mac terminal
- Press `o` to edit /etc/fstab
- Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an `example`:

<div align=center>

<img width="641" alt="2022-10-27_23-33-36" src="https://user-images.githubusercontent.com/72515939/198335620-097866d1-9780-4dfb-8e73-d1e5d129ce1f.png">

</div>

- Hit `Esc` to stop editing and press `Shift + ZZ` (double capital Z) to exit `vifs`
- Type `sudo automount -vc` to `reset` auto mounter
- Restart PC.

---

## Changing Windows Disk Label in BootPicker

### Generating disk label files

- Download the latest [OpenCore Package](https://github.com/acidanthera/OpenCorePkg/releases) and unzip it
- Find `/Utilities/disklabel` inside OpenCore folder
- Run Terminal
- Drag the executable unix file disklabel (not the .exe) into the Terminal and hit **Enter**. Below is sample command to disk labeling:

	```zsh
	-e "nameofyourdisk" .disk_label .disk_label_2x
	```
- The complete line should look like below:

	```zsh
	-e "Winslow" .disk_label .disk_label_2x
	```
- Hit enter

The disk label files will be stored in your home folder but they are hidden

### Moving the files to the correct location

- In Finder, got to your Home Folder
- Press `Cmd+Shift+.` to display hidden files. The process before should dumped copy of `.disk_label` and `.disk_label_x2`
- As example, Windows EFI partition. Mount the EFI containing the "Microsoft" Folder
- Paste/Move the `.disk_label` and `.disk_label_x2` label files into the **Microsoft/Boot** folder. 
- Press `Cmd+Shift+.` again to mask the hidden files. Now, adjust `PickerAttributes` 

### Adjusting PickerAttributes

- Open your [config.plist](https://dortania.github.io/OpenCore-Install-Guide/config.plist/) using [OCAT](https://github.com/ic005k/OCAuxiliaryTools)
- Go to **Misc/PickerAttributes** and click on **Select** (or just add 2 to the current value), Check `OC_ATTR_USE_DISK_LABEL_FILE`
- Save and **Reboot**

> Credits to [5T33Z0](https://github.com/5T33Z0), for writing this to us

---

## Fix Clock on both OS (Mac and Windows)

### How do I fix this?

#### Hackintool
- Boot to **macOS**
- Open [Hackintool](https://github.com/headkaze/Hackintool), &rarr; **Utilities**

<div align=center>

<img width="1000" alt="2022-10-11_04-37-31" src="https://user-images.githubusercontent.com/72515939/195476048-4f47ea41-da62-4b4b-97fd-68d5bba38b15.png">

</div>

- Click on **Below-Center** icon to generate ".reg" file, called **WinUTCOff.reg** and **WinUTCOn.reg**
  - [WinUTCOff.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOff.reg) is to **disable** UTC registry patch
  - [WinUTCOn.reg](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOn.reg) is to **enable** UTC registry patch

<div align=center>

<img width="1125" alt="2022-10-13_09-03-23" src="https://user-images.githubusercontent.com/72515939/195476891-bd985cdb-3565-49c8-9fc8-ec53c1305c50.png">

<img width="1125" alt="2022-10-13 15_25_55-UTC" src="https://user-images.githubusercontent.com/72515939/195530554-455d58cd-8efd-4eed-8306-2af0eaac23f3.png">

</div>

- Boot to Windows.
- **Merge** or double click **WinUTCOn.reg** to install and enable registry. Set back your exact time online.
- **Reboot** to macOS and Windows to make sure the clock is properly sync via **UTC**.
