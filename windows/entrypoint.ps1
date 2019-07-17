<#
    watch the sentinel `c:\opt\rke-tools\entrypoint.ps1` is ready or not
#>

$ErrorActionPreference = 'Stop'
$WarningPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$DebugPreference = 'SilentlyContinue'
$InformationPreference = 'SilentlyContinue'

function Log-Info
{
    Write-Host -NoNewline -ForegroundColor Blue "INFO: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($args -join " "))
}

function Log-Fatal
{
    Write-Host -NoNewline -ForegroundColor DarkRed "FATA: "
    Write-Host -ForegroundColor Gray ("{0,-44}" -f ($args -join " "))

    exit 1
}

function Wait-Ready 
{
    param(
        [parameter(Mandatory = $true)] $Path
    )

    $count = 600
    while ($count -gt 0) 
    {
        Start-Sleep -s 1

        if (Test-Path $Path -ErrorAction Ignore) 
        {
            Start-Sleep -s 5
            break
        }

        Start-Sleep -s 1
        $count -= 1
    }

    if ($count -le 0) 
    {
        Log-Fatal "Timeout, could not found $Path"
    }
}

function Fix-LegacyArgument
{
    param (
        [parameter(Mandatory = $false)] [string[]]$ArgumentList
    )

    $argList = @()
    $legacy = $null
    for ($i = $ArgumentList.Length; $i -ge 0; $i--) {
        $arg = $ArgumentList[$i]
        switch -regex ($arg)
        {
            "^-{2}.*" {
                if ($legacy) {
                    $arg = '{0}:{1}' -f $arg, $legacy
                    $legacy = $null
                }
                $argList += $arg
            }
            default {
                $legacy = $arg
            }
        }
    }

    return $argList
}

function Run-PowerShell
{
    param (
        [parameter(Mandatory = $false)] [string[]]$ArgumentList
    )

    try {
        if ($ArgumentList) {
            Start-Process -NoNewWindow -Wait -FilePath "powershell" -ArgumentList $ArgumentList
        } else {
            Start-Process -NoNewWindow -Wait -FilePath "powershell"
        }
    } catch {
        $errMsg = $_.Exception.Message
        if ($errMsg -like "*This command cannot be run due to the error: *") {
            if ($ArgumentList) {
                Start-Process -NoNewWindow -Wait -FilePath "pwsh" -ArgumentList $ArgumentList
            } else {
                Start-Process -NoNewWindow -Wait -FilePath "pwsh"
            }
        } else {
            throw $_
        }
    }
}

# the bootstrap arguments for kubernetes components are formatted by `component-name --key1=val1 --key2=val2 ...`,
# when passing `--pod-infra-container-image=rancher/kubelet-pause:v0.1.2` via windows docker,
# powershell would recognize it as `--pod-infra-container-image=rancher/kubelet-pause` and `v0.0.2`
$argList = Fix-LegacyArgument -ArgumentList $args[1..$args.Length]

# waiting for the sentinel ready, which provided by servcie-sidekick
Log-Info "Waiting for servcie-sidekick to prepare the entrypoint.ps1 ..."
Wait-Ready -Path "c:\opt\rke-tools\entrypoint.ps1"
$entryArgs = @("-NoLogo", "-NonInteractive", "-File", "c:\opt\rke-tools\entrypoint.ps1", $args[0]) + $argList
Run-PowerShell -ArgumentList $entryArgs
