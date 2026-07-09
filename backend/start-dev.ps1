param(
    [switch]$NoDbInit,
    [switch]$NoGateway
)

$ErrorActionPreference = "Continue"

$services = @(
    @{ Name = "auth-service";      Port = 8081; Db = "auth_db";         Schema = "db\schema.sql" },
    @{ Name = "user-service";      Port = 8082; Db = "user_db";         Schema = "db\schema.sql" },
    @{ Name = "post-service";      Port = 8083; Db = "post_db";         Schema = "db\schema.sql" },
    @{ Name = "media-service";     Port = 8084; Db = "media_db";        Schema = $null },
    @{ Name = "chat-service";      Port = 8085; Db = "chat_db";         Schema = "db\schema.sql" },
    @{ Name = "notification-service"; Port = 8086; Db = "notification_db"; Schema = "db\schema.sql" }
)

$root = Split-Path -Parent $PSScriptRoot
$backend = $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Aura Backend - Start All Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------
# 1. Database setup
# -----------------------------------------------------------
if (-not $NoDbInit) {
    Write-Host "[1/2] Setting up PostgreSQL databases..." -ForegroundColor Yellow

    foreach ($svc in $services) {
        $db = $svc.Db
        if (-not $db) { continue }

        Write-Host "  Checking database '$db'..." -NoNewline
        $exists = & psql -U aura_user -h localhost -t -c "SELECT 1 FROM pg_database WHERE datname='$db'" 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host " CANNOT CONNECT to PostgreSQL" -ForegroundColor Red
            Write-Host "  Make sure PostgreSQL is running and connection works:"
            Write-Host "    psql -U aura_user -h localhost"
            Write-Host "  Default credentials in application.yml: aura_user / aura_pass123"
            Write-Host ""
            continue
        }

        if ([string]::IsNullOrWhiteSpace($exists)) {
            & psql -U aura_user -h localhost -c "CREATE DATABASE $db" 2>$null
            Write-Host " CREATED" -ForegroundColor Green
        } else {
            Write-Host " EXISTS" -ForegroundColor Gray
        }

        # Run schema
        $schemaPath = Join-Path $backend $svc.Name "src\main\resources\$($svc.Schema)"
        if (Test-Path $schemaPath) {
            Write-Host "    Running schema for '$db'..." -NoNewline
            & psql -U aura_user -h localhost -d $db -f $schemaPath 2>$null
            Write-Host " DONE" -ForegroundColor Green
        }
    }

    Write-Host ""
} else {
    Write-Host "[1/2] Skipping database setup (-NoDbInit)" -ForegroundColor Gray
}

# -----------------------------------------------------------
# 2. Start services
# -----------------------------------------------------------
Write-Host "[2/2] Starting microservices..." -ForegroundColor Yellow
Write-Host ""

$pids = @()

foreach ($svc in $services) {
    $name = $svc.Name
    $port = $svc.Port
    $dir = Join-Path $backend $name

    Write-Host "  Starting $name on port $port..." -NoNewline

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoExit -Command `"cd '$dir'; mvn spring-boot:run`"
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Normal
    $startInfo.UseShellExecute = $true

    try {
        $p = [System.Diagnostics.Process]::Start($startInfo)
        $pids += $p.Id
        Write-Host " OK (PID: $($p.Id))" -ForegroundColor Green
    } catch {
        Write-Host " FAILED: $_" -ForegroundColor Red
    }
}

if (-not $NoGateway) {
    Write-Host ""
    Write-Host "  Starting api-gateway on port 8080..." -NoNewline

    $gatewayDir = Join-Path $backend "api-gateway"
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoExit -Command `"cd '$gatewayDir'; mvn spring-boot:run`"
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Normal
    $startInfo.UseShellExecute = $true

    try {
        $p = [System.Diagnostics.Process]::Start($startInfo)
        $pids += $p.Id
        Write-Host " OK (PID: $($p.Id))" -ForegroundColor Green
    } catch {
        Write-Host " FAILED: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  All services starting..." -ForegroundColor Cyan
Write-Host "  API Gateway: http://localhost:8080" -ForegroundColor White
Write-Host "  Close service windows to stop." -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan

# Keep this script alive so the user can Ctrl+C to kill all
Write-Host ""
Write-Host "Press Ctrl+C to stop all services..." -ForegroundColor Gray
try {
    while ($true) { Start-Sleep -Seconds 1 }
} finally {
    Write-Host "Stopping services..."
    foreach ($pid in $pids) {
        try { Stop-Process -Id $pid -Force } catch {}
    }
}
