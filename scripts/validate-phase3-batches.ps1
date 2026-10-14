param(
    [string]$TargetOrg = 'TalentDev'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$sf = Join-Path $projectRoot 'tools\sf.ps1'

$batches = @(
    @{
        Name = 'A - Foundation'
        Manifest = 'manifest\batch-a-foundation.xml'
        TestLevel = 'RunSpecifiedTests'
        Tests = @('CandidateIdentityGuardTest')
        DataCheck = 'scripts\apex\validate-batch-a.apex'
    },
    @{
        Name = 'B - Recruitment'
        Manifest = 'manifest\batch-b-recruitment.xml'
        TestLevel = 'NoTestRun'
        Tests = @()
        DataCheck = 'scripts\apex\validate-batch-b.apex'
    },
    @{
        Name = 'C - Selection and onboarding'
        Manifest = 'manifest\batch-c-selection-onboarding.xml'
        TestLevel = 'NoTestRun'
        Tests = @()
    },
    @{
        Name = 'D - AI and matching'
        Manifest = 'manifest\batch-d-ai-matching.xml'
        TestLevel = 'RunSpecifiedTests'
        Tests = @('ResumeAiServiceTest')
    },
    @{
        Name = 'E - Talent'
        Manifest = 'manifest\batch-e-talent.xml'
        TestLevel = 'NoTestRun'
        Tests = @()
    },
    @{
        Name = 'F - Succession'
        Manifest = 'manifest\batch-f-succession.xml'
        TestLevel = 'NoTestRun'
        Tests = @()
    }
)

Push-Location $projectRoot
try {
    foreach ($batch in $batches) {
        Write-Host "Validating $($batch.Name)..."

        $arguments = @(
            'project', 'deploy', 'start',
            '--dry-run',
            '--target-org', $TargetOrg,
            '--manifest', $batch.Manifest,
            '--test-level', $batch.TestLevel,
            '--wait', '30',
            '--json'
        )

        foreach ($test in $batch.Tests) {
            $arguments += @('--tests', $test)
        }

        $rawResult = (& $sf @arguments | Out-String)
        $jsonStart = $rawResult.IndexOf('{')
        if ($jsonStart -lt 0) {
            throw "$($batch.Name) did not return a JSON deployment result."
        }

        $deployment = $rawResult.Substring($jsonStart) | ConvertFrom-Json
        if ($deployment.status -ne 0 -or $deployment.result.status -ne 'Succeeded') {
            throw "$($batch.Name) failed. Deployment ID: $($deployment.result.id)"
        }

        Write-Host "Passed $($batch.Name): $($deployment.result.id)"

        if ($batch.DataCheck) {
            $rawApexResult = (& $sf apex run --target-org $TargetOrg --file $batch.DataCheck --json | Out-String)
            $apexJsonStart = $rawApexResult.IndexOf('{')
            if ($apexJsonStart -lt 0) {
                throw "$($batch.Name) data check did not return JSON."
            }

            $apexResult = $rawApexResult.Substring($apexJsonStart) | ConvertFrom-Json
            if ($apexResult.status -ne 0 -or -not $apexResult.result.success) {
                throw "$($batch.Name) rollback data check failed."
            }

            Write-Host "Passed $($batch.Name) rollback data check."
        }
    }

    Write-Host 'All Phase 3 batches passed in dependency order.'
} finally {
    Pop-Location
}
