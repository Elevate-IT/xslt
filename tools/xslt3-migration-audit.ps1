param(
    [string]$Root = ".",
    [string]$OutputCsv = "xsl-out/xslt-v3-migration-audit.csv",
    [string]$OutputSummary = "xsl-out/xslt-v3-migration-summary.txt"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptPattern = '<\s*(msxsl|xsl):script\b'
$msxslPattern = 'xmlns:msxsl=|urn:schemas-microsoft-com:xslt|\bmsxsl:node-set\('
$scriptCallPattern = '\b(?<prefix>MyScript|userCSharp):(?<name>[A-Za-z_][\w\-]*)\s*\('
$versionPattern = '<xsl:stylesheet[^>]*\bversion\s*=\s*"(?<v>[^"]+)"'

$files = Get-ChildItem -Path $Root -Recurse -Filter *.xslt | Sort-Object FullName
if (-not $files) {
    Write-Host "No .xslt files found under $Root"
    exit 0
}

$rows = New-Object System.Collections.Generic.List[object]
$allFunctionCalls = New-Object System.Collections.Generic.List[string]

foreach ($file in $files) {
    $text = Get-Content -Path $file.FullName -Raw

    $scriptMatches = [regex]::Matches($text, $scriptPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $msxslMatches = [regex]::Matches($text, $msxslPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $callMatches = [regex]::Matches($text, $scriptCallPattern)
    $versionMatch = [regex]::Match($text, $versionPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $functionCalls = @($callMatches | ForEach-Object { "{0}:{1}" -f $_.Groups['prefix'].Value, $_.Groups['name'].Value })
    foreach ($fn in $functionCalls) {
        $allFunctionCalls.Add($fn)
    }

    $risk = "Low"
    if ($scriptMatches.Count -gt 0) {
        $risk = "High"
    }
    elseif ($msxslMatches.Count -gt 0) {
        $risk = "Medium"
    }

    $rows.Add([PSCustomObject]@{
        File = $file.FullName
        XsltVersion = if ($versionMatch.Success) { $versionMatch.Groups['v'].Value } else { "" }
        ScriptBlocks = $scriptMatches.Count
        UsesMsxslOrNodeSet = ($msxslMatches.Count -gt 0)
        ScriptFunctionCalls = ($functionCalls | Sort-Object -Unique) -join '; '
        HasThreadSleep = ($text -match 'Threading\.Thread\.Sleep\(')
        HasGuidNewGuid = ($text -match 'Guid\.NewGuid\(')
        HasStaticState = ($text -match '\bstatic\b|\bcounter\b|\bList<')
        MigrationRisk = $risk
    })
}

$csvDir = Split-Path -Path $OutputCsv -Parent
$summaryDir = Split-Path -Path $OutputSummary -Parent
if ($csvDir) { New-Item -ItemType Directory -Path $csvDir -Force | Out-Null }
if ($summaryDir) { New-Item -ItemType Directory -Path $summaryDir -Force | Out-Null }

$rows | Sort-Object MigrationRisk, File | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8

$total = $rows.Count
$high = @($rows | Where-Object { $_.MigrationRisk -eq 'High' }).Count
$medium = @($rows | Where-Object { $_.MigrationRisk -eq 'Medium' }).Count
$low = @($rows | Where-Object { $_.MigrationRisk -eq 'Low' }).Count

$topFunctions = $allFunctionCalls |
    Group-Object |
    Sort-Object Count -Descending |
    Select-Object -First 30

$summaryLines = New-Object System.Collections.Generic.List[string]
$summaryLines.Add("XSLT v3 migration audit")
$summaryLines.Add("Generated: $(Get-Date -Format s)")
$summaryLines.Add("")
$summaryLines.Add("Total files: $total")
$summaryLines.Add("High risk (embedded script): $high")
$summaryLines.Add("Medium risk (msxsl usage, no script block): $medium")
$summaryLines.Add("Low risk: $low")
$summaryLines.Add("")
$summaryLines.Add("Top script function calls:")
foreach ($entry in $topFunctions) {
    $summaryLines.Add(("{0}`t{1}" -f $entry.Count, $entry.Name))
}

$summaryLines | Set-Content -Path $OutputSummary -Encoding UTF8

Write-Host "Audit complete"
Write-Host "CSV: $OutputCsv"
Write-Host "Summary: $OutputSummary"
Write-Host "Total=$total High=$high Medium=$medium Low=$low"
