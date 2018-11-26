@echo off
SET mypath=%~dp0
java -jar %mypath:~0,-1%\bfg-1.13.0.jar %*
