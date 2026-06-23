#/usr/bin/env bash

RYUBING_API_URL="https://git.ryujinx.app/api/v1/repos/Ryubing/Canary/releases/latest"

if ! command -v curl >/dev/null; then
  echo -e "Curl is not installed. Please install curl and try again."
  exit 1
fi

if ! command -v jq >/dev/null; then
  echo -e "jq is not installed. Please install jq and try again."
  exit 1
fi

if ! command -v nix-prefetch-url >/dev/null; then
  echo -e "nix-prefetch-url is not installed. Please install nix-prefetch-url and try again."
  exit 1
fi

if ! command -v nix >/dev/null; then
  echo -e "nix is not installed. Please install nix and try again."
  exit 1
fi

VERSION=$(curl -s "$RYUBING_API_URL" | jq -r '.tag_name')
HASH=$(nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url https://git.ryujinx.app/Ryubing/Canary/releases/download/${VERSION}/ryujinx-canary-${VERSION}-x64.AppImage))

echo "{ \"version\": \"$VERSION\", \"hash\": \"$HASH\" }" > ./ryubing_version.json

