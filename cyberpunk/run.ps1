$Root = $PSScriptRoot

$InformationPreference = "Continue"
$template = Get-Content "$Root/template.html"
$outputFolder = "$Root\output"
$TextInfo = (Get-Culture).TextInfo

function Replace-Content ($file) {
    $name = $file.BaseName
    $title = $name -replace '-',' '
    $title = $TextInfo.ToTitleCase($title)
    $content = Get-Content $file
    $content = $content -replace 'style="text-decoration:underline;"',''
    $output = $template -replace '%body%',$content
    $output = $output -replace '%title%',$title
    $output = $output -replace '%name%',$name
    return $output
}

if (!(Test-Path $outputFolder)) {
	New-Item -Path $outputFolder -ItemType "directory" -Force
}

Get-ChildItem "$Root\raw\*.html" | % {
    Write-Information "Processing $_"
    Replace-Content $_ > "$outputFolder\$($_.Name)"
} 

Copy-Item "$Root\resources\*" $outputFolder