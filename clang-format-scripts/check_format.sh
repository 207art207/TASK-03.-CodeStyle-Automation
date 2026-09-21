#!/bin/bash

set -euo pipefail

XX=18
YY=22

CF_XX="clang-format-${XX}"
CF_YY="clang-format-${YY}"

RESULT=0

usage() {
    echo "Usage:"
    echo "  $0                     - show this help message"
    echo "  $0 <project-dir>       - check project formatting with both clang-format versions"
    echo
    echo "Example:"
    echo "  $0 ./dummy"
    echo
    echo "Project requirements:"
    echo "  - project directory must exist"
    echo "  - .clang-format must exist in the project root"
    echo "  - .c and .h files are searched recursively in the project directory"
    echo
    printf 'clang-format XX: %s\n' "$CF_XX"
    printf 'clang-format YY: %s\n' "$CF_YY"
}

formatter_installation_check(){
if ! command -v "$CF_XX"; then
    echo "[error] Formatter not found: ${CF_XX}" >&2
    exit 2
fi

if ! command -v "$CF_YY"; then
    echo "[error] Formatter not found: ${CF_YY}" >&2
    exit 2
fi
}


dir_check() {
if [[ $# -ne 1 ]]; then
    echo "[error] Expected one project directory." >&2
    exit 2
fi

PROJECT_DIR="$1"

if [[ ! -d "${PROJECT_DIR}" ]]; then
    echo "[error] Project directory does not exist: ${PROJECT_DIR}" >&2
    exit 2
fi

cd -- "$PROJECT_DIR" || exit 2

if [[ ! -f .clang-format ]]; then
    echo "[error] .clang-format is missing from the project root." >&2
    exit 2
fi

if [[ -z "$(find . -type f \( -name '*.c' -o -name '*.h' \) -print -quit)" ]]; then
    echo "[error] No .c/.h files found." >&2
    exit 2
fi
}

formater_check_cust() {
for version in "${CF_XX}" "${CF_YY}"; do
    echo "==== CLANG-FORMAT $version VERSION ===="

    if ! "$version" --style=file --dump-config </dev/null >/dev/null; then
        echo "[error] Configuration is incompatible or invalid." >&2
        RESULT=2
    elif find . -type f \( -name '*.c' -o -name '*.h' \) \
        -exec "$version" --style=file --dry-run --Werror --ferror-limit=1 {} +; then
        echo "Formatting matches."
    else
        echo "[error] Formatting or file-processing errors;"
        if [[ ${RESULT} == 0 ]]; then
            RESULT=1
        fi
    fi

    echo "======================================"
done
}

: << 'SYSTEM-CLANG-FUNC'
formater_check_gen(){
if ! command -v clang-format >/dev/null 2>&1; then
    echo "[error] Formatter not found: ${CF_XX}" >&2
    exit 2
fi

echo "==== SYSTEM CLANG-FORMAT: $(clang-format --version)===="

    if ! clang-format --style=file --dump-config </dev/null >/dev/null; then
        echo "[error] Configuration is incompatible or invalid." >&2
        RESULT=2
    elif find . -type f \( -name '*.c' -o -name '*.h' \) \
        -exec clang-format --style=file --dry-run --Werror --ferror-limit=1 {} +; then
        echo "Formatting matches."
    else
        echo "[error] Formatting or file-processing errors." >&2

        if [[ $RESULT -eq 0 ]]; then
            RESULT=1
        fi
    fi

    echo "======================================"
}
SYSTEM-CLANG-FUNC

main() {
    usage

    if [[ $# -eq 0 ]]; then
        return 0
    fi

    dir_check "$@"

    formatter_installation_check
    formater_check_cust

    # formater_check_gen

    return "$RESULT"
}

main "$@"