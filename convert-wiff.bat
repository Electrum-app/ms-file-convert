@echo off

:: Set log file variables 
::C:\Users\jorda\Desktop\midas-data-files.txt
set pw_file=C:\Users\jorda\Desktop\pw.txt
set file_list=%1 
set out_log=C:\Users\jorda\Desktop\log_out.txt

echo "Running %file_list%..."

:: Set counter
set /a c=1

:: Get file line count 
set /a total=0
for /f "usebackq" %%a in (%file_list%) do (set /a total+=1)

:: Begin file processing
setlocal ENABLEDELAYEDEXPANSION
for /f "usebackq tokens=1 delims= " %%a in ("%file_list%") do (
	
	echo Started: %date% %time%
	echo ">>> Running !c! / %total% : %%a <<<"

	for %%F in ("%%a") do (
		
		:: Get wiff2 file
		"C:\Users\jorda\Desktop\pscp" -pwfile "C:\Users\jorda\Desktop\pw.txt" "u0690617@notchpeak.chpc.utah.edu:%%a.wiff2" "C:\Users\jorda\Desktop\MIDAS_data\\%%~nxF.wiff2" 

		:: Get scan file
		"C:\Users\jorda\Desktop\pscp" -pwfile "C:\Users\jorda\Desktop\pw.txt" "u0690617@notchpeak.chpc.utah.edu:%%a.wiff.scan" "C:\Users\jorda\Desktop\MIDAS_data\%%~nxF.wiff.scan" 

		:: Convert file
		"C:\Users\jorda\AppData\Local\Apps\ProteoWizard 3.0.23048.ad62c7a 64-bit\msconvert.exe" --zlib --ignoreUnknownInstrumentError --filter "titleMaker <RunId>.<ScanNumber>.<ScanNumber>.<ChargeState> File:"""^<SourcePath^>""", NativeID:"""^<Id^>""""  "C:\Users\jorda\Desktop\MIDAS_data\%%~nxF.wiff2"

		:: Upload file 
		"C:\Users\jorda\Desktop\pscp" -pwfile "C:\Users\jorda\Desktop\pw.txt" "C:\Users\jorda\Desktop\%%~nxF*.mzML" "u0690617@notchpeak.chpc.utah.edu:/uufs/chpc.utah.edu/common/home/rutter-group-30tb/sciex/MIDAS_CONVERTED/" 

		:: Remove local files
		del "C:\Users\jorda\Desktop\MIDAS_data\%%~nxF.wiff2"
		del "C:\Users\jorda\Desktop\MIDAS_data\%%~nxF.wiff.scan"
		del "C:\Users\jorda\Desktop\*%%~nxF*.mzML"

		:: Update output log 
		echo %%a >> "C:\Users\jorda\Desktop\%file_list%.out"
		
	)

	set /a c=c+1
)
endlocal
