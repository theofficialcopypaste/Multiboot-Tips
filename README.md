# Multiboot Tips
## Unmount Non-Supported Storage
### Introduction

<div align="justify">The NTFS partition will become corrupted due to the automatic mounting by an unsupported operating system, which will also probably shorten the storage lifespan. Typically, especially on macOS, Linux partitions like "ext4", "btrfs," "zfs," and others are not mounted automatically. This has been performed to avoid an issue that might occur if another operating system took over and tampered with the disc write permissions. 

When Linux boots up with HFS+ or APFS, the same idea probably applies because macOS somehow doesn't recognise this format. NTFS, however, is different. On macOS, this format mounts automatically. This approach stops the Mac's automatic mounting the Windows NTFS. It is advisable to reduce power requirements and prevent storage corruption. This is essential to utilise vifs when editing the fstab file.</div>

### Supported and Unsupported System Format
| **Detail**  | **Type**                                                                                                                                                                                                                                                                          |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Supported   | APFS, APFS (Encrypted), APFS (Case-sensitive), APFS (Case-sensitive, Encrypted), Mac OS Extended (Journaled), Mac OS Extended (Journaled, Encrypted), Mac OS Extended (Case-sensitive, Journaled), Mac OS Extended (Case-sensitive, Journaled, Encrypted), MS-DOS (FAT) and ExFAT |
| Unsupported | Ext, Ext2, Ext3, Ext4, JFS, ReiserFS, XFS, btrfs, swap, ReFS and NTFS                                                                                                                                                                                                             |

### What is fstab

<div align="justify">The "fstab", is a configuration table designed to ease the burden of mounting and unmounting file systems to a machine. It is a set of rules used to control how different filesystems are treated each time they are introduced to a system. Consider USB drives, for example. Today, we are so used to the plug and play nature of our favorite external drives that we may completely forget that operations are going on behind the scenes to mount the drive and read/write data.

In the time of the ancients, users had to manually mount these drives to a file location using the mount command. The fstab file became an attractive option because of challenges like this. It is designed to configure a rule where specific file systems are detected, then automatically mounted in the user's desired order every time the system boots. Not only is it less work over time, but it also allows the user to avoid load order errors that could eat up valuable time and energy.</div>

### Why vifs?

The command "vifs" is a utility to safely edit the "/etc/fstab" file—the configuration file we are going to tell to not mount our partition. The "vi" part is actually from the fact that we are using the text editor "vi" to change our file.

### Recommended Method:

- Open **Disk Utility** &rarr; **Info**
- Find **File System UUID** and **copy UUID value**


<img width="680" alt="2022-10-11_15-21-37" src="https://user-images.githubusercontent.com/72515939/195022152-7a28b29f-8433-4f2b-b3ba-65a1b487cb3a.png">

<img width="680" alt="2022-10-11_04-51-31" src="https://user-images.githubusercontent.com/72515939/194950887-fb8b0de2-eec9-4872-9223-a49d55d96e1e.png">

- Type `sudo vifs` on mac terminal
- Press `o` to edit /etc/fstab
- Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an **example**:

```zsh
#
# Warning - this file should only be modified with vifs(8)
#
# Failure to do so is unsupported and may be destructive.
#

UUID=12A4B6C8-1A3B-1C3D-6E8F-123456789876 none hfs rw,noauto # Apple HFS+
UUID=7E55582C-6D91-4148-28C6-208D03071164 none ntfs rw,noauto # Windows NTFS
UUID=CF294178-3B0D-4B23-AC72-24D10AAC6735 none ext4 rw,noauto # Linux EXT4
```

6. Press **Esc** to stop editing and press **Shift + ZZ** to exit **vifs**
7. Type `sudo automount -vc` to **reset** auto mounter
8. Restart PC.

---

## NO_NAME issues on Linux 

<div align="justify">Certain <strong>dual-boot</strong> Hackintosh Macs with Linux users may experience issues with the <strong>EFI labels</strong> being <strong>unidentified</strong> using <strong>OpenCanopy.efi</strong>. That would be, <strong>NO_NAME</strong>.  It is annoying. The solution guided is not the best way. However, it is useful when all else labeling method fails. Try official method first. Head to:</div> 
<br>

