$ErrorActionPreference = "Stop"

function checkAndCopy($srcBinPath, $dstBinPath) {
    if (Test-Path $dstBinPath) {
        $dstBinHasher = Get-FileHash -Path $dstBinPath
        $srcBinHasher = Get-FileHash -Path $srcBinPath
        if ($dstBinHasher.Hash -ne $srcBinHasher.Hash) {
            $null = Copy-Item -Force -Path $srcBinPath -Destination $dstBinPath
        }
    } else {
        $null = Copy-Item -Force -Path $srcBinPath -Destination $dstBinPath
    }
}

if (-not (Test-Path "C:\kubernetes")) {
    throw "Cannot find `"C:\kubernetes`" to load the Kubernetes binaries."
}

$dstBinDir = "C:\kubernetes\bin"
$null = New-Item -Type Directory -Path $dstBinDir -ErrorAction Ignore

try {
    $srcBinDir = "$env:ProgramFiles\kubernetes\bin"

    checkAndCopy "$srcBinDir\kubelet.exe" "$dstBinDir\kubelet.exe"
    checkAndCopy "$srcBinDir\kube-proxy.exe" "$dstBinDir\kube-proxy.exe"
    checkAndCopy "$srcBinDir\kubectl.exe" "$dstBinDir\kubectl.exe"
} catch {
    try {
        $null = New-Item -Type File -Path "$dstBinDir\need_clean.tip" -ErrorAction Ignore
    } catch {}

    throw $_
}