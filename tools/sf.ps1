$ErrorActionPreference = 'Stop'
$env:SF_DISABLE_TELEMETRY = 'true'

$cliPath = Join-Path $PSScriptRoot '..\..\salesforce-tooling\node_modules\.bin\sf.cmd'
$resolvedCliPath = (Resolve-Path -LiteralPath $cliPath).Path

& $resolvedCliPath @args
exit $LASTEXITCODE
