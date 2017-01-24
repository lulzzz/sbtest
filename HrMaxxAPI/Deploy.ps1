#See http://www.iis.net/learn/manage/powershell/powershell-snap-in-creating-web-sites-web-applications-virtual-directories-and-application-pools

# 1. Web Installation
#---------------
Import-Module WebAdministration

$appPoolName = $ApplicationPoolName
$siteName = $WebSiteName
$appPoolFrameworkVersion = "v4.0"
$webRoot = [System.IO.Directory]::GetCurrentDirectory()

Write-Host "WebRoot is " + $webRoot

cd IIS:\


# App pool
#---------------
Write-Host "Application Pool Name: " + $appPoolName
$appPoolPath = ("IIS:\AppPools\" + $appPoolName)
$pool = Get-Item $appPoolPath -ErrorAction SilentlyContinue
if (!$pool) {
Write-Host "App pool does not exist, creating..."
new-item $appPoolPath
$pool = Get-Item $appPoolPath

Write-Host "Set .NET framework version:" $appPoolFrameworkVersion
Set-ItemProperty $appPoolPath managedRuntimeVersion $appPoolFrameworkVersion

#Write-Host "Set identity..."
#Set-ItemProperty $appPoolPath -name processModel -value @{identitytype="cmd\giig"}
} else {
Write-Host "App pool exists."
}
#---------------

# Site
#---------------
Write-Host "Checking site: " + $siteName
$sitePath = ("IIS:\Sites\Default Web Site\" + $siteName)
$site = Get-Item $sitePath -ErrorAction SilentlyContinue
if (!$site) {
Write-Host "Site does not exist, creating..."
new-item $sitePath -physicalPath $webRoot -type Application
} else {
Set-ItemProperty $sitePath -name physicalPath -value $webRoot
Write-Host "Site exists. Complete"
}

Write-Host "Set app pool..."
Set-ItemProperty $sitePath -name applicationPool -value $appPoolName

Write-Host "IIS configuration complete!"


# 2. Create various required directories and set permissions
#---------------
cd $webRoot

$permission = "Everyone","FullControl","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission

Try
{
rmdir .\logs -ErrorAction SilentlyContinue
}
Catch
{
}

mkdir .\logs

$acl = Get-Acl .\logs

$acl.SetAccessRule($accessRule)
$acl | Set-Acl .\logs

# --------------------------------------------------------------