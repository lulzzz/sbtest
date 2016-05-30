# 1. Create database

$databases = $DatabasesToDeploy.Split(",");

foreach($database in $databases) {
	& ".\HrMaxx.Infrastructure.Database.exe" $database | Write-Host	
}

# --------------------------------------------------------------