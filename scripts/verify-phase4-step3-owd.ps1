param(
    [string]$TargetOrg = 'TalentDev'
)

$ErrorActionPreference = 'Stop'
$env:SF_DISABLE_TELEMETRY = 'true'

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$model = Import-Csv (Join-Path $projectRoot 'data\phase4\owd-model.csv')
$quotedNames = ($model.Object_API | ForEach-Object { "'$_'" }) -join ','
$soql = "SELECT QualifiedApiName, InternalSharingModel, ExternalSharingModel FROM EntityDefinition WHERE QualifiedApiName IN ($quotedNames) ORDER BY QualifiedApiName"

$projectLocalCli = Join-Path $PSScriptRoot '..\..\salesforce-tooling\node_modules\.bin\sf.cmd'
if (Test-Path -LiteralPath $projectLocalCli) {
    $sfCli = (Resolve-Path -LiteralPath $projectLocalCli).Path
} else {
    $sfCli = (Get-Command sf.cmd -ErrorAction Stop).Source
}

$queryResult = (& $sfCli data query --target-org $TargetOrg --use-tooling-api --query $soql --json | Out-String) | ConvertFrom-Json
if ($queryResult.status -ne 0) {
    throw 'Could not query live organization-wide defaults.'
}

$liveByName = @{}
foreach ($record in $queryResult.result.records) {
    $liveByName[$record.QualifiedApiName] = $record
}

$results = foreach ($expected in $model) {
    $live = $liveByName[$expected.Object_API]
    $matches = $null -ne $live -and
        $live.InternalSharingModel -eq $expected.Target_Internal -and
        $live.ExternalSharingModel -eq $expected.Target_External

    [pscustomobject]@{
        Object = $expected.Object_API
        ExpectedInternal = $expected.Target_Internal
        ActualInternal = if ($null -eq $live) { 'MISSING' } else { $live.InternalSharingModel }
        ExpectedExternal = $expected.Target_External
        ActualExternal = if ($null -eq $live) { 'MISSING' } else { $live.ExternalSharingModel }
        Result = if ($matches) { 'PASS' } else { 'FAIL' }
    }
}

$failed = @($results | Where-Object Result -eq 'FAIL')
$summary = [pscustomobject]@{
    TargetOrg = $TargetOrg
    Checked = $results.Count
    Passed = $results.Count - $failed.Count
    Failed = $failed.Count
    Results = $results
}

$summary | ConvertTo-Json -Depth 4
if ($failed.Count -gt 0) { exit 1 }
