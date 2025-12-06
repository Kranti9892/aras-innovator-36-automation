param(
    [string]$SqlInstance = ".\MSSQLSERVER",
    [string]$SaPassword
)

Write-Host "Creating Innovator DB..."

$sqlFile = "C:\temp\create_innovator_db.sql"

@"
CREATE DATABASE Innovator36;
GO
"@ | Out-File $sqlFile -Encoding ASCII

Invoke-Expression "sqlcmd -S $SqlInstance -U sa -P `"$SaPassword`" -i $sqlFile"

Write-Host "Database created successfully!"
