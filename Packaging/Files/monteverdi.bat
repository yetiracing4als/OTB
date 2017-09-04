::
:: Copyright (C) 2005-2017 Centre National d'Etudes Spatiales (CNES)
::
:: This file is part of Orfeo Toolbox
::
::    https://www.orfeo-toolbox.org/
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::    http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Monteverdi launcher to set up proper environment
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
setlocal

:: Get the directory of the current script
set CURRENT_SCRIPT_DIR=%~dp0

:: Setup environment
call "%CURRENT_SCRIPT_DIR%otbenv.bat"

:: Set current dir to HOME dir because Monteverdi generates temporary files and need write access
cd %HOMEDRIVE%%HOMEPATH%

:: Start Monteverdi
start "Monteverdi Viewer" /B "%CURRENT_SCRIPT_DIR%bin\monteverdi.exe" %*

endlocal