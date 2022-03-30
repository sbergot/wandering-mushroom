$Root = $PSScriptRoot

$InformationPreference = "Continue"
$template = Get-Content "$Root/template.html"
$outputFolder = "$Root\output"
$TextInfo = (Get-Culture).TextInfo


if (Test-Path $outputFolder) {
	Remove-Item -Path $outputFolder -Force -Recurse
}

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

New-Item -Path $outputFolder -ItemType "directory" -Force

Get-ChildItem "$Root\raw\*.html" | % {
    Write-Information "Processing $_"
    $nested = "$outputFolder\$($_.BaseName)"
    New-Item -Path $nested -ItemType "directory" -Force
    Replace-Content $_ > "$nested\index.html"
} 

Copy-Item "$Root\resources\*" $outputFolder