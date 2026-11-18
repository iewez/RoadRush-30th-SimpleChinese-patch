@echo off
setlocal enabledelayedexpansion
chcp 936 >nul
title 暴力摩托30周年版 简体中文汉化补丁 - 安装
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
echo.
echo   ===== 暴力摩托 30 周年纪念版 简体中文汉化补丁 v1.2 =====
echo.
if not defined GAME (
  echo   没有自动找到游戏目录。
  echo.
  echo   请把游戏的 RoadRash 文件夹拖到这个 安装汉化.cmd 上再松手；
  echo   或者把 ENU-cn.dll 复制到 RoadRash\TEXT\ 下并改名 ENU.DLL。
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
if not exist "%~dp0备份\RoadRash95.exe.orig" (
  copy /y "!GAME!\RoadRash95.exe" "%~dp0备份\RoadRash95.exe.orig" >nul
  echo   已备份原版可执行文件到 备份\RoadRash95.exe.orig
)
copy /y "%~dp0ENU-cn.dll" "!GAME!\TEXT\ENU.DLL" >nul
if errorlevel 1 (
  echo.
  echo   写入失败：请右键“以管理员身份运行”本文件，或确认游戏已退出。
  pause
  exit /b 1
)
echo   已写入中文语言文件。
rem 让“立绘路径”改用固定英文键名，使中文名与人物立绘可同时存在
set "PR="
for /f "delims=" %%r in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0_patch_exe.ps1" -Exe "!GAME!\RoadRash95.exe" -Data "%~dp0exe-patch.bin"') do set "PR=%%r"
if "!PR!"=="patched" (
  echo   已修正立绘路径（中文名与人物立绘可同时正常显示）。
) else if "!PR!"=="already" (
  echo   立绘路径已是修正状态。
) else if "!PR!"=="mismatch-call" (
  echo   警告：游戏版本与补丁不匹配，未改动 exe；文本汉化仍然生效，立绘可能仍不显示。
) else if "!PR!"=="cave-not-clean" (
  echo   警告：exe 的代码空位已被占用，未改动 exe；文本汉化仍然生效。
) else (
  echo   警告：立绘路径修正未执行（!PR!）。
)
echo.
echo   安装完成：简体中文（通用译名）。
echo   想换成经典版人名：运行 切换译名.cmd 选 2
echo   想还原英文：运行 卸载-恢复英文.cmd
echo   启动游戏即可，语言设置保持 English 不用动。
echo.
pause
exit /b 0
