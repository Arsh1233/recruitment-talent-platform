$ErrorActionPreference = 'Stop'
$env:SF_DISABLE_TELEMETRY = 'true'

$projectLocalCli = Join-Path $PSScriptRoot '..\..\salesforce-tooling\node_modules\.bin\sf.cmd'

if (Test-Path -LiteralPath $projectLocalCli) {
    $resolvedCliPath = (Resolve-Path -LiteralPath $projectLocalCli).Path
} else {
    $resolvedCliPath = (Get-Command sf.cmd -ErrorAction Stop).Source
}

& $resolvedCliPath @args
exit $LASTEXITCODE
