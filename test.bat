@echo off
setlocal enabledelayedexpansion

REM 定义源文件夹和目标文件夹
set "source_folder=D:\fmriNF\example dcm"
set "target_folder=D:\fmriNF\test\dcm"

REM 确保目标文件夹存在
if not exist "%target_folder%" (
    mkdir "%target_folder%"
)

REM 遍历源文件夹中的所有文件
for %%f in ("%source_folder%\*") do (
    REM 复制文件
    copy "%%f" "%target_folder%"
    echo Copied %%~nxf to %target_folder%
    REM 暂停2秒
    timeout /t 2 >nul
)

echo All .dcm files have been copied.
endlocal
