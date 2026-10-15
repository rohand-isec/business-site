# Fill in the business details. Run once from this folder:  powershell -ExecutionPolicy Bypass -File .\fill.ps1
# Your answers stay on this computer: the script only edits the files in this folder.
$v = [ordered]@{}
$v.BRAND_NAME       = Read-Host "Business name (exactly as in your email From name)"
$v.TAGLINE          = Read-Host "Short tagline (one line)"
$v.DOMAIN           = Read-Host "Website domain, e.g. example.com (no https://)"
$v.SEND_DOMAIN      = Read-Host "Sending domain, e.g. alerts.example.com"
$v.EMAIL            = Read-Host "Contact email on your domain, e.g. hello@example.com"
$v.CITY_COUNTRY     = Read-Host "City and country, e.g. Bengaluru, India"
$v.PHONE            = Read-Host "Business phone (leave empty to hide it)"
$v.GRIEVANCE_NAME   = Read-Host "Grievance contact name or role, e.g. Data Protection Officer"
$v.HOME_HEADLINE    = Read-Host "Home page headline (one sentence)"
$v.BUSINESS_SUMMARY = Read-Host "What the business is, in one or two sentences"
$v.WHAT_WE_DO       = Read-Host "What you do (a short paragraph, true and specific)"
$v.WHO_WE_SERVE     = Read-Host "Who you serve (a short paragraph)"
$v.EFFECTIVE_DATE   = (Get-Date -Format "d MMMM yyyy")
$v.YEAR             = (Get-Date -Format "yyyy")

$enc = New-Object System.Text.UTF8Encoding($false)
foreach ($f in Get-ChildItem -File -Include *.html,*.txt,*.xml,CNAME -Path .\*) {
  $t = [IO.File]::ReadAllText($f.FullName)
  if ([string]::IsNullOrWhiteSpace($v.PHONE)) { $t = [regex]::Replace($t, '<!--PHONE-->.*?<!--/PHONE-->', '') }
  foreach ($k in $v.Keys) { $t = $t.Replace("{{$k}}", [Net.WebUtility]::HtmlEncode($v[$k])) }
  [IO.File]::WriteAllText($f.FullName, $t, $enc)
}
$left = Select-String -Path .\* -Pattern '\{\{[A-Z_]+\}\}' -List
if ($left) { "Not filled: $($left.Path -join ', ')" } else { "Done. Every placeholder is filled." }
