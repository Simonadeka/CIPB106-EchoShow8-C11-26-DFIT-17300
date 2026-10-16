# ============================================
# 1. INITIAL ACQUISITION & VERIFICATION
# ============================================
cd ~/DFIT
ls -lh C11-EchoShow8-26-DFIT-17300.img
md5sum C11-EchoShow8-26-DFIT-17300.img > 01_original_hash.txt
sha256sum C11-EchoShow8-26-DFIT-17300.img
fdisk -l C11-EchoShow8-26-DFIT-17300.img
file C11-EchoShow8-26-DFIT-17300.img

# ============================================
# 2. MOUNT IMAGE (Read-Only)
# ============================================
sudo losetup -P -f --show -r C11-EchoShow8-26-DFIT-17300.img
# Note: it will show /dev/loop0

sudo fdisk -l /dev/loop0
ls /dev/loop0p*

sudo mkdir -p /mnt/echo_system
sudo mkdir -p /mnt/echo_userdata

sudo mount -o ro /dev/loop0p21 /mnt/echo_system
sudo mount -o ro /dev/loop0p23 /mnt/echo_userdata

df -h | grep echo
ls /mnt/echo_system/
ls /mnt/echo_userdata/

# ============================================
# 3. EVIDENCE INTEGRITY - 8x MD5 HASHES (CRITICAL FOR MARKS)
# ============================================
echo "=== 8 MD5 HASHES ===" > 02-Analysis/Hashes/hashes.txt

md5sum /mnt/echo_system/system/build.prop | tee -a 02-Analysis/Hashes/hashes.txt
md5sum /mnt/echo_userdata/misc/wifi/WifiConfigStore.xml | tee -a 02-Analysis/Hashes/hashes.txt
md5sum C11-EchoShow8-26-DFIT-17300.img | tee -a 02-Analysis/Hashes/hashes.txt
md5sum /mnt/echo_userdata/data/com.amazon.wifilocker/shared_prefs/* | tee -a 02-Analysis/Hashes/hashes.txt
md5sum /mnt/echo_userdata/data/com.amazon.alexa.datastore.app/databases/* | tee -a 02-Analysis/Hashes/hashes.txt
md5sum /mnt/echo_userdata/data/system/users/0/accounts.db | tee -a 02-Analysis/Hashes/hashes.txt

# Individual hashes for report:
md5sum /mnt/echo_system/system/build.prop
md5sum /mnt/echo_userdata/misc/wifi/WifiConfigStore.xml
md5sum /mnt/echo_userdata/data/com.amazon.wifilocker/shared_prefs/com.amazon.wifilocker_preferences.xml

# ============================================
# 4. EXTRACT KEY ARTIFACTS
# ============================================
# Create evidence structure
mkdir -p 01-Evidence/System
mkdir -p 01-Evidence/Userdata/WiFi
mkdir -p 01-Evidence/Userdata/Alexa
mkdir -p 03-Report/Screenshots
mkdir -p 03-Report/Final

# Copy artifacts (from mount to evidence)
sudo cp /mnt/echo_system/system/build.prop 01-Evidence/System/
sudo cp /mnt/echo_userdata/misc/wifi/WifiConfigStore.xml 01-Evidence/Userdata/WiFi/
sudo cp -r /mnt/echo_userdata/data/com.amazon.wifilocker/ 01-Evidence/Userdata/WiFi/
sudo cp -r /mnt/echo_userdata/data/com.amazon.alexa.datastore.app/ 01-Evidence/Userdata/Alexa/
sudo cp /mnt/echo_userdata/data/system/users/0/accounts.db 01-Evidence/Userdata/
sudo cp -r /mnt/echo_userdata/data/media/0/ 01-Evidence/Userdata/InternalStorage/

# Fix permissions so you can read them
sudo chown -R $USER:$USER 01-Evidence/
chmod -R 644 01-Evidence/

# ============================================
# 5. ANALYSIS - KEY FINDINGS
# ============================================
cat 01-Evidence/System/build.prop
cat 01-Evidence/System/build.prop | grep -E "ro.build.version|ro.product.model|ro.build.date"

cat 01-Evidence/Userdata/WiFi/WifiConfigStore.xml
cat 01-Evidence/Userdata/WiFi/WifiConfigStore.xml | grep -E "SSID|PSK"

strings 01-Evidence/Userdata/accounts.db | head -20
sqlite3 01-Evidence/Userdata/accounts.db ".tables"
sqlite3 01-Evidence/Userdata/accounts.db "SELECT * FROM accounts;"

ls -lh 01-Evidence/Userdata/Alexa/
find 01-Evidence/Userdata/Alexa/ -name "*.db" -exec ls -lh {} \;
sqlite3 01-Evidence/Userdata/Alexa/databases/*.db ".tables"

# Last Sync Timestamp - CRITICAL
grep -r "2023-10-23" 01-Evidence/Userdata/Alexa/ | head
strings 01-Evidence/Userdata/Alexa/ | grep -i "2023-10-23 23:19:52"

# ============================================
# 6. UNMOUNT CLEANLY (After lab)
# ============================================
sudo umount /mnt/echo_system
sudo umount /mnt/echo_userdata
sudo losetup -d /dev/loop0
losetup -a