[OpenCore Multiboot](https://dortania.github.io/OpenCore-Multiboot/oc/linux.html)

### Method:

- Boot to Linux
- Check Linux EFI partition path. i.e; /dev/sdaX (visually using GParted)
- Open Terminal and use `sudo`, `fatlabel`, `device path` and `new_label`.

Example:
```zsh
sudo fatlabel /dev/sda1 Arch
```
- Press Enter, close Terminal and **Restart**

> Note: Do not use this method on **Windows**.

---

## Fix Clock on both OS (Mac and Windows)


### Why does this happen? 

<div align="justify">The simple explanation is; Windows uses Greenwhich time, and OSX uses Universal Time. It's as simple as that. Every time the other OS boots up - it changes around your BIOS settings in-order to 'correct' the CPU clock timer - which is essential for any computer to calculate things correctly. </div>

### What's the difference?  

##### GMT

<div align="justify">Windows is always defaulted to use GMT as the location to set the time and date. GMT stands for 'Greenwich Observatory'. This observatory broadcasts the current time of the world based on the calculations of where the Earth rotation is in relation to the prime meridian. Because of the fact that GMT is outdated - it doesn't consider other factors that are important to calculating time - such as; where the earth is in relation to the sun. Because of this - GMT is pretty much an 'average' or an estimated guess as to what time it is where you live.</div>


##### UTC
  
<div align="justify">As more sophisticated time pieces became available to scientists, the need for a new international time standard became apparent. Atomic clocks did not need to keep time based on average solar time at a particular location because they were very, very accurate. In addition, it became understood that due to the irregularity of the earth and the sun's movements, the exact time needed to be modified occasionally through the use of leap seconds. With this precise accuracy of time, UTC was born.  UTC, while based on zero degrees longitude, which passes through the Greenwich.

Observatory, is based on _atomic time_and includes leap seconds as they are added to our clock every so often. UTC was used beginning in the mid-twentieth century but became the official standard of world time on January 1, 1972. UTC is 24-hour time, which begins at 0:00 at midnight. 12:00 is noon, 13:00 is 1 p.m., 14:00 is 2 p.m. and so on until 23:59, which is 11:59 p.m. Time zones today are a certain number of hours or hours and minutes behind or ahead of UTC. UTC is also known as Zulu time in the airforce. When European Summer Time is not in effect, UTC matches the time zone of the United Kingdom. Today, it is most appropriate to use and refer to time based on UTC and not on GMT.</div>

### How do I fix this?

#### [Hackintool](https://github.com/headkaze/Hackintool)

- Boot to **macOS**
- Open [**Hackintool**](https://github.com/headkaze/Hackintool), &rarr; **Utilities**

<img width="1000" alt="2022-10-11_04-37-31" src="https://user-images.githubusercontent.com/72515939/195476048-4f47ea41-da62-4b4b-97fd-68d5bba38b15.png">

- Click on **Below-Center** icon to generate ".reg" file, called **WinUTCOff.reg** and **WinUTCOn.reg**
	- [**WinUTCOff.reg**](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOff.reg) is to **disable** UTC registry patch
	- [**WinUTCOn.reg**](https://github.com/theofficialcopypaste/Multiboot-Tips/blob/main/WinUTCOn.reg) is to **enable** UTC registry patch

<img width="1125" alt="2022-10-13_09-03-23" src="https://user-images.githubusercontent.com/72515939/195476891-bd985cdb-3565-49c8-9fc8-ec53c1305c50.png">

<img width="1125" alt="2022-10-13 15_25_55-UTC" src="https://user-images.githubusercontent.com/72515939/195530554-455d58cd-8efd-4eed-8306-2af0eaac23f3.png">

- Boot to **Windows**.
- **Merge** or double click **WinUTCOn.reg** to install and enable registry. Set back your exact time **online**.
- **Reboot**.
