#get the list of files in the original folder
$rootFolder = "G:\Paxol Backups\Daily Db"
$googleDrive = "G:\Paxol Backups\GDrive\PaxolDbBackups"



#create a temporary folder using today's date

$date = Get-Date
$date = $date.ToString("MMddyyyy")

$CompressionToUse = [System.IO.Compression.CompressionLevel]::Optimal
$IncludeBaseFolder = $false
$zipTo = "{0}\PaxolDB_{1}.zip" -f $googleDrive,$date

#add the files in the temporary location to a zip folder
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )
[System.IO.Compression.ZipFile]::CreateFromDirectory($rootFolder, $ZipTo, $CompressionToUse, $IncludeBaseFolder)
<#
Remove-Item $rootFolder -RECURSE

move the files to a temporary location
$timespan = new-timespan -days 1
$files = Get-ChildItem -Path $googleDrive 
foreach($file in $files)
{
	$fileLastModifieddate = $file.LastWriteTime
	if(((Get-Date) - $fileLastModifiedDate) -lt $timespan)
	{
		Remove-Item "$googleDrive\$file"
	}
}
#>