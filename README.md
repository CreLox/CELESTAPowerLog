# Instructions
1. Follow the [CELESTA and CELESTA quattro Light Engine® Instruction Manual](https://cms.lumencor.com/system/uploads/fae/file/asset/48/57-10015-F_Celesta_09092021.pdf) (3.3.3 Ethernet Connection and Control GUI) to set up LAN communication with the onboard computer of the Light Engine. Check if the power regulator is configured to compensate for power reading crosstalk (see the [Light Engine Command Reference](https://cms.lumencor.com/system/uploads/fae/file/asset/120/57-10018.pdf)).

2. Run ``LogLaserPower.ps1`` on Windows PowerShell. You might need to change the URL in the script based on the IP shown on your Light Engine or [change the execution policies of PowerShell](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) to run the script. The script crawls answer strings from the Light Engine through its REST interface. It requires one parameter input to specify the laser line to be logged. For example, to log the 4th laser line (note that the numbering starts from 0th):
   ```PowerShell
   LogLaserPower.ps1 4
   ```
   ``GET CHPWR`` returns the raw sensor output (used in manufacturing) whereas ``GET CHPWRWATTS`` (here in ``LogLaserPower.ps1``) gives the measured output after applying calibrations. Channel mapping for the CELESTA Light Engine in the Joglekar Lab: 0-Violet (405 nm), 1-Blue (446 nm), 2-Cyan (477 nm), 3-Teal (520 nm), 4-Green (546 nm), 5-Red (638 nm), and 6-NIR (749 nm).

3. Keep the PowerShell session on for the entire logged session. The log will be on the current user's desktop. It is suggested to add **the exposure time** and **the percentage intensity** information (of the channel that used this laser line) manually to the filename of the log.

4. Each line in the log contains the following formatted information.

   **hour**(24-h clock)**:min:second**(1-ms accuracy)**,power**(in milliwatts)
   
   During most of the time, the laser is off and the instantaneous power readout is simply 0.0 mW. All measurements below ``$Threshold`` mW are ignored and not logged. The idle time between consecutive queries is set as ``$Interval`` ms (which does not include the latency due to communication and internal processing). **I am currently working on improving the robustness of queries if no answer string is received within 50 ms.**

5. Run the MATLAB function ``reconstitutePulse`` using the log file to visually examine
   - the inverse empirical cumulative distribution of instantaneous powers (assuming that all pulses from the session are equivalent);
   - a scatter plot of instantaneous power readout vs time (note that the shape of the pulse is inevitably smoothed because the power readout can never actually be instantaneous).

6. Parameters in ``LogLaserPower.ps1`` and ``reconstitutePulse.m`` are closely related. If you change a parameter in a script, you may need to consider changing the related parameter in the other script.
# Protocol for calibration using a standard strain
Streak the standard yeast strain [the Joglekar Lab uses AJY939 (*MAT*a, *NDC80-GFP:KAN, SPC25-mCherry:KAN*)] on a yeast extract-peptone-dextrose (YPD) agar plate (the streak is considered fresh for at least a month or until the agar dries out, when stored at 4 °C). One day ahead of imaging, innoculate fresh colonies into 2 mL of YPD media in the afternoon and shake the culture at 30 °C overnight (the overnight culture is considered fresh for 2 days sitting at room temperature on the bench). On the day of imaging, innoculate 4 mL of fresh YPD media **in a 125-mL flask** (for better ventilation) with the overnight culture (1:10 dilution). Shake the culture at 30 °C for 5 h. Take 1.5 mL of the log-phase culture and centrifuge at 6,000 g for 1 min. Remove the supernatant. Resuspend the yeast pellet with 1 mL of synthetic defined (SD) media [made by adding 2% of dextrose to synthetic media (SM)]. Centrifuge at 6,000 g for 1 min again. Remove the supernatant and resuspend the pellet with 20 μL of SD media. Apply 6 uL of the yeast suspension onto a #1.5 coverslip and then press a microscope slide onto the coverslip. Proceed to image **anaphase cells** (both the smaller progeny bud and the mother cell possess a kinetochore cluster within) **under a fixed setup** before media dry out. Quantify the kinetochore localization of Ndc80p-GFP and Spc25p-mCherry. Compare the mean values (and use them for normalization) between different dates.
# Acknowledgement
I would like to give my special thanks to the technical support team (especially Iain Johnson and Glennon Fagan) from Lumencor, Inc. for their explanations of terminology.
