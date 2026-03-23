[Setup]
AppName=القرآن الكريم
AppVerName=القرآن الكريم 1.0.0
Version=1.0.0
AppPublisher=Quran App
AppPublisherURL=https://quran.app
DefaultDirName={commonpf}\QuranApp
DefaultAppName=القرآن الكريم
UninstallDisplayIcon={app}\quran_app.exe
UninstallDisplayName=القرآن الكريم
Compression=lzma2/max
SolidCompression=yes
OutputDir=.\installer
OutputBaseFilename=QuranApp_Setup
SetupIconFile=.\windows\runner\resources\app_icon.ico
WizardStyle=modern
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
LicenseFile=
PrivilegesRequired=admin
LanguageDetectionMethod=uilanguage
ShowLanguageDialog=no

[Languages]
Name: "arabic"; MessagesFile: "compiler:Languages\Arabic.isl"
Name: "english"; MessagesFile: "compiler:Languages\English.isl"

[Messages]
BeautifyLabel=

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "build\windows\x64\runner\Release\quran_app.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\القرآن الكريم"; Filename: "{app}\quran_app.exe"
Name: "{group}\{cm:UninstallProgram,القرآن الكريم}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\القرآن الكريم"; Filename: "{app}\quran_app.exe"
Name: "{userdesktop}\القرآن الكريم"; Filename: "{app}\quran_app.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\quran_app.exe"; Description: "{cm:LaunchProgram,القرآن الكريم}"; Flags: nowait postinstall skipifsilent