#!/usr/bin/env sh
# Khôi phục cấu hình dual-remote push cho repo này.
# Dùng sau khi clone lại:  ./setup-remotes.sh
set -eu

url=$(git config --get remote.origin.url)
repo=$(basename "$url" .git)

# Plain github.com authenticates as ThanhHaiKhong, which cannot write to mahainc;
# the haikt-vtn SSH alias carries the account that can.
MAHA="git@github.com-haikt-vtn:mahainc/${repo}.git"
THK="git@github.com:ThanhHaiKhong/${repo}.git"

git config --unset-all remote.origin.pushurl 2>/dev/null || true
git remote set-url --add --push origin "$MAHA"
git remote set-url --add --push origin "$THK"

printf 'Dual-remote push đã cấu hình cho %s:\n' "$repo"
git remote -v | grep push
