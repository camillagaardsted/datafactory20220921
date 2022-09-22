# PowerShell - vi kan scripte enten onprem som her i ISE (editor) eller vi kan gøre det i shell.azure.com

Install-Module az

Get-module -ListAvailable az*

Connect-AzAccount

# den anden mulighed for at scripte er via et specielt værktøj som hedder AzCLI

# vi loggede på 2 gange fordi scriptet anvender både azCLI og powershell

# vi kan deploye ressourcer via Gui i portalen, via scripts eller via ARM template (Azure Resource Manager)

# vi har fået template fil og parameter fil fra portalen

$resourceGroup='dk'
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -Name Datalakeoprettelse -TemplateFile C:\DP203Kursus\templateDatalakeRessource\template.json -TemplateParameterFile C:\DP203Kursus\templateDatalakeRessource\parameters.json

Get-AzStorageAccount

$ressourceGroup='dk'
$location='westeurope'
$dato = Get-Date -Format "yyyyMMdd"
        
New-AzResourceGroup -location $location -Name $ressourceGroup

#max 24 tegn
$storageAccountName="storageaccountsu$dato"
New-AzStorageAccount -ResourceGroupName $ressourceGroup -Name $storageAccountName -Location $location -Kind StorageV2 -SkuName Standard_GRS -AccessTier Cool

$DataLakeName="datalake$dato"
New-AzStorageAccount -Name $DataLakeName -SkuName Standard_LRS -ResourceGroupName $ressourceGroup -Location $location -Kind StorageV2 -AccessTier Cool -EnableHierarchicalNamespace $true

# upload some data 
$storageAccount=Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $ressourceGroup

$blobcontainerName='blobcontainer'
New-AzStorageContainer -Name $blobcontainerName -Context $storageAccount.Context -Permission Container

# upload some files
$folder="C:\DP203Kursus\data\images"
Set-Location $folder

$year=(Get-Date).Year
$month=Get-date -Format "MMMM"

Set-AzStorageBlobContent -File .\mtb.jpg -Container $blobcontainerName -BlobType Block -Context $storageAccount.Context -blob "images\products\$year\$month\mtb.jpg"
Set-AzStorageBlobContent -File .\forgaffel.jpg -Container $blobcontainerName -BlobType Block -Context $storageAccount.Context -StandardBlobTier hot -Blob "images\products\$year\$month\forgaffel.jpg"


# upload some data 
$storageAccount=Get-AzStorageAccount -Name $DataLakeName -ResourceGroupName $ressourceGroup

$datalakecontainerName='datalakecontainer'
New-AzStorageContainer -Name $datalakecontainerName -Context $storageAccount.Context -Permission Container

# upload some files
$folder="C:\DP203Kursus\data\aidata"
Set-Location $folder

$year=(Get-Date).Year
$month=Get-date -Format "MMMM"

$files= dir -File
foreach ($file in $files){
    $fileName=$file.Name
    Set-AzStorageBlobContent -File $fileName -Container $datalakecontainerName -BlobType Block -Context $storageAccount.Context -blob "aidata\information\$year\$month\$fileName"
}


# list blobcontainer content
$storageAccount=Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $ressourceGroup
Get-AzStorageBlob -Container $blobcontainerName -Context $storageAccount.Context | select name


# az cli kommando:
# az storage account list --query '[].{Name:name}' --output table

# list datalake container content

$storageAccount=Get-AzStorageAccount -Name $DataLakeName -ResourceGroupName $ressourceGroup
Get-AzStorageBlob -Container $datalakecontainerName -Context $storageAccount.Context |select name

# rasp
$storageAccount=Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name datalakesu20220919
$datalakecontainerName='raspdata'
Get-AzStorageBlob -Container $datalakecontainerName -Context $storageAccount.Context |where name -like *csv | measure

# sensor=1984/year=2022/month=09/data2022_09_19_11_48_42.csv
Get-AzStorageBlob -Container $datalakecontainerName -Context $storageAccount.Context |where name -like *csv | select name

Get-AzStorageBlob -Container $datalakecontainerName -Context $storageAccount.Context  | select name

# Azure data explorer
# se https://azure.microsoft.com/en-us/products/storage/storage-explorer/
# under huden bruger den azcopy - det er et cmdline værktøj til kopiering af filer til azure

# Azure AD

Get-AzDomain


$pn = Get-AzDomain | select -ExpandProperty domains


$password="Pa55w.rd"
$passwordSecure=ConvertTo-SecureString -AsPlainText $password -Force

$username="otto"
$Name="Otto Pilfinger"
$upn = "$username@$pn"
$mailnickname="ottoregnskab"
$otto=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname

$username="ottoline"
$Name="Ottoline Pilfinger"
$upn = "$username@$pn"
$mailnickname="ottolinemarketing"
$ottoline=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname



$groupName="BI group"
$mailnickname="bigruppen"
$bigroup=New-AzADGroup -DisplayName $groupName -MailNickname $mailnickname 

Add-AzADGroupMember -TargetGroupDisplayName $groupName -MemberUserPrincipalName $otto.UserPrincipalName,$ottoline.UserPrincipalName

# IT folk:

$username="ivan"
$Name="Ivan IT"
$upn = "$username@$pn"
$mailnickname="ivanit"
$ivan=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname

$username="frode"
$Name="Frode Pilfinger"
$upn = "$username@$pn"
$mailnickname="frodeit"
$frode=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname

# Opret sikkerhedsgruppe til vores to IT folk
$groupName="IT group"
$mailnickname="itgruppen"
$bigroup=New-AzADGroup -DisplayName $groupName -MailNickname $mailnickname 

Add-AzADGroupMember -TargetGroupDisplayName $groupName -MemberUserPrincipalName $ivan.UserPrincipalName,$frode.UserPrincipalName


# Opret sikkerhedsgruppe til vores to IT folk
$groupName="DBA group"
$mailnickname="dbagruppen"
$dbagroup=New-AzADGroup -DisplayName $groupName -MailNickname $mailnickname 

Add-AzADGroupMember -TargetGroupDisplayName $groupName -MemberUserPrincipalName $upn

Connect-AzAccount

Get-AzADUser


Get-AzSqlServer

New-AzSqlDatabase -DatabaseName AdvCloud -SampleName AdventureWorksLT -ServerName sqlserver20220920 -Edition Basic -ResourceGroupName cloud-shell-storage-westeurope


Get-AzDomain


get-command -name Get-AzSynapse*script




