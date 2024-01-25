# AutoRelease

This GitHub action uses PowerShell to automatically create a new release based on information in your _CHANGELOG.md_. 

## Prerequisites

- [ ] a CHANGELOG.md file specified in your repository.

## Installation

1. Create a new _action_ and _workflow.yaml_ on your repository.
2. Copy and paste the _yaml_ code pasted below:
```yaml
name: AutoRelease

on:
  push:
    branches:
      - main

jobs:
  run-custom-action:

    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Run AutoRelease
        id: autorelease
        uses: JeroenBL/AutoRelease@v0.5
        with:
          UserName: JeroenBL
          Repository: ReleaseTest
          GHToken: ${{ secrets.GHTOKEN }} 

      - name: Display AutoRelease Output
        run: |
          echo "AutoRelease Message: ${{ steps.autorelease.outputs.message }}"
```
3. Make sure to use the latest version of _AutoRelease_. ```JeroenBL/AutoRelease@x.x```
   
> [!TIP]
> Make sure to check latest releases on: https://github.com/JeroenBL/AutoRelease/tags