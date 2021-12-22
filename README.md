# CelestaPowerLog
1. Follow the instructions on CELESTA and CELESTA quattro Light Engine® Instruction Manual (3.3.3 Ethernet Connection and Control GUI) to set up communication with the CELESTA Light Engine.

2. Run this script on PowerShell. This script requires one parameter specifying the laser line to be logged. For example, to log laser line 4 (corresponding to the 545-nm line):
```
LogLaserPower.ps1 4
```

3. The log file will be on the current user's desktop with a date tag. The default interval between inquiries is 25 ms (which does not include the inquiry latency due to communication and internal processing). To set this value differently, change the value of ``$Interval`` in the code.
