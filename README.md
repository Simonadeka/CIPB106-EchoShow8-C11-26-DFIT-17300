# CIPB106 - Echo Show 8 (C11) Forensic Analysis - 26-DFIT-17300

**Case:** C11-26-DFIT-17300 | **Device:** Amazon Echo Show 8 (2nd Gen) | **Analyst:** CIPB106

## 1. Evidence Integrity - 8x MD5 Hashes (Critical)

| # | Artifact | Path | MD5 Hash | Notes |
|---|----------|------|----------|-------|
| 1 | build.prop | p21 /system/build.prop | `RUN: md5sum /mnt/echo_system/system/build.prop` | FireOS Version |
| 2 | WifiConfigStore.xml | p23 /misc/wifi/ | `RUN: md5sum /mnt/echo_userdata/misc/wifi/WifiConfigStore.xml` | SSID + PSK |
| 3 | Original Image | C11-EchoShow8-26-DFIT-17300.img | See 01_original_hash.txt | Full Disk |
| 4 | wifilocker XML | p23 /data/com.amazon.wifilocker/shared_prefs/ | From extraction | WiFi Locker |
| 5 | Alexa Datastore | p23 /data/com.amazon.alexa.datastore.app/ | From extraction | Voice History |
| 6 | MapDataStorage | p23 /data/com.amazon.alexa.datastore.app/DomainApplication/ | From extraction | Map Data |
| 7 | accounts.db | p23 /data/system/users/0/ | From extraction | Amazon Account |
| 8 | InternalStorage | p23 /data/media/0/ | From extraction | User Files |

**Last Sync Timestamp:** 2023-10-23 23:19:52 UTC (from Alexa Datastore)

## 2. Acquisition Method

```bash
losetup -P -r -f C11-EchoShow8-26-DFIT-17300.img
mount -o ro /dev/loop0p21 /mnt/echo_system
mount -o ro /dev/loop0p23 /mnt/echo_userdata
md5sum /mnt/echo_system/system/build.prop
md5sum /mnt/echo_userdata/misc/wifi/WifiConfigStore.xml
## 3. Key Findings

- *FireOS Version:* Extracted from http://build.prop (ro.build.version)
- *WiFi:* 2 networks in http://WifiConfigStore.xml + wifilocker
- *User Data:* Located in /data/media/0/
- *Alexa:* Databases in http://com.amazon.alexa.datastore.app
- *Account:* Amazon account in http://accounts.db

## 4. Repository Structure

01-Evidence/System/ -> http://build.prop
01-Evidence/Userdata/WiFi/ -> http://WifiConfigStore.xml
01-Evidence/Userdata/Alexa/ -> *.db
02-Analysis/Hashes/ -> http://hashes.txt
03-Report/Screenshots/ -> Fig01-Fig10
03-Report/Final/ -> Executive Report PDF

## 5. Tools

Kali Linux, losetup, mount, fdisk, md5sum, sqlite3, strings, Autopsy

## 6. Chain of Custody

Image mounted read-only (ro). Original hash preserved in 01_original_hash.txt. All extraction logged.

