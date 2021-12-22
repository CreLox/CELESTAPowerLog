# CelestaPowerLog
1. Follow the instructions on CELESTA and CELESTA quattro Light Engine® Instruction Manual (3.3.3 Ethernet Connection and Control GUI) to set up the LAN communication with the onboard computer.
2. Run this script on PowerShell (you might need to [change execution policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) to allow the script to be run). It requires one parameter input to specify the laser line to be logged. For example, to log laser line #4 (corresponding to the 545-nm line; note that the numbering starts from 0):
```
LogLaserPower.ps1 4
```

3. The log file will be on the current user's desktop with a date tag. It is suggested to add the exposure time information (of the channel that used this laser line in your experiment setup) manually to the name of the log file.
4. Each line in the log contains the following information: **hour**(24-h clock)**:min:second**(1-ms accuracy)**,power**(in milliwatts). During most of the time, the laser will not be on (so the output power will simply be 0). Therefore, all 0's are ignored and not logged. The default interval between inquiries is 25 ms (which does not include the latency due to communication and internal processing). To set this value differently, change the value of ``$Interval`` in the code.
