# Multiboot Tips

Multiboot Post Install for Hackintosh

## Automatically unmount Windows Partition and Volume on Mac

### Recommended Method:

1. Open **Disk Utility**/**Info**
2. Find **File System UUID** and copy target value.

   <img width="1100" alt="2022-10-11_04-53-09" src="https://user-images.githubusercontent.com/72515939/194950823-9918e211-aad4-49bc-a964-298efd20eb07.png">
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

Some people who **dual-boot** Hackintosh Macs with Linux may experience issues with the **EFI labels** being **unidentified** using **OpenCanopy.efi**. That would be, **NO NAME**.  It is annoying. The solution that will be put out is not the solution I suggest. However, it is useful when all else fails. I, recommend to use the **official method** first:

-  [Dualbooting with Linux](https://dortania.github.io/OpenCore-Multiboot/oc/linux.html)

### Method:

1. Boot on **Linux**
2. Check Linux **EFI partition** path. i.e; **/dev/sdaX**
3. Open **Terminal** and use `fatlabel`, `device path` and `new_label`. 

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
