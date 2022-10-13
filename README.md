# Multiboot Tips

Multiboot Post Install for Hackintosh

## Automatically unmount Windows Partition and Volume on Mac

### Introduction:

<div align="justify">This method <strong>prevents</strong> the <strong>Windows partition</strong> from<strong> mounting automatically</strong> on the <strong>Mac</strong>. It is <strong>advised</strong> to decrease power consumption. The fact that the <strong>NTFS</strong> partition is mounted <strong>automatically</strong> by an unsupport operating system will results <strong>storage corruption</strong> and probably could <strong>reduce</strong> storage&#39;s <strong>lifespan</strong>. Normally, Linux partition such as ext4, btrfs, zfs and etc is not mounted automatically. Recommended to use <strong>vifs</strong> in order to editing fstab.</div>

### What is vifs?

| **Details** | **Description**                                                                                                                                                                                                                                                                                          |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Name**        | vifs                                                                                                                                                                                                                                                                                             |
| **Function**    | Safely edit fstab                                                                                                                                                                                                                                                                                |
| **History**     | Originates from Mac OSX 10.5. The vifs utility simply locks the fstab file before invoking an editor on it.  This is important to facilitate the modification of fstab by automated tools and system management software. Always use **vifs** to edit fstab, instead of invoking an editor directly. |

### Recommended Method:

1. Open **Disk Utility** \ **Info**
2. Find **File System UUID** and copy target value.

   <img width="680" alt="2022-10-11_15-21-37" src="https://user-images.githubusercontent.com/72515939/195022152-7a28b29f-8433-4f2b-b3ba-65a1b487cb3a.png">

   <img width="680" alt="2022-10-11_04-51-31" src="https://user-images.githubusercontent.com/72515939/194950887-fb8b0de2-eec9-4872-9223-a49d55d96e1e.png">

3. Type `sudo vifs` on mac terminal
4. Press **o** to edit **/etc/fstab**
5. Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an **example**:

   <img width="680" alt="2022-10-11_04-37-31" src="https://user-images.githubusercontent.com/72515939/194951551-cf586ede-7bea-424d-8d4c-bea7ba118267.png">

6. Press **Esc** to stop editing and press **Shift + ZZ** to exit **vifs**
7. Type `sudo automount -vc` to **reset** auto mounter
8. Restart PC.

---

## NO_NAME issues on Linux 

### Introduction:

   <img width="500" alt="UTC (1)" src="https://user-images.githubusercontent.com/72515939/195477379-9e45ff8b-76a4-47c3-b229-058faeb2f584.png">

<div align="justify">Certain <strong>dual-boot</strong> Hackintosh Macs with Linux users may experience issues with the <strong>EFI labels</strong> being <strong>unidentified</strong> using <strong>OpenCanopy.efi</strong>. That would be, <strong>NO NAME</strong>.  It is annoying. The solution guided is not the best way. However, it is useful when all else labeling method fails. Recommended to use the <strong>official method</strong> first:</div>

