#!/bin/bash

cd ~/Projects/TASK-03.-CodeStyle-Automation

mkdir -p additional-files/chromium-files

clang-format-18 --style=Chromium --dump-config \
    > additional-files/chromium-files/chromium-18.clang-format

clang-format-22 --style=Chromium --dump-config \
    > additional-files/chromium-files/chromium-22.clang-format
echo "Operation success"

wc -l additional-files/chromium-files/chromium-18.clang-format \
    additional-files/chromium-files/chromium-22.clang-format

diff -u additional-files/chromium-files/chromium-18.clang-format \
    additional-files/chromium-files/chromium-22.clang-format > additional-files/chromium-files/chromium-files-comp.txt

echo "diff exit code: $?"