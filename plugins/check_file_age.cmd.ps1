param([string]$f, [int]$w, [int]$c)

# "Checking '$($f.Replace('""', ''))' (w:$w, c:$c)"

if ($f -eq "" -or $w -eq 0 -or $c -eq 0) {
    "Usage: $($MyInvocation.MyCommand.Name) path warning_age_in_sec critical_age_in_sec"
}

$file = Get-Item $f.Replace('""', '') -ErrorAction SilentlyContinue

if ($file -eq $null) {
  "[CRITICAL] File not found: '$($f.Replace('""', ''))'"
  exit 2
} elseif ($c -ne $null -and ((Get-Date) - $file.LastWriteTime).TotalSeconds -ge $c) {
  "[CRITICAL] File '$file' is too old, last modified $([int]((Get-Date) - $file.LastWriteTime).TotalSeconds) sec ago, critical level is $c sec."
  exit 2
} elseif ($w -ne $null -and ((Get-Date) - $file.LastWriteTime).TotalSeconds -ge $w) {
  "[WARNING] File '$file' is too old, last modified $([int]((Get-Date) - $file.LastWriteTime).TotalSeconds) sec ago, warning level is $w sec, critical level is $c sec."
  exit 1
} else {
  "[OK] Last modified $([int]((Get-Date) - $file.LastWriteTime).TotalSeconds) sec ago, warning level is $w"
  exit 0
}