-  [**Dualbooting with Linux**](https://dortania.github.io/OpenCore-Multiboot/oc/linux.html)

### Method:

1. Boot to **Linux**
2. Check Linux **EFI partition** path. i.e; **/dev/sdaX** (visually using GParted)
3. Open **Terminal** and use `sudo`, `fatlabel`, `device path` and `new_label`. 

   Example are as below:
   
   ```zsh
   sudo fatlabel /dev/sdaX new_label
   ```
   
   Complete example:
   
   ```zsh
   sudo fatlabel /dev/sda1 Arch
   ```
4. Press Enter, close Terminal and **Restart**

**Note:** Please do not use this method on **Windows**. 


## Fix Clock on both OS (Mac and Windows)

### Introduction:

#### Why does this happen?**  

<div align="justify">The simple explanation is; Windows uses Greenwhich time, and OSX uses Universal Time. It's as simple as that. Every time the other OS boots up - it changes around your BIOS settings in-order to 'correct' the CPU clock timer - which is essential for any computer to calculate things correctly. </div> 
  
#### What's the difference?  
  
**GMT**  
  
<div align="justify">Windows is always defaulted to use GMT as the location to set the time and date. GMT stands for 'Greenwich Observatory'. This observatory broadcasts the current time of the world based on the calculations of where the Earth rotation is in relation to the prime meridian. Because of the fact that GMT is outdated - it doesn't consider other factors that are important to calculating time - such as; where the earth is in relation to the sun. Because of this - GMT is pretty much an 'average' or an estimated guess as to what time it is where you live.</div>

**UTC**  
  
<div align="justify">As more sophisticated time pieces became available to scientists, the need for a new international time standard became apparent. Atomic clocks did not need to keep time based on average solar time at a particular location because they were very, very accurate. In addition, it became understood that due to the irregularity of the earth and the sun's movements, the exact time needed to be modified occasionally through the use of leap seconds. With this precise accuracy of time, UTC was born.  UTC, while based on zero degrees longitude, which passes through the Greenwich Observatory, is based on _atomic time_and includes leap seconds as they are added to our clock every so often. UTC was used beginning in the mid-twentieth century but became the official standard of world time on January 1, 1972. UTC is 24-hour time, which begins at 0:00 at midnight. 12:00 is noon, 13:00 is 1 p.m., 14:00 is 2 p.m. and so on until 23:59, which is 11:59 p.m. Time zones today are a certain number of hours or hours and minutes behind or ahead of UTC. UTC is also known as Zulu time in the airforce. When European Summer Time is not in effect, UTC matches the time zone of the United Kingdom. </div>  
  
Today, it is most appropriate to use and refer to time based on UTC and not on GMT.

#### How do I fix this?

**Manual Method (credit to [SwampFox82](https://www.tonymacx86.com/members/swampfox82.1100433/))**

<div align="justify">It's quite simple really. All you need to do is set Windows to use UTC instead of GMT. To do this - we need to perform a simple registry edit. Go perform this - hold down the <strong>Windows</strong> button, and at the same time press <strong>R (Win + R)</strong>. This will bring up a new window titled <strong>Run</strong>. In this window type the command <strong>regedit</strong>. <strong>UAC</strong> will popup asking for admin permission. Click accept and the registry editor will open. Now that were in regedit, navigate to:</div>

<br>

```cmd
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
```

<div align="justify">Left click on <strong>TimeZoneInformation</strong> and on the left it will display all the current values attributed to this registry key. On the left right click anywhere and choose <strong>Create new D-WORD</strong>. You will now see a new entry at the bottom of the list.</div>  
  
<div align="justify">Right click on this new entry and choose <strong>Modify</strong> Rename the key <strong>RealTimeIsUniversal</strong> and change it's value to '1'. Click save, and now the entry should say <strong>RealTimeIsUniversal</strong> - <code>0x0000001</code> If it looks like that - then you're all done.</div>    
  
**Reboot**, and sync the windows clock - now your time settings will be universal.

**Auto Method (Require Hackintool)**

1. Boot to **macOS**
2. Open Hackintool, Find **Utilities**

   <img width="1000" alt="2022-10-11_04-37-31" src="https://user-images.githubusercontent.com/72515939/195476048-4f47ea41-da62-4b4b-97fd-68d5bba38b15.png">

3. Click on Below-Center icon to generate `reg` file, called **WinUTCOff.reg** and **WinUTCOn.reg**
	1. **WinUTCOff.reg** is to **disable** UTC registry patch
	2. **WinUTCOn.reg** is to **enable** UTC registry patch
	
   <br>
   <img width="1125" alt="2022-10-13_09-03-23" src="https://user-images.githubusercontent.com/72515939/195476891-bd985cdb-3565-49c8-9fc8-ec53c1305c50.png">
  
   <img width="1000" alt="UTC" src="https://user-images.githubusercontent.com/72515939/195476093-a770f262-73c3-4238-bd94-aa7c5d39db2d.png">

4. Boot to **Windows**.
5. Click and Install **WinUTCOn.reg** to enable registry, Set back your exact time online.
6. **Reboot**. 
