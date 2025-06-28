
# 🛠️ AutoInstall Plesk for AlmaLinux 8 & 9

This open-source script automates the full installation of **Plesk** on **AlmaLinux 8 or 9** upon the first SSH login as root.

Developed by [ServerSP](https://serversp.com), an infrastructure provider serving global clients — including a dedicated portal for [Brazil](https://serversp.com.br).

---

## 🚀 What It Does

- ✅ Detects AlmaLinux 8 or 9
- ✅ Displays a clear countdown before starting (with Ctrl+C cancel option)
- ✅ Updates the system and installs all necessary dependencies
- ✅ Installs Plesk inside a `screen` session with interactive output
- ✅ Waits for user confirmation before rebooting the system
- ✅ Removes all temporary files and installer references after completion

---

## 📂 Files Included

| File                         | Description                                 |
|-----------------------------|---------------------------------------------|
| `.autoinstall-plesk.sh`     | Main installer logic                        |
| `README.md`                 | This documentation                          |

---

## 📦 How to Use

1. Upload the script to your server:
```bash
cp .autoinstall-plesk.sh /root/
chmod +x /root/.autoinstall-plesk.sh
```

2. Edit your `.bash_profile` and append:
```bash
[ -f /root/.autoinstall-plesk.sh ] && bash /root/.autoinstall-plesk.sh
```

> Do not overwrite `.bash_profile` if it contains other startup logic — just add the line at the end.

3. On first SSH login:
- You'll see a countdown and option to cancel
- Installation runs inside a screen session
- You'll be asked to confirm before reboot
- All scripts remove themselves after completion

---

## 🌐 Ideal Use Cases

This project is suitable for:
- VPS or dedicated server provisioning
- Template-based deployments
- Automatic panel installation on first login

---

## ⚠️ Requirements

- AlmaLinux 8.4+ or 9.x (minimal or standard)
- Root SSH access
- Internet access to `autoinstall.plesk.com`

---

## ✅ Tested On

- AlmaLinux 8.10 (minimal)
- AlmaLinux 9.4 (minimal)
- Plesk Obsidian (latest stable release, June 2025)

---

## 🛠️ Customization Ideas

You can adjust:
- Countdown duration
- Reboot behavior
- Hostname injection
- Plesk edition or extensions preloaded

---

## 📄 License

MIT © [ServerSP](https://serversp.com)

---

## 🔗 Related Resources

- [Plesk Installation Guide](https://docs.plesk.com/en-US/obsidian/quick-start-guide/)
- [Plesk Editions & Features](https://www.plesk.com/plesk-editions/)
- [ServerSP — Infrastructure & Servers](https://serversp.com)
