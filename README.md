# Quiet-Standing-Batch-Process
Code to process VMAK Quiet Standing data and generate .xlsx database
## Originally written by T Templin
#### Adapted and updated by N Fears and EK Klinkman
Original QS code written to pull from a network drive at UNTHSC. Current code written to pull from VMAK file structure in Dropbox.
MATLAB cannot pull directly from a cloud-based database. Since Dropbox is cloud-based, user running the QS batch processing code will need to sync the VMAk folder to their device.

Other changes made from original script include widening sampling rate range to 99 - 121Hz to account for 3 participant .mc files that were outside of the expected sampling rate of 120Hz: VMAK_016, VMAK_082, VMAK_112. Can widen upper limit to 123Hz if necessary. Change this in [copMeasures_ForceFiles_20221220_EK.m]

After pressing "run" in MATLAB environment, select "VMAK" base folder when prompted. Code should work in its entirety.
