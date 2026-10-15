param(
    [string]$TargetOrg = 'TalentDev',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$env:SF_DISABLE_TELEMETRY = 'true'

$objectNames = @(
    'Department__c',
    'Position__c',
    'Skill__c',
    'Job_Opening__c',
    'Candidate__c',
    'Certification__c',
    'Job_Requisition__c',
    'Job_Application__c',
    'interview__c',
    'Offer__c',
    'Onboarding_Plan__c',
    'Employee__c',
    'Performance_Cycle__c',
    'Performance_Review__c',
    'Development_Plan__c',
    'Critical_Position__c',
    'Succession_Nomination__c',
    'Resume_Parsing_Request__c',
    'Match_Result__c',
    'AI_Interaction__c',
    'Integration_Log__c'
)

$sourceArguments = foreach ($objectName in $objectNames) {
    '--source-dir'
    "force-app/main/default/objects/$objectName/$objectName.object-meta.xml"
}

$arguments = @(
    'project', 'deploy', 'start',
    '--target-org', $TargetOrg,
    '--test-level', 'NoTestRun',
    '--wait', '60',
    '--json'
) + $sourceArguments

if ($DryRun) {
    $arguments += '--dry-run'
}

$projectLocalCli = Join-Path $PSScriptRoot '..\..\salesforce-tooling\node_modules\.bin\sf.cmd'
if (Test-Path -LiteralPath $projectLocalCli) {
    $sfCli = (Resolve-Path -LiteralPath $projectLocalCli).Path
} else {
    $sfCli = (Get-Command sf.cmd -ErrorAction Stop).Source
}

& $sfCli @arguments
exit $LASTEXITCODE
