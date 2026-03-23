@echo off
chcp 65001 >nul
title القرآن الكريم
cd /d "%~dp0build\windows\x64\runner\Release"
start quran_app.exe