param(
    [string] $SqlPassword
)

Write-Host "=== Configuring SQL ==="

$sql = @"
IF DB_ID('InnovatorSolutions') IS NULL
BEGIN
    CREATE DATABASE InnovatorSolutions;
END

IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'innovator')
BEGIN
    CREATE LOGIN innovator WITH PASSWORD='$SqlPassword';
END

USE InnovatorSolutions;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'innovator')
BEGIN
    CREATE USER innovator FOR LOGIN innovator;
    EXEC sp_addrolemember 'db_owner', 'innovator';
END
"@

Invoke-Sqlcmd -Query $sql -ServerInstance "localhost" -ErrorAction Stop

Write-Host "=== SQL Configuration Complete ==="
