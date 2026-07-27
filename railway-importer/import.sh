#!/usr/bin/env sh
set -eu

SOURCE_REPO_URL="${SOURCE_REPO_URL:-https://github.com/ixartz/SaaS-Boilerplate.git}"
SOURCE_REF="${SOURCE_REF:-main}"
TARGET_REPO="${TARGET_REPO:-MyMindVentures/CostaPulseCrew}"
TARGET_BASE_BRANCH="${TARGET_BASE_BRANCH:-main}"
TARGET_BRANCH="${TARGET_BRANCH:-setup/saas-template}"
CONFIRM_IMPORT="${CONFIRM_IMPORT:-}"
GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-Railway Importer}"
GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-railway-importer@users.noreply.github.com}"

require_var() {
  var_name="$1"
  eval "var_value=\${$var_name:-}"
  if [ -z "$var_value" ]; then
    echo "Missing required environment variable: $var_name" >&2
    exit 1
  fi
}

require_var GITHUB_TOKEN

if [ "$CONFIRM_IMPORT" != "CostaPulseCrew" ]; then
  echo "Refusing to run. Set CONFIRM_IMPORT=CostaPulseCrew to authorize the import." >&2
  exit 1
fi

case "$TARGET_BRANCH" in
  main|master)
    echo "Refusing to push directly to protected branch: $TARGET_BRANCH" >&2
    exit 1
    ;;
esac

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT INT TERM

SOURCE_DIR="$WORKDIR/source"
TARGET_DIR="$WORKDIR/target"
AUTH_HEADER="$(printf 'x-access-token:%s' "$GITHUB_TOKEN" | base64 | tr -d '\n')"
TARGET_URL="https://github.com/${TARGET_REPO}.git"

echo "Cloning source $SOURCE_REPO_URL at ref $SOURCE_REF..."
git clone --depth 1 --branch "$SOURCE_REF" "$SOURCE_REPO_URL" "$SOURCE_DIR"
rm -rf "$SOURCE_DIR/.git"

echo "Cloning target $TARGET_REPO at base branch $TARGET_BASE_BRANCH..."
git -c "http.https://github.com/.extraheader=AUTHORIZATION: basic $AUTH_HEADER" \
  clone --depth 1 --branch "$TARGET_BASE_BRANCH" "$TARGET_URL" "$TARGET_DIR"

cd "$TARGET_DIR"
git switch -C "$TARGET_BRANCH"

find . -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
cp -a "$SOURCE_DIR/." .

git config user.name "$GIT_AUTHOR_NAME"
git config user.email "$GIT_AUTHOR_EMAIL"
git add -A

if git diff --cached --quiet; then
  echo "No changes detected; nothing to import."
  exit 0
fi

git commit -m "Import ixartz SaaS Boilerplate as clean project base"

echo "Pushing clean import to $TARGET_REPO:$TARGET_BRANCH..."
git -c "http.https://github.com/.extraheader=AUTHORIZATION: basic $AUTH_HEADER" \
  push --force "$TARGET_URL" "HEAD:refs/heads/$TARGET_BRANCH"

echo "Import completed successfully."
