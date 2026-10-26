# Dayoffly v0.0.1 – publish the contents of this folder to the GitHub repository.
# Requires Git for Windows and permission to push to Donacgreece/dayoffly.app.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Install Git for Windows first: https://git-scm.com/download/win' }
if (-not (Test-Path '.git')) { git init -b main; if ($LASTEXITCODE -ne 0) { throw 'git init failed' } }
$origin = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) { git remote add origin 'https://github.com/Donacgreece/dayoffly.app.git' }
elseif ($origin -ne 'https://github.com/Donacgreece/dayoffly.app.git') { throw "Unexpected origin: $origin" }
git add -A
if ($LASTEXITCODE -ne 0) { throw 'git add failed' }
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) { git commit -m 'Release Dayoffly v0.0.1'; if ($LASTEXITCODE -ne 0) { throw 'git commit failed. Configure your Git username/email.' } }
git branch -M main
if ($LASTEXITCODE -ne 0) { throw 'Could not select main branch' }
git push -u origin main
if ($LASTEXITCODE -ne 0) { throw 'Push failed. Sign into GitHub and retry.' }
Write-Host 'Dayoffly v0.0.1 pushed successfully.' -ForegroundColor Green
Write-Host 'Next: Repository Settings > Pages > Build and deployment > GitHub Actions.'
