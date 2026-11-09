# Copies the mod list from your Fjord Launcher instance into this packwiz pack,
# refreshes the index, and (unless -NoPush) commits and pushes to GitHub.
# Manage mods in the launcher as usual, then double-click update-pack.bat.
param(
    [string]$Instance = "$env:APPDATA\FjordLauncher\instances\cat-with-balloon-26.3",
    [string]$Message = "",
    [switch]$NoPush,
    [switch]$UpdateServerMods   # also update the server-only mods to their newest versions
)
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
Set-Location $repo

# --- find packwiz ---
$packwiz = (Get-Command packwiz -ErrorAction SilentlyContinue).Source
if (-not $packwiz) {
    foreach ($p in @("$repo\..\packwiz.exe", "$env:USERPROFILE\Downloads\Windows 64-bit\packwiz.exe")) {
        if (Test-Path $p) { $packwiz = (Resolve-Path $p).Path; break }
    }
}
if (-not $packwiz) { throw "packwiz.exe not found. Put it next to this folder or on your PATH." }

$indexDir = Join-Path $Instance "minecraft\mods\.index"
if (-not (Test-Path $indexDir)) { throw "Launcher mod index not found: $indexDir" }

function Get-Val($text, $key) {
    $m = [regex]::Match($text, "(?m)^$key\s*=\s*['""]([^'""]*)['""]")
    if ($m.Success) { $m.Groups[1].Value } else { "" }
}
function Get-Section($text, $header) {
    $pattern = '(?ms)^\[' + [regex]::Escape($header) + '\][ \t]*\r?$(.*?)(?=^\[|\z)'
    $m = [regex]::Match($text, $pattern)
    if ($m.Success) { $m.Groups[1].Value } else { "" }
}

# --- remember the side (client/server/both) already set for each mod in the pack ---
$sides = @{}
Get-ChildItem "$repo\mods" -Filter *.pw.toml -ErrorAction SilentlyContinue | ForEach-Object {
    $t = Get-Content $_.FullName -Raw
    $id = Get-Val (Get-Section $t 'update.modrinth') 'mod-id'
    if (-not $id) { $id = Get-Val (Get-Section $t 'update.curseforge') 'project-id' }
    if ($id) { $sides[$id] = Get-Val $t 'side' }
}

# --- rewrite mods/ from the launcher ---
$null = New-Item -ItemType Directory -Force "$repo\mods"
# Server-only mods (side = "server") aren't in the launcher, so keep them.
$serverOnly = Get-ChildItem "$repo\mods" -Filter *.pw.toml |
    Where-Object { (Get-Val (Get-Content $_.FullName -Raw) 'side') -eq 'server' }
if ($UpdateServerMods) {
    foreach ($f in $serverOnly) { & $packwiz update -y $f.BaseName.Replace('.pw', '') }
}
Get-ChildItem "$repo\mods" -Filter *.pw.toml |
    Where-Object { $serverOnly.FullName -notcontains $_.FullName } | Remove-Item
# Loose jars in the pack cause duplicate-mod crashes; mods must come from .pw.toml files.
Get-ChildItem "$repo\mods" -Filter *.jar | ForEach-Object {
    Write-Warning "Removing loose jar from pack: $($_.Name)"
    Remove-Item $_.FullName
}
$utf8 = New-Object System.Text.UTF8Encoding($false)
$count = 0
Get-ChildItem $indexDir -Filter *.pw.toml | ForEach-Object {
    $t   = Get-Content $_.FullName -Raw
    $dl  = Get-Section $t 'download'
    $mr  = Get-Section $t 'update.modrinth'
    $cf  = Get-Section $t 'update.curseforge'
    $id  = if ($mr) { Get-Val $mr 'mod-id' } else { Get-Val $cf 'project-id' }
    $side = $sides[$id]
    if (-not $side) { $side = Get-Val $t 'side' }
    if (-not $side) { $side = 'both' }

    $lines = @(
        "name = `"$(Get-Val $t 'name')`"",
        "filename = `"$(Get-Val $t 'filename')`"",
        "side = `"$side`"",
        "",
        "[download]"
    )
    $url = Get-Val $dl 'url'
    if ($url) { $lines += "url = `"$url`"" }
    $mode = Get-Val $dl 'mode'
    if ($mode -and $mode -ne 'url') { $lines += "mode = `"$mode`"" }
    $lines += "hash-format = `"$(Get-Val $dl 'hash-format')`""
    $lines += "hash = `"$(Get-Val $dl 'hash')`""
    $lines += ""
    $lines += "[update]"
    if ($mr) {
        $lines += "[update.modrinth]", "mod-id = `"$id`"", "version = `"$(Get-Val $mr 'version')`""
    } elseif ($cf) {
        $fid = [regex]::Match($cf, '(?m)^file-id\s*=\s*(\d+)').Groups[1].Value
        $lines += "[update.curseforge]", "file-id = $fid", "project-id = $id"
    }
    [IO.File]::WriteAllText("$repo\mods\$($_.Name)", ($lines -join "`n") + "`n", $utf8)
    $count++
}
Write-Host "Copied $count mods from the launcher."

# --- keep Minecraft / Fabric versions in sync ---
$pack = Get-Content "$Instance\mmc-pack.json" -Raw | ConvertFrom-Json
$mc  = ($pack.components | Where-Object uid -eq 'net.minecraft').version
$fab = ($pack.components | Where-Object uid -eq 'net.fabricmc.fabric-loader').version
$pt = Get-Content "$repo\pack.toml" -Raw
if ($mc)  { $pt = $pt -replace '(?m)^minecraft = ".*"', "minecraft = `"$mc`"" }
if ($fab) { $pt = $pt -replace '(?m)^fabric = ".*"', "fabric = `"$fab`"" }
[IO.File]::WriteAllText("$repo\pack.toml", ($pt -replace "`r`n", "`n"), $utf8)

& $packwiz refresh
if ($LASTEXITCODE) { throw "packwiz refresh failed" }

git add -A
git status --short
if ($NoPush) { Write-Host "`n-NoPush given: nothing committed."; return }
if (-not (git status --porcelain)) { Write-Host "`nNo changes - pack is already up to date."; return }
if (-not $Message) { $Message = "Update pack $(Get-Date -Format 'yyyy-MM-dd HH:mm')" }
git commit -q -m $Message
git push
if ($LASTEXITCODE) { throw "git push failed" }
Write-Host "`nDone! Friends get the update next time they press Play."
