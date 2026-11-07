@echo off
setlocal enabledelayedexpansion
chcp 936 >nul
title 暴力摩托30周年版 简体中文汉化补丁 - 安装
set "GAME="
rem 1) 参数：把游戏文件夹拖到本文件上
if not "%~1"=="" if exist "%~1\RoadRash95.exe" set "GAME=%~1"
rem 2) 补丁目录就在游戏根目录里（TEXT 同级）
if not defined GAME if exist "%~dp0RoadRash95.exe" set "GAME=%~dp0."
rem 3) 注册表里游戏自己写的安装路径
if not defined GAME (
  for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\RoadRash 95" /v Path 2^>nul ^| find /i "REG_SZ"') do set "GAME=%%b"
)
if defined GAME if not exist "!GAME!\RoadRash95.exe" set "GAME="
rem 4) 常见 Steam 库位置
if not defined GAME (
  for %%d in ("C:\Program Files (x86)\Steam\steamapps\common\RoadRash" "C:\Program Files\Steam\steamapps\common\RoadRash" "D:\SteamLibrary\steamapps\common\RoadRash" "E:\SteamLibrary\steamapps\common\RoadRash" "F:\SteamLibrary\steamapps\common\RoadRash") do (
    if not defined GAME if exist "%%~d\RoadRash95.exe" set "GAME=%%~d"
  )
)
echo.
echo   ===== 暴力摩托 30 周年纪念版 简体中文汉化补丁 v1.0 =====
echo.
if not defined GAME (
  echo   没有自动找到游戏目录。
  echo.
  echo   请把游戏的 RoadRash 文件夹拖到这个 安装汉化.cmd 上再松手；
  echo   或者把补丁里的文件直接复制到 RoadRash\TEXT\ 下并改名 ENU.DLL。
  echo.
  pause
  exit /b 1
)
echo   游戏目录：!GAME!
tasklist /fi "imagename eq RoadRash95.exe" | find /i "RoadRash95.exe" >nul
if not errorlevel 1 (
  echo.
  echo   游戏正在运行，请先退出游戏再安装。
  pause
  exit /b 1
)
if not exist "%~dp0ENU-cn.dll" (
  echo   缺少 ENU-cn.dll，补丁文件不完整。
  pause
  exit /b 1
)
if not exist "%~dp0备份" mkdir "%~dp0备份" >nul 2>&1
if not exist "%~dp0备份\ENU-en.dll" (
  copy /y "!GAME!\TEXT\ENU.DLL" "%~dp0备份\ENU-en.dll" >nul
  echo   已备份原版语言文件到 备份\ENU-en.dll
)
copy /y "%~dp0ENU-cn.dll" "!GAME!\TEXT\ENU.DLL" >nul
if errorlevel 1 (
  echo.
  echo   写入失败：请右键“以管理员身份运行”本文件，或确认游戏已退出。
  pause
  exit /b 1
)
echo   已安装：简体中文（通用译名）。
echo.
echo   想换成经典版人名：运行 切换译名.cmd 选 2
echo   想还原英文：运行 卸载-恢复英文.cmd
echo   启动游戏即可，语言设置保持 English 不用动。
echo.
pause
exit /b 0
