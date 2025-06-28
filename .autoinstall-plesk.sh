#!/bin/bash
#
# Script: /root/.autoinstall-plesk.sh
# Version: v1.3
# Description: Automatically installs Plesk on AlmaLinux 8/9 during the first root SSH login.
# Cleanup: Deletes itself and removes its reference from .bash_profile after execution.

if [ -f /root/.plesk_installer_done ] || [ -f /root/.plesk_install_cancelled ]; then
    exit 0
fi

OS_VERSION=$(rpm -E %{rhel})
clear

if [[ "$OS_VERSION" -ne 8 && "$OS_VERSION" -ne 9 ]]; then
    echo "❌ Unsupported OS version: AlmaLinux $OS_VERSION"
    echo "This installer only supports AlmaLinux 8 or 9."
    touch /root/.plesk_install_cancelled
    sed -i '/.autoinstall-plesk.sh/d' /root/.bash_profile
    rm -f /root/.autoinstall-plesk.sh
    exit 1
fi

SERVER_IP=$(hostname -I | awk '{print $1}')

echo "======================================================"
echo "     Welcome to your AlmaLinux $OS_VERSION server"
echo "------------------------------------------------------"
echo " Plesk installation will begin in 10 seconds."
echo " Estimated time: 15 to 30 minutes."
echo
echo " Press Ctrl+C now to CANCEL permanently."
echo "======================================================"
echo

trap 'echo -e "\nInstallation cancelled by user. It will not run again."; touch /root/.plesk_install_cancelled; sed -i "/.autoinstall-plesk.sh/d" /root/.bash_profile; rm -f /root/.autoinstall-plesk.sh; exit 1' INT

for i in {10..1}; do
    echo -ne " Starting in $i seconds... Press Ctrl+C to cancel... \r"
    sleep 1
done

echo -e "\nStarting installation..."

# Update system and install required packages
dnf -y update
dnf -y install epel-release
dnf config-manager --set-enabled epel
dnf -y update --refresh
dnf -y install wget curl screen

# Disable SELinux
echo "🔧 Disabling SELinux..."
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0 2>/dev/null || true

# Mark installer as started
touch /root/.plesk_installer_done

# Create actual installation script
cat <<EOF > /root/plesk_installer.sh
#!/bin/bash
cd /root || exit 1

echo "📥 Downloading the Plesk installer..."
wget https://autoinstall.plesk.com/plesk-installer -O plesk-installer
chmod +x plesk-installer

echo "🚀 Starting full Plesk installation..."
./plesk-installer --select-release-latest --install-everything

clear
echo "======================================================"
echo "✅ Plesk has been successfully installed!"
echo " Access the control panel via: https://$SERVER_IP:8443"
echo " Username: root"
echo " Password: use your server's root password"
echo "======================================================"
echo
echo "⚠️ It is strongly recommended to reboot your server now."
echo "Press ENTER to reboot..."
read
clear

rm -f /root/plesk_installer.sh
sed -i '/.autoinstall-plesk.sh/d' /root/.bash_profile
rm -f /root/.autoinstall-plesk.sh

reboot

exit 0
EOF

chmod +x /root/plesk_installer.sh
exec screen -S plesk-install /root/plesk_installer.sh
