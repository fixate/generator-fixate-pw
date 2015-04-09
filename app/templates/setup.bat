:: create a symlink from the styleguide to the production assets if one doesn't
:: already exist
@echo if you get an eror then please run this file (setup.bat) in a windows command prompt with administrator rights

@echo off

fsutil reparsepoint query "styleguide/public/assets" | find "Symbolic Link"
if %errorlevel% == 0 echo This is a symlink/junction
if %errorlevel% == 1 (
	rmdir /s /q styleguide\public\assets
	mklink /d "styleguide\public\assets" "..\..\src\site\templates\assets"
)