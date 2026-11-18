param(
  [Parameter(Mandatory=$true)][string]$Exe,
  [Parameter(Mandatory=$true)][string]$Data
)
# Patch only the "portrait path" call so it uses fixed English key names
# (Axle/Bose/... instead of the localized DLL names).
# Same-length in-place edit: call GetRiderName -> call our stub, stub + table + strings
# are written into an unused 0xCC cave inside .text. File size is unchanged.
$ErrorActionPreference = 'Stop'
$callOff = 0x359E1
$caveOff = 0x53E0
$b = [System.IO.File]::ReadAllBytes($Exe)
$blob = [System.IO.File]::ReadAllBytes($Data)
$expect  = [byte[]](0xE8,0xA9,0xDE,0xFC,0xFF)
$patched = [byte[]](0xE8,0xFA,0xF9,0xFC,0xFF)

$isPatched = $true
for ($i = 0; $i -lt 5; $i++) { if ($b[$callOff + $i] -ne $patched[$i]) { $isPatched = $false; break } }
if ($isPatched) { "already"; exit 0 }

for ($i = 0; $i -lt 5; $i++) {
  if ($b[$callOff + $i] -ne $expect[$i]) { "mismatch-call"; exit 2 }
}
for ($i = 0; $i -lt $blob.Length; $i++) {
  if ($b[$caveOff + $i] -ne 0xCC) { "cave-not-clean"; exit 3 }
}

for ($i = 0; $i -lt $blob.Length; $i++) { $b[$caveOff + $i] = $blob[$i] }
for ($i = 0; $i -lt 5; $i++) { $b[$callOff + $i] = $patched[$i] }
[System.IO.File]::WriteAllBytes($Exe, $b)
"patched"
exit 0
