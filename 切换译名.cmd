@echo off
setlocal enabledelayedexpansion
chcp 936 >nul
title 暴力摩托30周年版 汉化 - 切换译名
set "GAME="
if not "%~1"=="" if exist "%~1\RoadRash95.exe" set "GAME=%~1"
if not defined GAME if exist "%~dp0RoadRash95.exe" set "GAME=%~dp0."
if not defined GAME (
  for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\RoadRash 95" /v Path 2^>nul ^| find /i "REG_SZ"') do set "GAME=%%b"
)
if defined GAME if not exist "!GAME!\RoadRash95.exe" set "GAME="
if not defined GAME (
  for %%d in ("C:\Program Files (x86)\Steam\steamapps\common\RoadRash" "C:\Program Files\Steam\steamapps\common\RoadRash" "D:\SteamLibrary\steamapps\common\RoadRash" "E:\SteamLibrary\steamapps\common\RoadRash" "F:\SteamLibrary\steamapps\common\RoadRash") do (
    if not defined GAME if exist "%%~d\RoadRash95.exe" set "GAME=%%~d"
  )
)
if not defined GAME (
  echo 没有自动找到游戏目录，请先运行 安装汉化.cmd（可把游戏文件夹拖上去）。
  pause
  exit /b 1
)
tasklist /fi "imagename eq RoadRash95.exe" | find /i "RoadRash95.exe" >nul
if not errorlevel 1 (
  echo 游戏正在运行，请先退出游戏。
  pause
  exit /b 1
)
echo.
echo   ===== 选择人名译名 =====
echo.
echo   1. 通用译名（阿克索 / 博斯 / 珀尔 / 朗达 ...）
echo   2. 经典译名（戴维 / 杰斐逊 / 姆克迪 / 塞利娜 ...，2004 汉化版）
echo.
set /p c=请选择 [1/2]: 
if "%c%"=="1" (
  set "SRC=%~dp0ENU-cn.dll"
  set "NAME=通用译名"
) else if "%c%"=="2" (
  set "SRC=%~dp0ENU-cn-classic.dll"
  set "NAME=经典译名"
) else (
  echo 输入无效。
  pause
  exit /b 1
)
copy /y "!SRC!" "!GAME!\TEXT\ENU.DLL" >nul
if errorlevel 1 (
  echo 写入失败：请右键“以管理员身份运行”。
  pause
  exit /b 1
)
echo 已切换为：简体中文（!NAME!）。
pause
exit /b 0
