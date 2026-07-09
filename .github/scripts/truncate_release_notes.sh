#!/usr/bin/env bash
#
# 릴리즈 노트를 스토어 한도에 맞춰 in-place 절단한다.
#
# Usage: truncate_release_notes.sh <file> <limit> <byte|char>
#   iOS  : App Store Connect "What to Test" 4000 byte  → 3800 byte
#   Android: Google Play 릴리즈 노트 500 글자          → 480 char
#
# 한글은 UTF-8에서 3바이트이므로 byte 절단 시 글자 중간이 잘릴 수 있다.
# 깨진 꼬리 바이트는 버리고 valid UTF-8만 남긴다.
set -euo pipefail

FILE="${1:?파일 경로가 필요합니다}"
LIMIT="${2:?최대 길이가 필요합니다}"
MODE="${3:?단위(byte|char)가 필요합니다}"

[ -f "$FILE" ] || { echo "❌ 파일 없음: $FILE" >&2; exit 1; }

python3 - "$FILE" "$LIMIT" "$MODE" <<'PY'
import sys

path, limit, mode = sys.argv[1], int(sys.argv[2]), sys.argv[3]

with open(path, encoding='utf-8') as f:
    text = f.read()

if mode == 'char':
    out = text[:limit]
elif mode == 'byte':
    out = text.encode('utf-8')[:limit].decode('utf-8', 'ignore')
else:
    sys.exit(f"❌ 알 수 없는 단위: {mode} (byte|char)")

with open(path, 'w', encoding='utf-8') as f:
    f.write(out)

if len(out) < len(text):
    print(f"✂️  릴리즈 노트 절단: {limit} {mode}")
PY
