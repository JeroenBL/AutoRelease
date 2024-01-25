param (
  [Parameter(Mandatory)]
  $UserName,

  [Parameter(Mandatory)]
  $Repository,

  [Parameter(Mandatory)]
  $ReleaseNotes,

  [Parameter(Mandatory)]
  $ReleaseName,

  [Parameter(Mandatory)]
  $Tag,

  [Parameter(Mandatory)]
  $GHToken
)

try {
		$splatParams = @{
			Uri         = "https://api.github.com/repos/$UserName/$Repository/releases"
			Method      = 'POST'
			Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($GHToken + ":x-oauth-basic"))}
			ContentType = 'application/json'
			Body        = @{
        tag_name         = $Tag
        target_commitish = 'main'
        name             = $ReleaseName
        body             = $ReleaseNotes
        draft            = $false
        prerelease       = $false
      } | ConvertTo-Json
		}
  $response = Invoke-RestMethod @splatParams
} catch {
  $PSCmdlet.ThrowTerminatingError($_)
}

# Write back the generated release to workflow
echo "::set-output name=tag::$($response.tag_name)"
echo "::set-output name=notes::$($response.description)"
