param(
    [Parameter(Mandatory=$false)]
    [string]$ApiKey = "YOUR_API_KEY"
)

if (-not $ApiKey) {
    Write-Host "Please provide an API key"
    exit 1
}

$url = "https://api.nasa.gov/planetary/apod?api_key=$ApiKey"
$response = Invoke-RestMethod -Uri $url

Write-Host "Title: $($response.title)"
Write-Host "Explanation: $($response.explanation)"

if ($response.media_type -eq 'image') {
    Write-Host "Image URL: $($response.url)"

    # Display the image using the System.Drawing namespace
    Add-Type -AssemblyName System.Drawing

    try {
        $client = New-Object System.Net.WebClient
        $imageData = $client.DownloadData($response.url)
        [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::new($imageData))
    } catch {
        Write-Host "Failed to download the image: $_"
    }

} 
else {
    Write-Host "Media type is not an image"
}