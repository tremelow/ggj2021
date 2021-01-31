$loveFile = Test-Path Kermesse.love
if(-NOT ($loveFile)) {
    Compress-Archive -Path 'files\*' -DestinationPath 'Kermesse.zip'
    Rename-Item 'Kermesse.zip' 'Kermesse.love'
}

New-Item -Path 'Kermesse' -ItemType Directory
cmd /c copy /b dist\love.exe+Kermesse.love Kermesse\Kermesse.exe
Copy-Item -Path 'dist\*.dll' -Destination 'Kermesse'
Copy-Item -Path 'dist\license.txt' -Destination 'Kermesse\license.txt'