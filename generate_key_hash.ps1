# PowerShell script to generate Facebook key hash
$keystorePath = "$env:USERPROFILE\.android\debug.keystore"
$tempCertFile = "$env:TEMP\debug_cert.crt"

# Export certificate
keytool -exportcert -alias androiddebugkey -keystore $keystorePath -storepass android -keypass android -file $tempCertFile

if (Test-Path $tempCertFile) {
    # Read the certificate file and generate SHA1 hash
    $certBytes = [System.IO.File]::ReadAllBytes($tempCertFile)
    $sha1 = [System.Security.Cryptography.SHA1]::Create()
    $hashBytes = $sha1.ComputeHash($certBytes)
    $base64Hash = [System.Convert]::ToBase64String($hashBytes)
    
    Write-Host "Facebook Key Hash: $base64Hash"
    
    # Clean up
    Remove-Item $tempCertFile -ErrorAction SilentlyContinue
} else {
    Write-Host "Failed to export certificate"
}
