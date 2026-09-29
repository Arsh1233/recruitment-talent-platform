$ErrorActionPreference = 'Stop'

$nodePath = 'C:\Program Files\nodejs\node.exe'
$npmCliPath = 'C:\Program Files\nodejs\node_modules\npm\bin\npm-cli.js'
$cachePath = Join-Path $PSScriptRoot '..\.npm-cache'

& $nodePath $npmCliPath --cache $cachePath @args
exit $LASTEXITCODE
