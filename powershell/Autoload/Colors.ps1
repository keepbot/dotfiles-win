<#
.SYNOPSIS
Color scripts.

.DESCRIPTION
Color scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


### Enable 256 Colors
Add-Type -MemberDefinition @"
[DllImport("kernel32.dll", SetLastError=true)]
public static extern bool SetConsoleMode(IntPtr hConsoleHandle, int mode);
[DllImport("kernel32.dll", SetLastError=true)]
public static extern IntPtr GetStdHandle(int handle);
[DllImport("kernel32.dll", SetLastError=true)]
public static extern bool GetConsoleMode(IntPtr handle, out int mode);
"@ -namespace win32 -name nativemethods

$h = [win32.nativemethods]::getstdhandle(-11) #  stdout
$m = 0
$null = [win32.nativemethods]::getconsolemode($h, [ref]$m)
$m = $m -bor 4 # undocumented flag to enable ansi/vt100
$null = [win32.nativemethods]::setconsolemode($h, $m)

### Set Main Colors
#[console]::ForegroundColor          = "White"
#[console]::BackgroundColor          = "Black"

### Set Foreground Colors
#$Host.PrivateData.ErrorForegroundColor = 'Red'
#$Host.PrivateData.WarningForegroundColor = 'Yellow'
#$Host.PrivateData.DebugForegroundColor = 'DarkGreen'
#$Host.PrivateData.VerboseForegroundColor = 'DarkGray'
#$Host.PrivateData.ProgressForegroundColor = 'Gray'

### Set Background Colors
#$Host.PrivateData.ErrorBackgroundColor = 'DarkMagenta'
#$Host.PrivateData.WarningBackgroundColor = 'DarkMagenta'
#$Host.PrivateData.DebugBackgroundColor = 'DarkMagenta'
#$Host.PrivateData.VerboseBackgroundColor = 'DarkMagenta'
#$Host.PrivateData.ProgressBackgroundColor = 'DarkCyan'

### Show current console colors
function Show-Colors-Current
{
    param()
    $host.PrivateData.psobject.properties |
        ForEach-Object {
            #$text = "$($_.Name) = $($_.Value)"
            Write-host "$($_.name.padright(23)) = " -NoNewline
            Write-Host $_.Value -ForegroundColor $_.value
        }
    Write-Host
} #Show-Colors-Current

