#!/bin/bash

set -euo pipefail

XX=18

CF_XX="clang-format-${XX}"

RESULT=0

usage() {
    echo "Usage:"
    echo "  $0                     - show this help message"
    echo "  $0 <project-dir>       - make project formatting with clang-format-18 version"
    echo
    echo "Example:"
    echo "  $0 ./dummy"
    echo
    echo "Project requirements:"
    echo "  - project directory must exist"
    echo "  - .clang-format must exist in the project root"
    echo "  - .c and .h files are searched recursively in the project directory"
    echo
    echo "clang-format XX: ${CF_XX}"
    echo
    echo
    echo
}

formatter_installation_check(){
if ! command -v "$CF_XX"; then
    echo "[error] Formatter not found: ${CF_XX}" >&2
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
    echo "==== CLANG-FORMAT ${CF_XX} VERSION ===="

    if ! ${CF_XX} --style=file --dump-config </dev/null >/dev/null; then
        echo "[error] Configuration is incompatible or invalid." >&2
        echo
        RESULT=2
    elif find . -type f \( -name '*.c' -o -name '*.h' \) \
        -exec ${CF_XX} --style=file --dry-run --Werror --ferror-limit=1 {} +; then
        echo "[format-pass] Formatting matches."
        echo
    else
        echo "[format-fail] Formatting or file-processing errors;"
        echo
        if [[ ${RESULT} == 0 ]]; then
            RESULT=1
        fi
    fi

    echo "======================================"
}

formater_make_cust() {
    if ! "$CF_XX" --style=file --dump-config </dev/null >/dev/null; then
        echo "[error] Configuration is incompatible or invalid." >&2
        exit 2
    fi

    if ! find . -type f \( -name '*.c' -o -name '*.h' \) \
        -exec "$CF_XX" --style=file -i {} +; then
        echo "[error] Formatting failed; some files may already be changed." >&2
        exit 1
    fi

    echo "Formatting complete."
}

main() {
    
    if [[ $# -eq 0 ]]; then
        usage
        return 0
    fi

    dir_check "$@"

    formatter_installation_check
    formater_make_cust
    formater_check_cust

    return "$RESULT"
}

main "$@"