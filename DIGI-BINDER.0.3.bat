@echo off
title DIGI-BINDER (7-Zip Edition)
color 0a
setlocal enabledelayedexpansion

rem =====================================================
rem CONFIGURATION
rem =====================================================
set "zipper=%~dp07z.exe"
if not exist "%zipper%" (
    echo [ERROR] 7z.exe not found in this folder.
    echo Please place 7z.exe in the same directory as this script.
    pause
    exit /b
)

rem =====================================================
:MENU
cls
echo =============================================
echo           DIGI-BINDER (7-Zip Edition)
echo =============================================
echo.
echo [1] Compress multiple volumes into CBR/CBZ
echo [2] Compress each folder individually
echo [3] Convert RAR/ZIP to CBZ/CBR
echo [4] Combine multiple CBZ files into one
echo [5] Convert CBR to RAR   (Note: now converts to CBZ)
echo [6] Convert RAR to CBR   (Note: now converts to CBZ)
echo.
echo =============================================
echo   7-Zip Edition — No WinRAR required
echo =============================================
echo.
set /p choice=Select an option (1-6): 

if "%choice%"=="1" goto multi_volume
if "%choice%"=="2" goto individual
if "%choice%"=="3" goto convert
if "%choice%"=="4" goto combine_cbz
if "%choice%"=="5" goto cbr_to_rar
if "%choice%"=="6" goto rar_to_cbr
goto MENU


rem =====================================================
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
echo.
echo All volumes compressed successfully!
pause
goto MENU


rem =====================================================
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
echo.
echo Individual folders compressed successfully!
pause
goto MENU


rem =====================================================
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
echo.
echo Conversion complete!
pause
goto MENU


rem =====================================================
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


rem =====================================================
:cbr_to_rar
cls
echo [Convert CBR to RAR (CBZ replacement)]
echo Drag and drop folder containing CBR files:
set /p "folder=> "
if not exist "%folder%" (
    echo Folder not found.
    pause
    goto MENU
)

for %%A in ("%folder%\*.cbr") do (
    echo Extracting %%~nxA ...
    "%zipper%" x "%%A" -o"%folder%\temp" -y >nul
    echo Repacking as CBZ (RAR unsupported)...
    "%zipper%" a -tzip -mx9 "%folder%\%%~nA.cbz" "%folder%\temp\*" >nul
    rmdir /s /q "%folder%\temp"
)
echo.
echo Conversion complete (CBR → CBZ).
pause
goto MENU


rem =====================================================
:rar_to_cbr
cls
echo [Convert RAR to CBR (CBZ replacement)]
echo Drag and drop folder containing RAR files:
set /p "folder=> "
if not exist "%folder%" (
    echo Folder not found.
    pause
    goto MENU
)

for %%A in ("%folder%\*.rar") do (
    echo Extracting %%~nxA ...
    "%zipper%" x "%%A" -o"%folder%\temp" -y >nul
    echo Repacking as CBZ (RAR unsupported)...
    "%zipper%" a -tzip -mx9 "%folder%\%%~nA.cbz" "%folder%\temp\*" >nul
    rmdir /s /q "%folder%\temp"
)
echo.
echo Conversion complete (RAR → CBZ).
pause
goto MENU