### Show all colors
function Show-Colors-All()
{
    $colors = [Enum]::GetValues( [ConsoleColor] )
    $max = ($colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
    foreach( $color in $colors )
    {
        Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
        Write-Host "$color" -Foreground $color
    }
} #Show-Colors-All

function AnsiConsole()
{
    Write-Host "[9999S[9999;1H]4;16;rgb:00/00/00\]4;17;rgb:00/00/5f\]4;18;rgb:00/00/87\]4;19;rgb:00/00/af\]4;20;rgb:00/00/d7\]4;21;rgb:00/00/ff\]4;22;rgb:00/5f/00\]4;23;rgb:00/5f/5f\]4;24;rgb:00/5f/87\]4;25;rgb:00/5f/af\]4;26;rgb:00/5f/d7\]4;27;rgb:00/5f/ff\]4;28;rgb:00/87/00\]4;29;rgb:00/87/5f\]4;30;rgb:00/87/87\]4;31;rgb:00/87/af\]4;32;rgb:00/87/d7\]4;33;rgb:00/87/ff\]4;34;rgb:00/af/00\]4;35;rgb:00/af/5f\]4;36;rgb:00/af/87\]4;37;rgb:00/af/af\]4;38;rgb:00/af/d7\]4;39;rgb:00/af/ff\]4;40;rgb:00/d7/00\]4;41;rgb:00/d7/5f\]4;42;rgb:00/d7/87\]4;43;rgb:00/d7/af\]4;44;rgb:00/d7/d7\]4;45;rgb:00/d7/ff\]4;46;rgb:00/ff/00\]4;47;rgb:00/ff/5f\]4;48;rgb:00/ff/87\]4;49;rgb:00/ff/af\]4;50;rgb:00/ff/d7\]4;51;rgb:00/ff/ff\]4;52;rgb:5f/00/00\]4;53;rgb:5f/00/5f\]4;54;rgb:5f/00/87\]4;55;rgb:5f/00/af\]4;56;rgb:5f/00/d7\]4;57;rgb:5f/00/ff\]4;58;rgb:5f/5f/00\]4;59;rgb:5f/5f/5f\]4;60;rgb:5f/5f/87\]4;61;rgb:5f/5f/af\]4;62;rgb:5f/5f/d7\]4;63;rgb:5f/5f/ff\]4;64;rgb:5f/87/00\]4;65;rgb:5f/87/5f\]4;66;rgb:5f/87/87\]4;67;rgb:5f/87/af\]4;68;rgb:5f/87/d7\]4;69;rgb:5f/87/ff\]4;70;rgb:5f/af/00\]4;71;rgb:5f/af/5f\]4;72;rgb:5f/af/87\]4;73;rgb:5f/af/af\]4;74;rgb:5f/af/d7\]4;75;rgb:5f/af/ff\]4;76;rgb:5f/d7/00\]4;77;rgb:5f/d7/5f\]4;78;rgb:5f/d7/87\]4;79;rgb:5f/d7/af\]4;80;rgb:5f/d7/d7\]4;81;rgb:5f/d7/ff\]4;82;rgb:5f/ff/00\]4;83;rgb:5f/ff/5f\]4;84;rgb:5f/ff/87\]4;85;rgb:5f/ff/af\]4;86;rgb:5f/ff/d7\]4;87;rgb:5f/ff/ff\]4;88;rgb:87/00/00\]4;89;rgb:87/00/5f\]4;90;rgb:87/00/87\]4;91;rgb:87/00/af\]4;92;rgb:87/00/d7\]4;93;rgb:87/00/ff\]4;94;rgb:87/5f/00\]4;95;rgb:87/5f/5f\]4;96;rgb:87/5f/87\]4;97;rgb:87/5f/af\]4;98;rgb:87/5f/d7\]4;99;rgb:87/5f/ff\]4;100;rgb:87/87/00\]4;101;rgb:87/87/5f\]4;102;rgb:87/87/87\]4;103;rgb:87/87/af\]4;104;rgb:87/87/d7\]4;105;rgb:87/87/ff\]4;106;rgb:87/af/00\]4;107;rgb:87/af/5f\]4;108;rgb:87/af/87\]4;109;rgb:87/af/af\]4;110;rgb:87/af/d7\]4;111;rgb:87/af/ff\]4;112;rgb:87/d7/00\]4;113;rgb:87/d7/5f\]4;114;rgb:87/d7/87\]4;115;rgb:87/d7/af\]4;116;rgb:87/d7/d7\]4;117;rgb:87/d7/ff\]4;118;rgb:87/ff/00\]4;119;rgb:87/ff/5f\]4;120;rgb:87/ff/87\]4;121;rgb:87/ff/af\]4;122;rgb:87/ff/d7\]4;123;rgb:87/ff/ff\]4;124;rgb:af/00/00\]4;125;rgb:af/00/5f\]4;126;rgb:af/00/87\]4;127;rgb:af/00/af\]4;128;rgb:af/00/d7\]4;129;rgb:af/00/ff\]4;130;rgb:af/5f/00\]4;131;rgb:af/5f/5f\]4;132;rgb:af/5f/87\]4;133;rgb:af/5f/af\]4;134;rgb:af/5f/d7\]4;135;rgb:af/5f/ff\]4;136;rgb:af/87/00\]4;137;rgb:af/87/5f\]4;138;rgb:af/87/87\]4;139;rgb:af/87/af\]4;140;rgb:af/87/d7\]4;141;rgb:af/87/ff\]4;142;rgb:af/af/00\]4;143;rgb:af/af/5f\]4;144;rgb:af/af/87\]4;145;rgb:af/af/af\]4;146;rgb:af/af/d7\]4;147;rgb:af/af/ff\]4;148;rgb:af/d7/00\]4;149;rgb:af/d7/5f\]4;150;rgb:af/d7/87\]4;151;rgb:af/d7/af\]4;152;rgb:af/d7/d7\]4;153;rgb:af/d7/ff\]4;154;rgb:af/ff/00\]4;155;rgb:af/ff/5f\]4;156;rgb:af/ff/87\]4;157;rgb:af/ff/af\]4;158;rgb:af/ff/d7\]4;159;rgb:af/ff/ff\]4;160;rgb:d7/00/00\]4;161;rgb:d7/00/5f\]4;162;rgb:d7/00/87\]4;163;rgb:d7/00/af\]4;164;rgb:d7/00/d7\]4;165;rgb:d7/00/ff\]4;166;rgb:d7/5f/00\]4;167;rgb:d7/5f/5f\]4;168;rgb:d7/5f/87\]4;169;rgb:d7/5f/af\]4;170;rgb:d7/5f/d7\]4;171;rgb:d7/5f/ff\]4;172;rgb:d7/87/00\]4;173;rgb:d7/87/5f\]4;174;rgb:d7/87/87\]4;175;rgb:d7/87/af\]4;176;rgb:d7/87/d7\]4;177;rgb:d7/87/ff\]4;178;rgb:d7/af/00\]4;179;rgb:d7/af/5f\]4;180;rgb:d7/af/87\]4;181;rgb:d7/af/af\]4;182;rgb:d7/af/d7\]4;183;rgb:d7/af/ff\]4;184;rgb:d7/d7/00\]4;185;rgb:d7/d7/5f\]4;186;rgb:d7/d7/87\]4;187;rgb:d7/d7/af\]4;188;rgb:d7/d7/d7\]4;189;rgb:d7/d7/ff\]4;190;rgb:d7/ff/00\]4;191;rgb:d7/ff/5f\]4;192;rgb:d7/ff/87\]4;193;rgb:d7/ff/af\]4;194;rgb:d7/ff/d7\]4;195;rgb:d7/ff/ff\]4;196;rgb:ff/00/00\]4;197;rgb:ff/00/5f\]4;198;rgb:ff/00/87\]4;199;rgb:ff/00/af\]4;200;rgb:ff/00/d7\]4;201;rgb:ff/00/ff\]4;202;rgb:ff/5f/00\]4;203;rgb:ff/5f/5f\]4;204;rgb:ff/5f/87\]4;205;rgb:ff/5f/af\]4;206;rgb:ff/5f/d7\]4;207;rgb:ff/5f/ff\]4;208;rgb:ff/87/00\]4;209;rgb:ff/87/5f\]4;210;rgb:ff/87/87\]4;211;rgb:ff/87/af\]4;212;rgb:ff/87/d7\]4;213;rgb:ff/87/ff\]4;214;rgb:ff/af/00\]4;215;rgb:ff/af/5f\]4;216;rgb:ff/af/87\]4;217;rgb:ff/af/af\]4;218;rgb:ff/af/d7\]4;219;rgb:ff/af/ff\]4;220;rgb:ff/d7/00\]4;221;rgb:ff/d7/5f\]4;222;rgb:ff/d7/87\]4;223;rgb:ff/d7/af\]4;224;rgb:ff/d7/d7\]4;225;rgb:ff/d7/ff\]4;226;rgb:ff/ff/00\]4;227;rgb:ff/ff/5f\]4;228;rgb:ff/ff/87\]4;229;rgb:ff/ff/af\]4;230;rgb:ff/ff/d7\]4;231;rgb:ff/ff/ff\]4;232;rgb:08/08/08\]4;233;rgb:12/12/12\]4;234;rgb:1c/1c/1c\]4;235;rgb:26/26/26\]4;236;rgb:30/30/30\]4;237;rgb:3a/3a/3a\]4;238;rgb:44/44/44\]4;239;rgb:4e/4e/4e\]4;240;rgb:58/58/58\]4;241;rgb:62/62/62\]4;242;rgb:6c/6c/6c\]4;243;rgb:76/76/76\]4;244;rgb:80/80/80\]4;245;rgb:8a/8a/8a\]4;246;rgb:94/94/94\]4;247;rgb:9e/9e/9e\]4;248;rgb:a8/a8/a8\]4;249;rgb:b2/b2/b2\]4;250;rgb:bc/bc/bc\]4;251;rgb:c6/c6/c6\]4;252;rgb:d0/d0/d0\]4;253;rgb:da/da/da\]4;254;rgb:e4/e4/e4\]4;255;rgb:ee/ee/ee\"
}

### Show 256 colors
function AnsiColors256()
{
    Write-Host "
[9999S[9999;1H]4;16;rgb:00/00/00\]4;17;rgb:00/00/5f\]4;18;rgb:00/00/87\]4;19;rgb:00/00/af\]4;20;rgb:00/00/d7\]4;21;rgb:00/00/ff\]4;22;rgb:00/5f/00\]4;23;rgb:00/5f/5f\]4;24;rgb:00/5f/87\]4;25;rgb:00/5f/af\]4;26;rgb:00/5f/d7\]4;27;rgb:00/5f/ff\]4;28;rgb:00/87/00\]4;29;rgb:00/87/5f\]4;30;rgb:00/87/87\]4;31;rgb:00/87/af\]4;32;rgb:00/87/d7\]4;33;rgb:00/87/ff\]4;34;rgb:00/af/00\]4;35;rgb:00/af/5f\]4;36;rgb:00/af/87\]4;37;rgb:00/af/af\]4;38;rgb:00/af/d7\]4;39;rgb:00/af/ff\]4;40;rgb:00/d7/00\]4;41;rgb:00/d7/5f\]4;42;rgb:00/d7/87\]4;43;rgb:00/d7/af\]4;44;rgb:00/d7/d7\]4;45;rgb:00/d7/ff\]4;46;rgb:00/ff/00\]4;47;rgb:00/ff/5f\]4;48;rgb:00/ff/87\]4;49;rgb:00/ff/af\]4;50;rgb:00/ff/d7\]4;51;rgb:00/ff/ff\]4;52;rgb:5f/00/00\]4;53;rgb:5f/00/5f\]4;54;rgb:5f/00/87\]4;55;rgb:5f/00/af\]4;56;rgb:5f/00/d7\]4;57;rgb:5f/00/ff\]4;58;rgb:5f/5f/00\]4;59;rgb:5f/5f/5f\]4;60;rgb:5f/5f/87\]4;61;rgb:5f/5f/af\]4;62;rgb:5f/5f/d7\]4;63;rgb:5f/5f/ff\]4;64;rgb:5f/87/00\]4;65;rgb:5f/87/5f\]4;66;rgb:5f/87/87\]4;67;rgb:5f/87/af\]4;68;rgb:5f/87/d7\]4;69;rgb:5f/87/ff\]4;70;rgb:5f/af/00\]4;71;rgb:5f/af/5f\]4;72;rgb:5f/af/87\]4;73;rgb:5f/af/af\]4;74;rgb:5f/af/d7\]4;75;rgb:5f/af/ff\]4;76;rgb:5f/d7/00\]4;77;rgb:5f/d7/5f\]4;78;rgb:5f/d7/87\]4;79;rgb:5f/d7/af\]4;80;rgb:5f/d7/d7\]4;81;rgb:5f/d7/ff\]4;82;rgb:5f/ff/00\]4;83;rgb:5f/ff/5f\]4;84;rgb:5f/ff/87\]4;85;rgb:5f/ff/af\]4;86;rgb:5f/ff/d7\]4;87;rgb:5f/ff/ff\]4;88;rgb:87/00/00\]4;89;rgb:87/00/5f\]4;90;rgb:87/00/87\]4;91;rgb:87/00/af\]4;92;rgb:87/00/d7\]4;93;rgb:87/00/ff\]4;94;rgb:87/5f/00\]4;95;rgb:87/5f/5f\]4;96;rgb:87/5f/87\]4;97;rgb:87/5f/af\]4;98;rgb:87/5f/d7\]4;99;rgb:87/5f/ff\]4;100;rgb:87/87/00\]4;101;rgb:87/87/5f\]4;102;rgb:87/87/87\]4;103;rgb:87/87/af\]4;104;rgb:87/87/d7\]4;105;rgb:87/87/ff\]4;106;rgb:87/af/00\]4;107;rgb:87/af/5f\]4;108;rgb:87/af/87\]4;109;rgb:87/af/af\]4;110;rgb:87/af/d7\]4;111;rgb:87/af/ff\]4;112;rgb:87/d7/00\]4;113;rgb:87/d7/5f\]4;114;rgb:87/d7/87\]4;115;rgb:87/d7/af\]4;116;rgb:87/d7/d7\]4;117;rgb:87/d7/ff\]4;118;rgb:87/ff/00\]4;119;rgb:87/ff/5f\]4;120;rgb:87/ff/87\]4;121;rgb:87/ff/af\]4;122;rgb:87/ff/d7\]4;123;rgb:87/ff/ff\]4;124;rgb:af/00/00\]4;125;rgb:af/00/5f\]4;126;rgb:af/00/87\]4;127;rgb:af/00/af\]4;128;rgb:af/00/d7\]4;129;rgb:af/00/ff\]4;130;rgb:af/5f/00\]4;131;rgb:af/5f/5f\]4;132;rgb:af/5f/87\]4;133;rgb:af/5f/af\]4;134;rgb:af/5f/d7\]4;135;rgb:af/5f/ff\]4;136;rgb:af/87/00\]4;137;rgb:af/87/5f\]4;138;rgb:af/87/87\]4;139;rgb:af/87/af\]4;140;rgb:af/87/d7\]4;141;rgb:af/87/ff\]4;142;rgb:af/af/00\]4;143;rgb:af/af/5f\]4;144;rgb:af/af/87\]4;145;rgb:af/af/af\]4;146;rgb:af/af/d7\]4;147;rgb:af/af/ff\]4;148;rgb:af/d7/00\]4;149;rgb:af/d7/5f\]4;150;rgb:af/d7/87\]4;151;rgb:af/d7/af\]4;152;rgb:af/d7/d7\]4;153;rgb:af/d7/ff\]4;154;rgb:af/ff/00\]4;155;rgb:af/ff/5f\]4;156;rgb:af/ff/87\]4;157;rgb:af/ff/af\]4;158;rgb:af/ff/d7\]4;159;rgb:af/ff/ff\]4;160;rgb:d7/00/00\]4;161;rgb:d7/00/5f\]4;162;rgb:d7/00/87\]4;163;rgb:d7/00/af\]4;164;rgb:d7/00/d7\]4;165;rgb:d7/00/ff\]4;166;rgb:d7/5f/00\]4;167;rgb:d7/5f/5f\]4;168;rgb:d7/5f/87\]4;169;rgb:d7/5f/af\]4;170;rgb:d7/5f/d7\]4;171;rgb:d7/5f/ff\]4;172;rgb:d7/87/00\]4;173;rgb:d7/87/5f\]4;174;rgb:d7/87/87\]4;175;rgb:d7/87/af\]4;176;rgb:d7/87/d7\]4;177;rgb:d7/87/ff\]4;178;rgb:d7/af/00\]4;179;rgb:d7/af/5f\]4;180;rgb:d7/af/87\]4;181;rgb:d7/af/af\]4;182;rgb:d7/af/d7\]4;183;rgb:d7/af/ff\]4;184;rgb:d7/d7/00\]4;185;rgb:d7/d7/5f\]4;186;rgb:d7/d7/87\]4;187;rgb:d7/d7/af\]4;188;rgb:d7/d7/d7\]4;189;rgb:d7/d7/ff\]4;190;rgb:d7/ff/00\]4;191;rgb:d7/ff/5f\]4;192;rgb:d7/ff/87\]4;193;rgb:d7/ff/af\]4;194;rgb:d7/ff/d7\]4;195;rgb:d7/ff/ff\]4;196;rgb:ff/00/00\]4;197;rgb:ff/00/5f\]4;198;rgb:ff/00/87\]4;199;rgb:ff/00/af\]4;200;rgb:ff/00/d7\]4;201;rgb:ff/00/ff\]4;202;rgb:ff/5f/00\]4;203;rgb:ff/5f/5f\]4;204;rgb:ff/5f/87\]4;205;rgb:ff/5f/af\]4;206;rgb:ff/5f/d7\]4;207;rgb:ff/5f/ff\]4;208;rgb:ff/87/00\]4;209;rgb:ff/87/5f\]4;210;rgb:ff/87/87\]4;211;rgb:ff/87/af\]4;212;rgb:ff/87/d7\]4;213;rgb:ff/87/ff\]4;214;rgb:ff/af/00\]4;215;rgb:ff/af/5f\]4;216;rgb:ff/af/87\]4;217;rgb:ff/af/af\]4;218;rgb:ff/af/d7\]4;219;rgb:ff/af/ff\]4;220;rgb:ff/d7/00\]4;221;rgb:ff/d7/5f\]4;222;rgb:ff/d7/87\]4;223;rgb:ff/d7/af\]4;224;rgb:ff/d7/d7\]4;225;rgb:ff/d7/ff\]4;226;rgb:ff/ff/00\]4;227;rgb:ff/ff/5f\]4;228;rgb:ff/ff/87\]4;229;rgb:ff/ff/af\]4;230;rgb:ff/ff/d7\]4;231;rgb:ff/ff/ff\]4;232;rgb:08/08/08\]4;233;rgb:12/12/12\]4;234;rgb:1c/1c/1c\]4;235;rgb:26/26/26\]4;236;rgb:30/30/30\]4;237;rgb:3a/3a/3a\]4;238;rgb:44/44/44\]4;239;rgb:4e/4e/4e\]4;240;rgb:58/58/58\]4;241;rgb:62/62/62\]4;242;rgb:6c/6c/6c\]4;243;rgb:76/76/76\]4;244;rgb:80/80/80\]4;245;rgb:8a/8a/8a\]4;246;rgb:94/94/94\]4;247;rgb:9e/9e/9e\]4;248;rgb:a8/a8/a8\]4;249;rgb:b2/b2/b2\]4;250;rgb:bc/bc/bc\]4;251;rgb:c6/c6/c6\]4;252;rgb:d0/d0/d0\]4;253;rgb:da/da/da\]4;254;rgb:e4/e4/e4\]4;255;rgb:ee/ee/ee\System colors (0..15 from xterm palette):
[48;5;0m  [48;5;1m  [48;5;2m  [48;5;3m  [48;5;4m  [48;5;5m  [48;5;6m  [48;5;7m  [0m
[48;5;8m  [48;5;9m  [48;5;10m  [48;5;11m  [48;5;12m  [48;5;13m  [48;5;14m  [48;5;15m  [0m
Color cube, 6x6x6 (16..231 from xterm palette):
[48;5;16m  [48;5;17m  [48;5;18m  [48;5;19m  [48;5;20m  [48;5;21m  [0m [48;5;52m  [48;5;53m  [48;5;54m  [48;5;55m  [48;5;56m  [48;5;57m  [0m [48;5;88m  [48;5;89m  [48;5;90m  [48;5;91m  [48;5;92m  [48;5;93m  [0m [48;5;124m  [48;5;125m  [48;5;126m  [48;5;127m  [48;5;128m  [48;5;129m  [0m [48;5;160m  [48;5;161m  [48;5;162m  [48;5;163m  [48;5;164m  [48;5;165m  [0m [48;5;196m  [48;5;197m  [48;5;198m  [48;5;199m  [48;5;200m  [48;5;201m  [0m
[48;5;22m  [48;5;23m  [48;5;24m  [48;5;25m  [48;5;26m  [48;5;27m  [0m [48;5;58m  [48;5;59m  [48;5;60m  [48;5;61m  [48;5;62m  [48;5;63m  [0m [48;5;94m  [48;5;95m  [48;5;96m  [48;5;97m  [48;5;98m  [48;5;99m  [0m [48;5;130m  [48;5;131m  [48;5;132m  [48;5;133m  [48;5;134m  [48;5;135m  [0m [48;5;166m  [48;5;167m  [48;5;168m  [48;5;169m  [48;5;170m  [48;5;171m  [0m [48;5;202m  [48;5;203m  [48;5;204m  [48;5;205m  [48;5;206m  [48;5;207m  [0m
[48;5;28m  [48;5;29m  [48;5;30m  [48;5;31m  [48;5;32m  [48;5;33m  [0m [48;5;64m  [48;5;65m  [48;5;66m  [48;5;67m  [48;5;68m  [48;5;69m  [0m [48;5;100m  [48;5;101m  [48;5;102m  [48;5;103m  [48;5;104m  [48;5;105m  [0m [48;5;136m  [48;5;137m  [48;5;138m  [48;5;139m  [48;5;140m  [48;5;141m  [0m [48;5;172m  [48;5;173m  [48;5;174m  [48;5;175m  [48;5;176m  [48;5;177m  [0m [48;5;208m  [48;5;209m  [48;5;210m  [48;5;211m  [48;5;212m  [48;5;213m  [0m
[48;5;34m  [48;5;35m  [48;5;36m  [48;5;37m  [48;5;38m  [48;5;39m  [0m [48;5;70m  [48;5;71m  [48;5;72m  [48;5;73m  [48;5;74m  [48;5;75m  [0m [48;5;106m  [48;5;107m  [48;5;108m  [48;5;109m  [48;5;110m  [48;5;111m  [0m [48;5;142m  [48;5;143m  [48;5;144m  [48;5;145m  [48;5;146m  [48;5;147m  [0m [48;5;178m  [48;5;179m  [48;5;180m  [48;5;181m  [48;5;182m  [48;5;183m  [0m [48;5;214m  [48;5;215m  [48;5;216m  [48;5;217m  [48;5;218m  [48;5;219m  [0m
[48;5;40m  [48;5;41m  [48;5;42m  [48;5;43m  [48;5;44m  [48;5;45m  [0m [48;5;76m  [48;5;77m  [48;5;78m  [48;5;79m  [48;5;80m  [48;5;81m  [0m [48;5;112m  [48;5;113m  [48;5;114m  [48;5;115m  [48;5;116m  [48;5;117m  [0m [48;5;148m  [48;5;149m  [48;5;150m  [48;5;151m  [48;5;152m  [48;5;153m  [0m [48;5;184m  [48;5;185m  [48;5;186m  [48;5;187m  [48;5;188m  [48;5;189m  [0m [48;5;220m  [48;5;221m  [48;5;222m  [48;5;223m  [48;5;224m  [48;5;225m  [0m
[48;5;46m  [48;5;47m  [48;5;48m  [48;5;49m  [48;5;50m  [48;5;51m  [0m [48;5;82m  [48;5;83m  [48;5;84m  [48;5;85m  [48;5;86m  [48;5;87m  [0m [48;5;118m  [48;5;119m  [48;5;120m  [48;5;121m  [48;5;122m  [48;5;123m  [0m [48;5;154m  [48;5;155m  [48;5;156m  [48;5;157m  [48;5;158m  [48;5;159m  [0m [48;5;190m  [48;5;191m  [48;5;192m  [48;5;193m  [48;5;194m  [48;5;195m  [0m [48;5;226m  [48;5;227m  [48;5;228m  [48;5;229m  [48;5;230m  [48;5;231m  [0m
Grayscale ramp (232..255 from xterm palette):
[48;5;232m  [48;5;233m  [48;5;234m  [48;5;235m  [48;5;236m  [48;5;237m  [48;5;238m  [48;5;239m  [48;5;240m  [48;5;241m  [48;5;242m  [48;5;243m  [48;5;244m  [48;5;245m  [48;5;246m  [48;5;247m  [48;5;248m  [48;5;249m  [48;5;250m  [48;5;251m  [48;5;252m  [48;5;253m  [48;5;254m  [48;5;255m  [0m
"
} #AnsiColors256

### Show 256 colors
function Show-Colors-Gradient()
{
    # In the current ConEmu version TrueColor is available
    # only in the lower part of console buffer

    $h = [Console]::WindowHeight
    $w = [Console]::BufferWidth
    $y = ([Console]::BufferHeight-$h)

    # Clean console contents (this will clean TrueColor attributes)
    Write-Host (([char]27)+"[9999S")
    # Apply default powershell console attributes
    Clear-Host

    # Ensure that we are in the bottom of the buffer
    try
    {
        [Console]::SetWindowPosition(0,$y)
        [Console]::SetCursorPosition(0,$y)
    }
    catch
    {
        Write-Host (([char]27)+"[9999;1H")
    }

    # Header
    $title = " Printing 24bit gradient with ANSI sequences using powershell"
    Write-Host (([char]27)+"[m"+$title)

    # Run cycles. Use {ESC [ 48 ; 2 ; R ; G ; B m} to set background
    # RGB color of the next printing character (space in this example)
    $l = 0
    $h -= 3
    $w -= 2
    while ($l -lt $h)
    {
        $b = [int]($l*255/$h)
        $c = 0
        Write-Host -NoNewLine (([char]27)+"[m ")
        while ($c -lt $w)
        {
            $r = [int]($c*255/$w)
            Write-Host -NoNewLine (([char]27)+"[48;2;"+$r+";255;"+$b+"m ")
            $c++
        }
        Write-Host (([char]27)+"[m ")
        $l++
    }

    # Footer
    Write-Host " Gradient done"
} #Show-Colors-Gradient
