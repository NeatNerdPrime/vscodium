#!/usr/bin/env bash

set -ex

GH_ARCH="amd64"

TAG=$( curl --retry 12 --retry-delay 30 "https://api.github.com/repos/cli/cli/releases/latest" 2>/dev/null | jq --raw-output '.tag_name' )

if [[ $? -ne 0 ]] || [[ "${TAG}" == "null" ]]; then
  echo "Error: Failed to retrieve the latest tag from GitHub CLI releases."
  exit 1
fi

VERSION="${TAG#v}"

curl --retry 12 --retry-delay 120 -sSL "https://github.com/cli/cli/releases/download/${TAG}/gh_${VERSION}_linux_${GH_ARCH}.tar.gz" -o "gh_${VERSION}_linux_${GH_ARCH}.tar.gz"

tar xf "gh_${VERSION}_linux_${GH_ARCH}.tar.gz"

cp "gh_${VERSION}_linux_${GH_ARCH}/bin/gh" /usr/local/bin/

gh --version
