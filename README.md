# Multiboot Tips & Tricks

Multiboot Post Install for Hackintosh

## Auto unmount Windows volume on Mac

### Recommended Method:

1. Open **Disk Utility**/**Info**
2. Find **File System UUID** and copy target value.

   <img width="1100" alt="2022-10-11_04-53-09" src="https://user-images.githubusercontent.com/72515939/194950823-9918e211-aad4-49bc-a964-298efd20eb07.png">
   <img width="669" alt="2022-10-11_04-51-31" src="https://user-images.githubusercontent.com/72515939/194950887-fb8b0de2-eec9-4872-9223-a49d55d96e1e.png">

3. Type `sudo vifs` on mac terminal
4. Press **o** to edit **/etc/fstab**
5. Add `UUID="Volume UUID" none ntfs rw,noauto`. Below is an example:

   <img width="585" alt="2022-10-11_04-37-31" src="https://user-images.githubusercontent.com/72515939/194951551-cf586ede-7bea-424d-8d4c-bea7ba118267.png">

6. Press **Esc** to stop editing and press **Shift + ZZ** to exit **vifs**
7. Type `sudo automount -vc` to **reset** auto mounter
8. Restart PC.
