#!/bin/sh
# Self-test for check-os.sh, with fake brews so it passes on any macOS.
#   sh check-os-test.sh
set -u
dir="$(cd "$(dirname "$0")" && pwd)"
t="$(mktemp -d)"; trap 'rm -rf "$t"' EXIT

# A brew that knows the check and fails it (unsupported), one that passes, one that doesn't know it.
printf '%s\n' '#!/bin/sh' '[ "$2" = --list-checks ] && { echo check_for_unsupported_macos; exit 0; }' 'echo "Warning: You are using macOS 14."; exit 1' > "$t/old"
printf '%s\n' '#!/bin/sh' '[ "$2" = --list-checks ] && { echo check_for_unsupported_macos; exit 0; }' 'exit 0' > "$t/ok"
printf '%s\n' '#!/bin/sh' '[ "$2" = --list-checks ] && { echo other_check; exit 0; }' 'exit 1' > "$t/unknown"
chmod +x "$t/old" "$t/ok" "$t/unknown"

fail=0
expect() { # description, expected exit, command...
  d="$1"; want="$2"; shift 2
  "$@" >/dev/null 2>&1; got=$?
  if [ "$got" = "$want" ]; then echo "ok   $d"; else echo "FAIL $d (exit $got, wanted $want)"; fail=1; fi
}
expect "unsupported macOS blocks"             1 sh "$dir/check-os.sh" "$t/old"
expect "supported macOS passes"               0 sh "$dir/check-os.sh" "$t/ok"
expect "brew without the check doesn't block" 0 sh "$dir/check-os.sh" "$t/unknown"
expect "override lets an old macOS through"   0 env SETUP_ALLOW_OLD_OS=1 sh "$dir/check-os.sh" "$t/old"
exit $fail
