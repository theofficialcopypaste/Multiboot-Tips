# Multiboot Tips

Multiboot Post Install for Hackintosh

## Automatically unmount Windows Partition and Volume on Mac

### Introduction:

<div align="justify">This method <strong>prevents</strong> the <strong>Windows partition</strong> from<strong> mounting automatically</strong> on the <strong>Mac</strong>. It is <strong>advised</strong> to decrease power consumption. The fact that the <strong>NTFS</strong> partition is mounted <strong>automatically</strong> by an unsupport operating system will results <strong>storage corruption</strong> and probably could <strong>reduce</strong> storage&#39;s <strong>lifespan</strong>. Normally, Linux partition such as ext4, btrfs, zfs and etc is not mounted automatically. Recommended to use <strong>vifs</strong> tin order to editing fstab.</div>

### What is vifs?

*  Name: vifs 
*  Purpose: safely edit fstab
*  Description:
Originates from Mac OSX 10.5. The vifs utility simply locks the fstab file before invoking an editor on it.  This is important to facilitate the modification of fstab by automated tools and system management software. Always use vifs to edit fstab, instead of invoking an editor directly.

### Recommended Method:

1. Open **Disk Utility** \ **Info**
2. Find **File System UUID** and copy target value.

   <img width="1100" alt="2022-10-11_15-21-37" src="https://user-images.githubusercontent.com/72515939/195022152-7a28b29f-8433-4f2b-b3ba-65a1b487cb3a.png">

   <img width="669" alt="2022-10-11_04-51-31" src="https://user-images.githubusercontent.com/72515939/194950887-fb8b0de2-eec9-4872-9223-a49d55d96e1e.png">

3. Type `sudo vifs` on mac terminal
4. Press **o** to edit **/etc/fstab**
5. Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an **example**:

   <img width="585" alt="2022-10-11_04-37-31" src="https://user-images.githubusercontent.com/72515939/194951551-cf586ede-7bea-424d-8d4c-bea7ba118267.png">

6. Press **Esc** to stop editing and press **Shift + ZZ** to exit **vifs**
7. Type `sudo automount -vc` to **reset** auto mounter
8. Restart PC.

---

## NO_NAME issues on Linux 

### Introduction:

   <img width="447" alt="Screen Shot 2022-10-11 at 4 21 53 PM" src="https://user-images.githubusercontent.com/72515939/195038554-cf87909a-28cd-43a5-9bfb-4664b6ad92a5.png">

<div align="justify">Certain <strong>dual-boot</strong> Hackintosh Macs with Linux users may experience issues with the <strong>EFI labels</strong> being <strong>unidentified</strong> using <strong>OpenCanopy.efi</strong>. That would be, <strong>NO NAME</strong>.  It is annoying. The solution guided is not the best way. However, it is useful when all else labeling method fails. Recommended to use the <strong>official method</strong> first:</div>
<br>

-  [Dualbooting with Linux](https://dortania.github.io/OpenCore-Multiboot/oc/linux.html)

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
