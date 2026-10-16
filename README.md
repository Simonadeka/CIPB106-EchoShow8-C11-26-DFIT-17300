# CIPB106 - Echo Show 8 (C11) Forensic Analysis - 26-DFIT-17300

**Case:** C11-26-DFIT-17300 | **Device:** Amazon Echo Show 8 (2nd Gen) | **Analyst:** CIPB106

## 1. Evidence Integrity - 8x MD5 Hashes (Critical)

| # | Artifact | Partition | Path |
|---|----------|-----------|------|
| 1 | build.prop | p21 | system/build.prop |
| 2 | WifiConfigStore.xml | p23 | misc/wifi/WifiConfigStore.xml |
| 3 | Original Image | - | C11-EchoShow8-26-DFIT-17300.img |
| 4 | wifilocker XML | p23 | data/com.amazon.wifilocker/shared_prefs/ |
| 5 | Alexa Datastore | p23 | data/com.amazon.alexa.datastore.app/databases/ |
| 6 | MapDataStorage | p23 | data/com.amazon.alexa.datastore.app/ |
| 7 | accounts.db | p23 | data/system/users/0/accounts.db |
| 8 | InternalStorage | p23 | data/media/0/ |

**Last Sync Timestamp:** 2023-10-23 23:19:52 UTC (Alexa Datastore)
**Hashes stored in:** 02-Analysis/Hashes/hashes.txt and 01_original_hash.txt

## 2. Acquisition Method

losetup -P -r -f C11-EchoShow8-26-DFIT-17300.img
mount -o ro /dev/loop0p21 /mnt/echo_system
mount -o ro /dev/loop0p23 /mnt/echo_userdata
md5sum /mnt/echo_system/system/build.prop
md5sum /mnt/echo_userdata/misc/wifi/WifiConfigStore.xml

## 3. Key Findings

- FireOS Version: From build.prop (ro.build.version)
- WiFi: 2 networks in WifiConfigStore.xml + wifilocker
- User Data: data/media/0/
- Alexa: com.amazon.alexa.datastore.app
- Account: Amazon account in accounts.db

## 4. Repository Structure

01-Evidence/System/build.prop
01-Evidence/Userdata/WiFi/WifiConfigStore.xml
01-Evidence/Userdata/Alexa/*.db
02-Analysis/Hashes/hashes.txt
03-Report/Screenshots/
03-Report/Final/

## 5. Tools

Kali Linux, losetup, mount, fdisk, md5sum, sqlite3, strings, Autopsy

## 6. Chain of Custody

Image mounted read-only. Original hash in 01_original_hash.txt. All extraction logged.
