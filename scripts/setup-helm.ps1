#requires -Version 5.1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Kube Dev Guardian - Helm Setup" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

$InstallDir = Join-Path $HOME "bin"
$TempDir = Join-Path $env:TEMP "kube-dev-guardian-helm"

# ---------------------------------------------------------
# 1. Check architecture
# ---------------------------------------------------------

Write-Host "[1/5] Verificando arquitetura..." -ForegroundColor Cyan

if ($env:PROCESSOR_ARCHITECTURE -ne "AMD64") {
    Write-Host "Arquitetura nao suportada: $env:PROCESSOR_ARCHITECTURE" -ForegroundColor Red
    exit 1
}

Write-Host "Windows AMD64 detectado." -ForegroundColor Green

# ---------------------------------------------------------
# 2. Get latest version
# ---------------------------------------------------------

Write-Host ""
Write-Host "[2/5] Consultando ultima versao do Helm..." -ForegroundColor Cyan

$Headers = @{
    "User-Agent" = "kube-dev-guardian"
}

$Release = Invoke-RestMethod `
    -Uri "https://api.github.com/repos/helm/helm/releases/latest" `
    -Headers $Headers

$Version = $Release.tag_name

if ([string]::IsNullOrWhiteSpace($Version)) {
    Write-Host "Nao foi possivel identificar a versao." -ForegroundColor Red
    exit 1
}

Write-Host "Versao: $Version" -ForegroundColor Green

# ---------------------------------------------------------
# 3. Prepare directories
# ---------------------------------------------------------

Write-Host ""
Write-Host "[3/5] Preparando diretorios..." -ForegroundColor Cyan

New-Item `
    -ItemType Directory `
    -Force `
    -Path $InstallDir |
    Out-Null

if (Test-Path $TempDir) {
    Remove-Item `
        -Recurse `
        -Force `
        $TempDir
}

New-Item `
    -ItemType Directory `
    -Force `
    -Path $TempDir |
    Out-Null

# ---------------------------------------------------------
# 4. Download Helm
# ---------------------------------------------------------

Write-Host ""
Write-Host "[4/5] Baixando Helm..." -ForegroundColor Cyan

$FileName = "helm-$Version-windows-amd64.zip"

$DownloadUrl = "https://get.helm.sh/$FileName"

$ZipFile = Join-Path $TempDir $FileName

Write-Host "URL:"
Write-Host $DownloadUrl

try {

    Invoke-WebRequest `
        -Uri $DownloadUrl `
        -OutFile $ZipFile `
        -UseBasicParsing

}
catch {

    Write-Host ""
    Write-Host "Falha ao baixar o Helm." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1
}

Write-Host "Download concluido." -ForegroundColor Green

# ---------------------------------------------------------
# Extract
# ---------------------------------------------------------

Write-Host ""
Write-Host "Extraindo Helm..." -ForegroundColor Cyan

$ExtractDir = Join-Path $TempDir "extracted"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $ExtractDir |
    Out-Null

Expand-Archive `
    -Path $ZipFile `
    -DestinationPath $ExtractDir `
    -Force

$HelmExecutable = Get-ChildItem `
    -Path $ExtractDir `
    -Filter "helm.exe" `
    -Recurse |
    Select-Object -First 1

if ($null -eq $HelmExecutable) {

    Write-Host "helm.exe nao encontrado." -ForegroundColor Red
    exit 1
}

$Target = Join-Path $InstallDir "helm.exe"

Copy-Item `
    -Path $HelmExecutable.FullName `
    -Destination $Target `
    -Force

Write-Host "Helm instalado em:" -ForegroundColor Green
Write-Host $Target

# ---------------------------------------------------------
# 5. Configure PATH
# ---------------------------------------------------------

Write-Host ""
Write-Host "[5/5] Configurando PATH..." -ForegroundColor Cyan

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ([string]::IsNullOrWhiteSpace($UserPath)) {
    $UserPath = ""
}

$PathEntries = $UserPath -split ";" |
    Where-Object {
        -not [string]::IsNullOrWhiteSpace($_)
    }

$AlreadyExists = $PathEntries |
    Where-Object {
        $_.TrimEnd("\") -ieq $InstallDir.TrimEnd("\")
    }

if (-not $AlreadyExists) {

    $NewPath = if ($UserPath) {
        "$UserPath;$InstallDir"
    }
    else {
        $InstallDir
    }

    [Environment]::SetEnvironmentVariable(
        "Path",
        $NewPath,
        "User"
    )

    Write-Host "PATH atualizado." -ForegroundColor Green

}
else {

    Write-Host "PATH ja configurado." -ForegroundColor Yellow
}

# Atualizar PATH da sessão atual
if ($env:Path -notlike "*$InstallDir*") {
    $env:Path = "$env:Path;$InstallDir"
}

# ---------------------------------------------------------
# Validation
# ---------------------------------------------------------

Write-Host ""
Write-Host "==============================================" -ForegroundColor Green
Write-Host " Validacao" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
Write-Host ""

if (Test-Path $Target) {

    Write-Host "helm.exe encontrado." -ForegroundColor Green

    & $Target version

}
else {

    Write-Host "helm.exe nao encontrado." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Helm instalado com sucesso!" -ForegroundColor Green
Write-Host ""

