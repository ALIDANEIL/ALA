[Setup]
AppName=ALA
AppVersion=1.0.1
AppPublisher=ALIDANEIL
AppPublisherURL=https://github.com/ALIDANEIL/ALA
DefaultDirName={localappdata}\Programs\ALA
DefaultGroupName=ALA
OutputDir=output
OutputBaseFilename=ALA_Setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
DisableDirPage=no
DisableWelcomePage=no
DisableReadyPage=no
WizardStyle=modern

[Files]
Source: "..\dist\ALA\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion
Source: "..\portable-python\*"; DestDir: "{app}\portable-python"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{autoprograms}\ALA"; Filename: "{app}\ALA.exe"
Name: "{autodesktop}\ALA"; Filename: "{app}\ALA.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\ALA.exe"; Description: "Launch ALA"; Flags: nowait postinstall skipifsilent
