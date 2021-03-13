@echo off
SET mypath=%~dp0
java -jar %mypath:~0,-1%\bfg-1.14.0.jar %*
