$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Kube Dev Guardian - Maven Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$MavenVersion = "3.9.16"
$MavenUrl = "https://dlcdn.apache.org/maven/maven-3/$MavenVersion/binaries/apache-maven-$MavenVersion-bin.zip"

$InstallRoot = Join-Path $env:USERPROFILE "bin"
$MavenHome = Join-Path $InstallRoot "apache-maven-$MavenVersion"
$MavenBin = Join-Path $MavenHome "bin"
$ZipPath = Join-Path $env:TEMP "apache-maven-$MavenVersion-bin.zip"

Write-Host "[1/5] Checking Java..." -ForegroundColor Yellow

java -version

if ($LASTEXITCODE -ne 0) {
throw "Java was not found."
}

Write-Host ""
Write-Host "[2/5] Preparing installation directory..." -ForegroundColor Yellow

if (-not (Test-Path $InstallRoot)) {
New-Item -ItemType Directory -Path $InstallRoot | Out-Null
}

Write-Host ""
Write-Host "[3/5] Downloading Maven $MavenVersion..." -ForegroundColor Yellow
Write-Host $MavenUrl

if (Test-Path $ZipPath) {
Remove-Item $ZipPath -Force
}

Invoke-WebRequest -Uri $MavenUrl -OutFile $ZipPath

if (-not (Test-Path $ZipPath)) {
throw "Maven download failed."
}

Write-Host "Download completed." -ForegroundColor Green

Write-Host ""
Write-Host "[4/5] Extracting Maven..." -ForegroundColor Yellow

if (Test-Path $MavenHome) {
Remove-Item $MavenHome -Recurse -Force
}

Expand-Archive -Path $ZipPath -DestinationPath $InstallRoot -Force

if (-not (Test-Path $MavenBin)) {
throw "Maven extraction failed."
}

Write-Host "Maven extracted successfully." -ForegroundColor Green

Write-Host ""
Write-Host "[5/5] Configuring environment..." -ForegroundColor Yellow

[Environment]::SetEnvironmentVariable("MAVEN_HOME", $MavenHome, "User")

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ([string]::IsNullOrWhiteSpace($UserPath)) {
$PathEntries = @()
}
else {
$PathEntries = $UserPath -split ";" | Where-Object {
-not [string]::IsNullOrWhiteSpace($_)
}
}

if ($PathEntries -notcontains $MavenBin) {
$PathEntries += $MavenBin
}

$NewPath = $PathEntries -join ";"

[Environment]::SetEnvironmentVariable("Path", $NewPath, "User")

$env:MAVEN_HOME = $MavenHome
$env:Path = "$MavenBin;$env:Path"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " Maven installed successfully" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Maven Home:"
Write-Host $MavenHome

Write-Host ""
Write-Host "Maven version:"
mvn -version

Write-Host ""
Write-Host "Maven executable:"
where.exe mvn

Write-Host ""
