<# Base64 編碼 - String #>
$strData = "a"
$bytesTmp = [System.Text.Encoding]::UTF8.GetBytes($strData)
[Convert]::ToBase64String($bytesTmp)


<# Base64 解碼 - String #>
$strData = "YQ=="
$bytesTmp = [Convert]::FromBase64String($strData)
[System.Text.Encoding]::UTF8.GetString($bytesTmp)

<# Base64 編碼 - File(size ≦ 2G) #>
$srcfileName = "D:\Temp\msinfo32.zip"
$bytesTmp = [System.IO.File]::ReadAllBytes($srcfileName)
$base64String = [Convert]::ToBase64String($bytesTmp)

$base64String | Out-File .\output.txt

<# Base64 解碼 - File(size ≦ 2G) #>
# $base64String = ""
$destFileName = "D:\Temp\msinfo32.txt"
$bytesTmp = [Convert]::FromBase64String($base64String)
[System.IO.File]::WriteAllBytes($destFileName, $bytesTmp)
