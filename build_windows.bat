IF EXIST Kermesse.love GOTO mkFolder
CD files
ZIP -9 -r Kermesse.zip *
RENAME Kermesse.zip Kermesse.love
MOVE Kermesse.love ..
CD ..

:mkFolder
MD Kermesse
COPY /b dist\love.exe+Kermesse.love Kermesse\Kermesse.exe
COPY dist\*.dll Kermesse
COPY dist\license.txt Kermesse