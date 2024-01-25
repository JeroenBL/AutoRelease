param (
  [Parameter(Mandatory)]
  $UserName,

  [Parameter(Mandatory)]
  $Repository,

  [Parameter(Mandatory)]
  $GHToken
)

try {
  $changelog = Get-Content -Path 'CHANGELOG.md' -Raw
  $versionTag = $changelog -match '## \[([^\]]+)' | Select-Object -First 1 -ExpandProperty Matches | ForEach-Object { $_.Groups[1].Value }

  $splatParams = @{
      Uri         = "https://api.github.com/repos/$UserName/$Repository/releases"
      Method      = 'POST'
      Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($GHToken + ":x-oauth-basic")) }
      ContentType = 'application/json'
      Body        = @{
          tag_name         = $versionTag
          target_commitish = 'main'
          name             = 'Initial'
          body             = 'Initial release'
          draft            = $false
          prerelease       = $false
      } | ConvertTo-Json
  }
  $response = Invoke-RestMethod @splatParams
  $message = "Created release with tag: $($response.tag_name)"
} catch {
  $PSCmdlet.ThrowTerminatingError($_)
}

echo "::set-output name=message::$message"