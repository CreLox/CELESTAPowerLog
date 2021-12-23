$Interval = 12
$Threshold = 5

$URL = "http://192.168.201.200/service/?command=GET%20CHPWRWATTS%20"+$args[0]
$Date = Get-Date -Format "yyyyMMdd"
$File = "C:\Users\"+$env:UserName+"\Desktop\"+$Date+"_LaserLine"+$args[0]+"Power.log"

while (0 -eq 0) {
	$HTML = Invoke-WebRequest $URL
	$TimeStamp = Get-Date -Format "HH:mm:ss.fff"
	
	$HTML.Content -match '"message": "(?<Status>.+) CHPWRWATTS (?<mWPower>.+)"' >$null
	if (($Matches.Status -eq "A") -and ($Matches.mWPower -ge $Threshold)) {
        	$NewLine = $TimeStamp+","+$Matches.mWPower
		Add-Content $File $NewLine
	}

	Start-Sleep -Milliseconds $Interval
}
