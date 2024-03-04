# AutoRelease
some changes
This GitHub action uses PowerShell to automatically create a new release based on information in the _CHANGELOG.md_.

<p align="center">
  <img src="./logo.png" width="300">
</p>

- [AutoRelease](#autorelease)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
    - [GHToken](#ghtoken)
    - [Action](#action)

## Prerequisites

- [ ] CHANGELOG.md file specified in your repository.
- [ ] Repository secret _GHToken_ to securely use the GitHub API's.

## Installation
some changes
### GHToken

1. Go to your GitHub repository on which the action will be run.
2. Click on `Settings`.
3. Browse to `Secrets and variables -> Actions`.
4. Specify a new token with the name _GHToken_.

>[!TIP]
> A _fine grained_ token is required if this extension will be executed from organization repositories.

### Action

1. Go to the repository for which you want to execute this action.
2. Create a new _action_ and _workflow.yaml_ on your repository.
3. Copy and paste the _yaml_ code pasted below:
```yaml
name: ConnectorRelease

on:
  pull_request:
    types:
      - closed

jobs:
  if_merged:
    runs-on: ubuntu-latest
    if: github.event.pull_request.merged
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Run AutoRelease
        id: autorelease
        uses: JeroenBL/AutoRelease@v0.7
        with:
          UserName: JeroenBL
          Repository: ReleaseTest
          GHToken: ${{ secrets.GTOKEN }}

      - name: Display AutoRelease Output
        run: |
          echo "AutoRelease Message: ${{ steps.autorelease.outputs.message }}"
```

some changes
