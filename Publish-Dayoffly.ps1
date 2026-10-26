# Dayoffly portable publisher. Run from any PowerShell working directory.
$ErrorActionPreference = 'Stop'
$repo = 'https://github.com/Donacgreece/dayoffly.app.git'
$release = $PSScriptRoot
$work = Join-Path ([System.IO.Path]::GetTempPath()) ('dayoffly-publish-' + [Guid]::NewGuid().ToString('N'))
$clone = Join-Path $work 'repo'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git for Windows not found. Install Git and try again.' }
if (-not (Test-Path (Join-Path $release 'index.html'))) { throw 'Cannot find index.html beside this script. Extract the entire ZIP first.' }

New-Item -ItemType Directory -Path $work -Force | Out-Null
try {
    Write-Host 'Cloning latest Dayoffly repository...' -ForegroundColor Cyan
    & git clone --branch main --single-branch $repo $clone
    if ($LASTEXITCODE -ne 0) { throw 'Git clone failed. Check your internet connection and access rights.' }

    # Copy the release, without overwriting Git internals or carrying a custom domain.
    $excludeFiles = @('CNAME','Publish-Dayoffly.ps1','Update-Dayoffly-v0.0.2.ps1')
    Get-ChildItem -LiteralPath $release -Force | Where-Object { $_.Name -ne '.git' -and ($excludeFiles -notcontains $_.Name) } | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $clone -Recurse -Force
    }
    $cname = Join-Path $clone 'CNAME'
    if (Test-Path $cname) { Remove-Item -LiteralPath $cname -Force }
    # GitHub includes the portable publisher in the repository for future releases.
    Copy-Item -LiteralPath (Join-Path $release 'Publish-Dayoffly.ps1') -Destination (Join-Path $clone 'Publish-Dayoffly.ps1') -Force

    Push-Location $clone
    try {
        & git add -A
        if ($LASTEXITCODE -ne 0) { throw 'Git add failed.' }
        & git diff --cached --quiet
        $diffStatus = $LASTEXITCODE
        if ($diffStatus -eq 0) { Write-Host 'The repository is already up to date.' -ForegroundColor Green; return }
        if ($diffStatus -ne 1) { throw 'Unable to compare staged changes.' }
        & git -c user.name='Dayoffly Release' -c user.email='dayoffly-release@users.noreply.github.com' commit -m 'Release Dayoffly v0.0.3: social preview, README and portable deployment'
        if ($LASTEXITCODE -ne 0) { throw 'Git commit failed.' }
        & git push origin main
        if ($LASTEXITCODE -ne 0) { throw 'Git push failed. Confirm GitHub authentication or retry after remote updates.' }
        Write-Host 'Dayoffly v0.0.3 successfully published to GitHub!' -ForegroundColor Green
        Write-Host 'Site: https://donacgreece.github.io/dayoffly.app/'
        Write-Host 'Actions: https://github.com/Donacgreece/dayoffly.app/actions'
    } finally { Pop-Location }
} finally {
    if (Test-Path $work) { Remove-Item -LiteralPath $work -Force -Recurse -ErrorAction SilentlyContinue }
}
