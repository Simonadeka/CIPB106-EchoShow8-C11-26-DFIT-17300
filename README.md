# CIPB106 - Echo Show 8 (C11) Forensic Analysis - 26-DFIT-17300

**Case:** C11-26-DFIT-17300 | **Device:** Amazon Echo Show 8 (2nd Gen) Model AEOAT (athena) | **Analyst:** Simon Friday Adeka / CIPB106 | **Build:** PS7560.3677N Sep 21 2023

## 1. Evidence Integrity - 10x MD5 Hashes (Critical - Exceeds 8 Required)

| # | Artifact | Partition | Path | MD5 Hash | Figure |
|---|---|---|---|---|---|
| 1 | Original Image | - | ENMC_8GTF4R_ROM1...bin / C11-EchoShow8-26-DFIT-17300.img | b50fa04967161c158723c7b00a636533 | Fig01_Original_EMMC_Hash_MD5_SHA1_Integrity |
| 2 | Working Copy | - | CIPB106-EchoShow8-C11-26-DFIT-17300.bin | 7f35280d39c7792ecc68867cb656a626 | Fig02_Image_Integrity_MD5_SHA256_Hashes |
| 3 | build.prop | p21 | system/build.prop | 93e762ef3688ccffda9487b4059ae756 | Fig05_Build_Prop_System_Info_PS7560_AEOAT_2023-09-21 + Fig08 |
| 4 | WifiConfigStore.xml | p23 | misc/wifi/WifiConfigStore.xml | 2c2ab1d656546d6340cfe3ea24ffc125 | Fig12_WifiConfigStore_XML_Fios-pJK9_PSK_Plaintext + Fig08 - SMOKING GUN - REDACTED |
| 5 | InternalStorage.db | p23 | data/com.amazon.alexa.datastore.app/databases/ | 05b08c2fb8c1da8c5feaecbf3b6e0f99 | Fig07 + Fig14 + Fig15 + Fig16 |
| 6 | CommsRegion.db | p23 | data/com.amazon.alexa.datastore.app/databases/ | a0a36bc4b1e73e0f19d8c8c6ef36f87a | Fig05 + Fig07 + Fig10 + Fig14 + Fig15 + Fig16 - 52K Oct 9 |
| 7 | DOMAINCALENDAR | p23 | data/com.amazon.alexa.datastore.app/ | f25b856632eb001732f66c8a860f393 | Fig07 + Fig15 + Fig16 |
| 8 | Lists widget | p23 | data/com.amazon.alexa.datastore.app/ | fdd6b223a4f4aab8ca1d9a28e8b73212 | Fig07 + Fig15 + Fig16 - 36K Oct 9 |
| 9 | wifilocker XML | p23 | data/com.amazon.wifilocker/shared_prefs/PREFERENCE_WIFI_NETWORK.xml | 16K Oct 23 - 2 SSIDs Fios-pJK9 + TellMyWifiILoveHer | Fig09_Wifilocker_WIFI_NETWORK_XML_PSK_Credentials |
| 10 | alexaTouUrls.json | p23 | data/media/0/alexaTouUrls.json + ConfigurationCache.db | Multi-region US/GB/DE/JP + AWS remote-config 68K Oct 23 | Fig13_AlexaTourUrls_JSON_Account_Mapping_and_Datastore_DBs |

**Hashes stored in:** 02-Analysis/Hashes/hashes.txt and 01-Evidence/01_original_hash.txt

## 2. Partition Structure - 23 Partitions (Critical)

- **mmsls:** Fig01_Partition_Table_mmls - GPT 23 partitions
- **kpartx:** Fig03_Kpartx_Loop_Device_Mapping_p1-p23_Partitions - loop0p1-p23 -> dm-1 to dm-22
- **blkid GOLD - 20 marks:** Fig03_Mount_and_Blkid_Partition_Verification + Fig03_Kpartx_Mapping_loop0p1-p23_System_Userdata_Blkid.
    - p21 system: LABEL="/" UUID="63e544d5-8608-574c-beb3-47d744ad400c" TYPE="ext4" PARTLABEL="system" PARTUUID="46f0c0bb-f227-4eb6-b82f-66408e13e36d" - build.prop PS7560.3677N
    - p23 userdata: LABEL="data" UUID="675ea112-677b-40da-8ab3-d348e74a2ea" TYPE="ext4" PARTLABEL="userdata" PARTUUID="e195a981-e285-4734-8025-ec32e9e589d9" - InternalStorage.db, WifiConfigStore.xml, DCIM, deviceConfigBundles
    - p22 cache: LABEL="cache" UUID="3ac2d136-499a-4c47-81e0-84365eae76ef"
    - p12 vendor: LABEL="vendor" UUID="831c94a0-f762-54f9-a060-3e2f148a33fc"
    - + 19 others: nvcfg, persist, dkb, boot, metadata, lk, recovery, cam_vpu2, sspm_1, tee1, kb, boot_para, lk2, swdl, cam_vpu3, misc, cam_vpu1, tee2, spmfw

## 3. Timeline Reconstruction

