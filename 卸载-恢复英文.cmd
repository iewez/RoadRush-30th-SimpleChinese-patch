@echo off
setlocal enabledelayedexpansion
chcp 936 >nul
title 暴力摩托30周年版 汉化 - 恢复英文
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
  echo 没有自动找到游戏目录，请把游戏文件夹拖到本文件上再试。
  pause
  exit /b 1
)
tasklist /fi "imagename eq RoadRash95.exe" | find /i "RoadRash95.exe" >nul
if not errorlevel 1 (
  echo 游戏正在运行，请先退出游戏。
  pause
  exit /b 1
)
if not exist "%~dp0备份\ENU-en.dll" (
  echo.
  echo   没有找到安装时生成的 备份\ENU-en.dll。
  echo   可以在 Steam 里右键游戏 → 属性 → 已安装文件 → 验证文件完整性，
  echo   让 Steam 自动还原英文语言文件。
  pause
  exit /b 1
)
copy /y "%~dp0备份\ENU-en.dll" "!GAME!\TEXT\ENU.DLL" >nul
if errorlevel 1 (
  echo 写入失败：请右键“以管理员身份运行”。
  pause
  exit /b 1
)
echo 已恢复英文原版。
pause
exit /b 0
