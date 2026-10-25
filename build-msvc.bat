@echo off
setlocal enabledelayedexpansion

echo ======================================================================
echo   DLSS 5 For All - Compilador MSVC Otimizado (RTX 5080 / Blackwell)
echo ======================================================================

set "VS_PATH="
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "VS_PATH=%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "VS_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" (
    set "VS_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "VS_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
)

if "%VS_PATH%"=="" (
    echo [ERRO] Visual Studio x64 vcvars64.bat nao encontrado!
    pause
    exit /b 1
)

echo [1/3] Configurando ambiente x64...
call "%VS_PATH%" >nul

echo [2/3] Compilando recursos do Windows (app.rc)...
rc /nologo /fo app.res app.rc
if %ERRORLEVEL% neq 0 (
    echo [ERRO] Falha ao compilar app.rc
    pause
    exit /b %ERRORLEVEL%
)

echo [3/3] Compilando DLSS 5 For All (C++17, /O2, /fp:fast)...
cl /nologo /O2 /fp:fast /std:c++17 /EHsc /utf-8 /DDLSS5_DEV ^
   /I. /Iexternal/ffx /Iexternal/ffx/framegeneration/include /Iexternal/ffx/api/include /Iexternal/ffmpeg-lgpl/include ^
   /c main.cpp

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Falha na compilacao de main.cpp
    pause
    exit /b %ERRORLEVEL%
)

echo [LINK] Linkando executavel final DLSS5ForAll.exe...
link /nologo main.obj app.res /out:DLSS5ForAll.exe /subsystem:windows /OPT:REF /OPT:ICF ^
     d3d11.lib d3d12.lib dxgi.lib dxguid.lib mfplat.lib mf.lib mfreadwrite.lib mfuuid.lib ^
     ole32.lib oleaut32.lib comctl32.lib dwmapi.lib runtimeobject.lib gdiplus.lib gdi32.lib ^
     bcrypt.lib user32.lib kernel32.lib shell32.lib advapi32.lib d3dcompiler.lib avrt.lib

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Falha no link de DLSS5ForAll.exe
    pause
    exit /b %ERRORLEVEL%
)

echo ======================================================================
echo   [SUCESSO] DLSS5ForAll.exe compilado com sucesso!
echo ======================================================================
