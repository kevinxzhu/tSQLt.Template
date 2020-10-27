$connectionString = "Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CIFinanceApp;Integrated Security=True;Persist Security Info=False;Pooling=False;MultipleActiveResultSets=False;Connect Timeout=60;Encrypt=False;TrustServerCertificate=False"

$sqlCommand = 'BEGIN TRY EXEC tSQLt.RunAll END TRY BEGIN CATCH END CATCH; EXEC tSQLt.XmlResultFormatter'

$connection = new-object system.data.SqlClient.SQLConnection($connectionString)
$command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
$connection.Open()

$adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
$dataset = New-Object System.Data.DataSet
$adapter.Fill($dataSet) | Out-Null

$connection.Close()
#$currentPath = Join-Path (Get-Item .).FullName "/testresults.xml"
$currentPath = (Get-Item .).FullName + "/testresults.xml"
Write-Output $currentPath
$dataSet.Tables[0].Rows[0].ItemArray[0] | Out-File $currentPath
