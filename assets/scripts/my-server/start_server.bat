@echo off

REM Navigate to your project directory
cd /d "C:\Users\hp\my-server"

REM Retrieve the local IP address using ipconfig and filter the IPv4 address
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do set IP_ADDRESS=%%i

REM Remove any leading spaces from IP_ADDRESS (this may be needed depending on your system)
set IP_ADDRESS=%IP_ADDRESS: =%

REM Define the port number (replace with the actual port if necessary)
set PORT=3000

REM Display the IP address and port number
echo Server will run at: http://%IP_ADDRESS%:%PORT%

REM Run the Node.js server (index.js)
node index.js

REM Pause to see any output before the window closes
pause
