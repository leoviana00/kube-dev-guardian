```powershell
#requires -Version 5.1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Kube Dev Guardian - Kind Setup" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

$InstallDir = Join-Path $HOME "bin"
$KindPath = Join-Path $InstallDir "kind.exe"

# ---------------------------------------------------------
# 1. Validate Docker
# ---------------------------------------------------------

Write-Host "[1/5] Validando Docker..." -ForegroundColor Cyan

if ($null -eq (Get-Command docker -ErrorAction SilentlyContinue)) {

    Write-Host "Docker nao encontrado." -ForegroundColor Red
    Write-Host "Instale/inicie o Docker Desktop antes de continuar." -ForegroundColor Yellow

    exit 1
}

try {

    docker version | Out-Null

}
catch {

    Write-Host "Docker foi encontrado, mas nao esta acessivel." -ForegroundColor Red
    exit 1
}

Write-Host "Docker OK." -ForegroundColor Green

# ---------------------------------------------------------
# 2. Architecture
# ---------------------------------------------------------

Write-Host ""
Write-Host "[2/5] Verificando arquitetura..." -ForegroundColor Cyan

if ($env:PROCESSOR_ARCHITECTURE -ne "AMD64") {

    Write-Host "Arquitetura nao suportada: $env:PROCESSOR_ARCHITECTURE" -ForegroundColor Red

    exit 1
}

Write-Host "Windows AMD64 detectado." -ForegroundColor Green

# ---------------------------------------------------------
# 3. Get latest Kind version
# ---------------------------------------------------------

Write-Host ""
Write-Host "[3/5] Consultando ultima versao do Kind..." -ForegroundColor Cyan

$Headers = @{
    "User-Agent" = "kube-dev-guardian"
}

try {

    $Release = Invoke-RestMethod `
        -Uri "https://api.github.com/repos/kubernetes-sigs/kind/releases/latest" `
        -Headers $Headers

}
catch {

    Write-Host "Falha ao consultar GitHub." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1
}

$Version = $Release.tag_name

if ([string]::IsNullOrWhiteSpace($Version)) {

    Write-Host "Nao foi possivel identificar a versao do Kind." -ForegroundColor Red

    exit 1
}

Write-Host "Versao encontrada: $Version" -ForegroundColor Green

# ---------------------------------------------------------
# 4. Download
# ---------------------------------------------------------

Write-Host ""
Write-Host "[4/5] Baixando Kind..." -ForegroundColor Cyan

New-Item `
    -ItemType Directory `
    -Force `
    -Path $InstallDir |
    Out-Null

$DownloadUrl = "https://kind.sigs.k8s.io/dl/$Version/kind-windows-amd64"

$TempFile = Join-Path $env:TEMP "kind.exe"

Write-Host "URL:"
Write-Host $DownloadUrl

try {

    Invoke-WebRequest `
        -Uri $DownloadUrl `
        -OutFile $TempFile `
        -UseBasicParsing

}
catch {

    Write-Host "Falha ao baixar Kind." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1
}

Copy-Item `
    -Path $TempFile `
    -Destination $KindPath `
    -Force

Remove-Item `
    -Path $TempFile `
    -Force `
    -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Kind instalado em:" -ForegroundColor Green
Write-Host $KindPath

# ---------------------------------------------------------
# 5. Configure PATH
# ---------------------------------------------------------

Write-Host ""
Write-Host "[5/5] Configurando PATH..." -ForegroundColor Cyan

$UserPath = [Environment]::GetEnvironmentVariable(
    "Path",
    "User"
)

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

# Atualiza PATH da sessao atual
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

if (Test-Path $KindPath) {

    Write-Host "Kind instalado com sucesso." -ForegroundColor Green

    & $KindPath version

}
else {

    Write-Host "Kind nao encontrado." -ForegroundColor Red

    exit 1
}

Write-Host ""
Write-Host "Setup do Kind concluido." -ForegroundColor Green
Write-Host ""
```