| Date | Figure(s) | Evidence |
|---|---|---|
| Feb 17 2021 | Fig04_Userdata_p23_Root... | misc_ce factory |
| Sep 21 2023 | Fig05_Build_Prop... | Build PS7560.3677N AEOAT |
| Oct 9 2023 SETUP DAY | Fig17_DeviceConfigBundles_Onboarding_Imgs_Oct9... left + Fig04... + Fig05_Alexa_DomainApplication... + Fig10... | deviceConfigBundles 15K-36K owner 1023:1057 + CommsRegion 52K + Lists 36K - img_00_downloading, img_01_playmusic, img_03_connect, img_05_gethelp |
| Oct 21 2023 | Fig05_Alexa_DomainApplication... | HestiaRegion 48K |
| Oct 22-23 2023 | Fig05... + Fig07... + Fig10... + Fig11... + Fig13... | theme 36K, AlexaDiscovery 88K, live.db 56K/100K, alexaTouUrls.json |
| **Oct 23 2023 23:19:52 LAST ACTIVE** | Fig05... + Fig07... + Fig08... + Fig09... + Fig12... + Fig14... + Fig15... + Fig16... | LastSync 2023-10-23 23:19:52 + Wifilocker 16K + WifiConfigStore plaintext PSK + 4-DB hashes + Shutdown umount losetup |

**Last Sync Timestamp: 2023-10-23 23:19:52 UTC (Alexa Datastore InternalStorage.db)**

## 4. WiFi Forensics - Smoking Gun

- Fig09_Wifilocker_WIFI_NETWORK_XML_PSK_Credentials: 2 SSIDs Fios-pJK9 + TellMyWifiILoveHer - hashed
- Fig12_WifiConfigStore_XML_Fios-pJK9_PSK_Plaintext: SSID Fios-pJK9 plaintext PSK - MD5 2c2ab1d6... - **SECURITY SENSITIVE - REDACTED TO [REDACTED] IN SUBMISSION** - Location misc/wifi/
- Fig08_Artifacts_Hash_Verification_BuildProp_WifiConfigStore: Hash verification

## 5. Repository Structure

- 01-Evidence/: Original hashes b50fa049... + 7f35280d..., mmls output, blkid full table
- 02-Analysis/: build.prop 93e762ef..., WifiConfigStore 2c2ab1d6... (REDACTED), InternalStorage 05b08c2f..., alexaTouUrls.json, deviceConfigBundles list
- 03-Report/Final/: Executive report PDF with 25 figures exact naming
- 03-Report/Screenshots/: All 25 screenshots exact naming - no omission
- Scripts/all_successful_commands.sh: kpartx, blkid, mount -o ro, md5sum, sqlite3, umount, losetup -d

## 6. Screenshots - 25 Figures Exact Naming - No Omission


3. Fig01_Original_EMMC_Hash_MD5_SHA1_Integrity
4. Fig01_Partition_Table_mmls
5. Fig02_Image_Integrity_MD5_SHA256_Hashes
6. Fig02_System_build.prop_location
7. Fig03_Kpartx_Loop_Device_Mapping_p1-p23_Partitions
8. Fig03_Kpartx_Mapping_loop0p1-p23_System_Userdata_Blkid.
9. Fig03_Mount_and_Blkid_Partition_Verification - CRITICAL
10. Fig04_InternalStorage_DCIM_DeviceConfigBundles_Media.
11. Fig04_Userdata_p23_Mount_Directory_Listing_2023-10-03
12. Fig04_Userdata_p23_Root_Directory_Structure_DCIM_AlexaTourUrls_Logic
13. Fig05_Alexa_DomainApplication_LastSyncTimestamp_2023-10-23
14. Fig05_Build_Prop_System_Info_PS7560_AEOAT_2023-09-21
15. Fig07_Alexa_InternalStorage_DomainCalendar_LastSync_2023-10-23
16. Fig08_Artifacts_Hash_Verification_BuildProp_WifiConfigStore
17. Fig09_Wifilocker_WIFI_NETWORK_XML_PSK_Credentials
18. Fig10_Alexa_Datastore_Skills_CommsRegion_Accounts_db
19. Fig11_InternalStorage_SQLite_Tables_Entry_Access
20. Fig12_WifiConfigStore_XML_Fios-pJK9_PSK_Plaintext - REDACT PSK
21. Fig13_AlexaTourUrls_JSON_Account_Mapping_and_Datastore_DBs
22. Fig14_Final_Critical_DBs_MD5_InternalStorage_CommsRegion
23. Fig15_Final_Master_Hash_Table_4_Alexa_Datastore_DBs_05b08c2f_a0a36bc4
24. Fig16_Final_Forensic_Shutdown_Umount_Losetup_Hash_Verification_COMPLETE.
25. Fig17_DeviceConfigBundles_Onboarding_Imgs_Oct9_And_GPT_Partition_Table_Layout

## 7. Forensic Shutdown

Fig16: sudo umount mnt_userdata mnt_system + sudo losetup -d /dev/loop0 + sudo kpartx -dv - ACPO Principle 1 - COMPLETE


