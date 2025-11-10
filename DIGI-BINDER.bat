@echo off
title DIGI-BINDER (7-Zip Edition)
color 0a
setlocal enabledelayedexpansion

rem ============================================
rem CONFIGURATION
rem ============================================
set "zipper=%~dp07z.exe"
if not exist "%zipper%" (
    echo [ERROR] 7z.exe not found in this folder.
    echo Please place 7z.exe in the same directory as this script.
    pause
    exit /b
)

rem ============================================
:MENU
cls
echo =============================================
echo         DIGI-BINDER (7-Zip Edition)
echo =============================================
echo.
echo [1] Compress multiple volumes into CBR/CBZ
echo [2] Compress each folder individually
echo [3] Convert existing RAR/ZIP to CBR/CBZ
echo [4] Combine multiple CBZ files into one
echo.
set /p choice=Select an option (1-4): 

if "%choice%"=="1" goto multi_volume
if "%choice%"=="2" goto individual
if "%choice%"=="3" goto convert
if "%choice%"=="4" goto combine_cbz
goto MENU


rem ============================================
:multi_volume
cls
echo [Multi-volume compression mode]
echo Drag and drop the parent folder here:
set /p "folder=> "
if not exist "%folder%" (
    echo Folder not found.
    pause
    goto MENU
)

for /d %%A in ("%folder%\*") do (
    echo Compressing %%~nxA ...
    pushd "%%A"
    "%zipper%" a -tzip -mx9 "..\%%~nxA.cbz" * >nul
    popd
)
echo Done!
pause
goto MENU


rem ============================================
:individual
cls
echo [Individual compression mode]
echo Drag and drop folder here:
set /p "folder=> "
if not exist "%folder%" (
    echo Folder not found.
    pause
    goto MENU
)

for /d %%A in ("%folder%\*") do (
    echo Compressing %%~nxA ...
    "%zipper%" a -tzip -mx9 "%folder%\%%~nxA.cbz" "%%A\*" >nul
)
echo Done!
pause
goto MENU


rem ============================================
:convert
cls
echo [Conversion mode: RAR/ZIP to CBZ/CBR]
echo Drag and drop folder here:
set /p "folder=> "
if not exist "%folder%" (
    echo Folder not found.
    pause
    goto MENU
)

for %%A in ("%folder%\*.rar" "%folder%\*.zip") do (
    if exist "%%A" (
        echo Extracting %%~nxA ...
        "%zipper%" x "%%A" -o"%folder%\temp" -y >nul
        echo Repacking as CBZ ...
        "%zipper%" a -tzip -mx9 "%folder%\%%~nA.cbz" "%folder%\temp\*" >nul
        rmdir /s /q "%folder%\temp"
    )
)
echo Done!
pause
goto MENU


rem ============================================
:combine_cbz
cls
echo [Combine CBZ files into one]
echo Drag and drop folder containing CBZ files:
set /p "folder=> "
if not exist "%folder%" (
    echo Folder not found.
    pause
    goto MENU
)

echo.
set /p "output=Enter output name (without extension): "
if "%output%"=="" set "output=combined"

set "tempdir=%folder%\_temp_combine"
if exist "%tempdir%" rmdir /s /q "%tempdir%"
mkdir "%tempdir%"

echo Extracting and sorting CBZ files...
set /a i=0
for /f "delims=" %%A in ('dir /b /a-d "%folder%\*.cbz" ^| sort') do (
    set /a i+=1
    set "num=0000!i!"
    set "num=!num:~-4!"
    mkdir "%tempdir%\!num!-%%~nA"
    "%zipper%" x "%folder%\%%A" -o"%tempdir%\!num!-%%~nA" -y >nul
)

echo.
echo Creating "%output%.cbz" ...
pushd "%tempdir%"
"%zipper%" a -tzip -mx9 "%folder%\%output%.cbz" * >nul
popd

rmdir /s /q "%tempdir%"
echo.
echo Combined CBZ created successfully: %output%.cbz
pause
goto MENU
