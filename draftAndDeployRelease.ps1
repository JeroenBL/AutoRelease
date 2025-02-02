param (
  [Parameter(Mandatory)]
  $UserName,

  [Parameter(Mandatory)]
  $Repository,

  [Parameter(Mandatory)]
  $GHToken
)

try {
  $changelogContent = Get-Content -Path "CHANGELOG.md" -Raw
  $latestVersionMatch = $changelogContent -match '(?sm)^##\s*(.*?)\s*-\s*(\d{1,2}-\d{1,2}-\d{4})'
  if ($latestVersionMatch) {
      $latestVersion = $matches[1].Trim('[]')
  } else {
      throw "No version found in the CHANGELOG.md file."
  }

  $splatParams = @{
      Uri         = "https://api.github.com/repos/$UserName/$Repository/releases"
      Method      = 'POST'
      Headers     = @{Authorization = "Bearer $GHToken"}
      ContentType = 'application/json'
      Body        = @{
          tag_name               = $latestVersion
          target_commitish       = 'main'
          name                   = 'Initial'
          body                   = 'Initial release'
          draft                  = $false
          prerelease             = $false
          generate_release_notes = $false
          make_latest            = 'true'
      } | ConvertTo-Json
  }
  $response = Invoke-RestMethod @splatParams
  $message = "Created release with tag: $($response.tag_name)"
} catch {
  $PSCmdlet.ThrowTerminatingError($_)
}

echo "::set-output name=message::$message"
