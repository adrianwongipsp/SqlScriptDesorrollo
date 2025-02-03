$url = "http://192.168.1.171:2030"
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    Write-Output "Pinged $url - Status Code: $($response.StatusCode)"
}
catch {
    Write-Output ("Error pinging " + $url + ": " + $_.Exception.Message)
}
