# Windows System Management Scripts

This collection contains scripts for Windows Defender control and comprehensive cache clearing on Windows 10/11.

## ⚠️ WARNING ⚠️

**Disabling Windows Defender will leave your system vulnerable to malware and viruses. Only use these scripts if you absolutely need to and understand the security risks involved.**

## 🚀 Features

### Windows Defender Control
- Disable/Enable Windows Defender completely
- Safe with confirmation prompts
- Proper error handling
- Easy batch file execution

### Cache Clearing
- **Complete Cache Clear**: Remove all types of cache at once
- **Selective Cache Clear**: Choose specific cache types to clear
- **Interactive Menu**: User-friendly selection interface
- **Real-time Status**: See progress as scripts run

## 📁 Files Included

### Windows Defender Control
- `disable_windows_defender.ps1` - PowerShell script to disable Windows Defender
- `enable_windows_defender.ps1` - PowerShell script to re-enable Windows Defender  
- `disable_windows_defender.bat` - Batch file wrapper for easy execution

### Cache Clearing Scripts
- `clear_all_cache.bat` - Batch script to clear all cache types
- `clear_all_cache.ps1` - PowerShell script to clear all cache types (advanced)
- `selective_cache_clear.ps1` - Interactive menu to selectively clear specific cache types

## 🛠️ How to Use

### Windows Defender Control

#### Method 1: Using the Batch File (Recommended)
1. Right-click on `disable_windows_defender.bat`
2. Select "Run as Administrator"
3. Follow the prompts

#### Method 2: Using PowerShell Directly
1. Right-click on PowerShell and select "Run as Administrator"
2. Navigate to the script directory
3. Run: `.\disable_windows_defender.ps1`

#### To Re-enable Windows Defender
Use the same methods with `enable_windows_defender.ps1` or run:
```powershell
.\enable_windows_defender.ps1
```

### Cache Clearing

#### Quick Cache Clear (All Types)
1. Right-click on `clear_all_cache.bat`
2. Select "Run as Administrator"
3. Follow the prompts

#### Advanced Cache Clear (PowerShell)
1. Right-click on PowerShell and select "Run as Administrator"
2. Navigate to the script directory
3. Run: `.\clear_all_cache.ps1`

#### Selective Cache Clear (Interactive Menu)
1. Right-click on PowerShell and select "Run as Administrator"
2. Navigate to the script directory
3. Run: `.\selective_cache_clear.ps1`
4. Choose which cache types to clear from the menu

## 📋 What These Scripts Do

### Windows Defender Scripts:
#### Disable Script:
- Disables real-time monitoring
- Disables IOAV protection
- Disables behavior monitoring
- Disables block at first sight
- Disables cloud protection
- Disables sample submission

#### Enable Script:
- Re-enables all the above protections
- Sets cloud protection to "Advanced"
- Sets sample submission to "Send Safe Samples"

### Cache Clearing Scripts:
#### All Cache Types Cleared:
- Windows Update Cache
- DNS Cache
- Temporary Files (User & System)
- Browser Cache (Chrome, Firefox, Edge)
- Windows Store Cache
- System Cache (Prefetch, Event logs)
- User Profile Cache (Recent files, Thumbnails)
- Print Spooler Cache
- Font Cache
- Disk Cleanup (automatic)

#### Selective Cache Clear Features:
- Interactive menu system
- Choose specific cache types to clear
- Real-time status updates
- Error handling for each operation

## ⚙️ Requirements

- Windows 10 or Windows 11
- Administrator privileges
- PowerShell execution policy that allows script execution

## 🔧 Troubleshooting

If you get errors:
1. Make sure you're running as Administrator
2. Check if Windows Defender is managed by Group Policy
3. Try running PowerShell as Administrator and execute: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

## 🔒 Security Note

Remember to re-enable Windows Defender when you're done with your task. These scripts are for temporary use only.

## 💡 Cache Clearing Benefits

- **Performance Improvement**: Clearing cache can free up disk space and improve system performance
- **Troubleshooting**: Helps resolve issues with Windows Update, browsers, and system components
- **Privacy**: Removes browsing history and temporary files
- **Storage Space**: Frees up significant disk space, especially after long periods of use

## 🎯 Tips for Best Results

1. **Close all applications** before running cache clearing scripts
2. **Restart your computer** after clearing cache for best results
3. **Use selective clearing** if you only need to clear specific cache types
4. **Run regularly** to maintain optimal system performance

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## ⚠️ Disclaimer

These scripts are provided as-is for educational and troubleshooting purposes. Use at your own risk. The authors are not responsible for any damage or data loss that may occur from using these scripts.

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub. 