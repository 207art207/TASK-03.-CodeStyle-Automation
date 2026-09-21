# TASK 03: CodeStyle Automation

## Environment

- OS: EndeavourOS.
- Older formatter: clang-format 18.1.8.
- Newer formatter: clang-format 22.1.8.

## Dummy project

- Source: Linux 7.2.
- Archive: https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.2.tar.xz
- Files: 4 .c files and 4 .h files.
- Initial source size: 158186 bytes, excluding .clang-format.
- Configuration: .clang-format copied from the same archive.

## Initial formatting check

The initial dummy project was checked using clang-format 18.1.8 and
22.1.8 with the `.clang-format` configuration copied from Linux 7.2.

Command:

```bash
./clang-format-scripts/check_format.sh ./dummy
```

The script recursively checks `.c` and `.h` files using these options:

- `--style=file`: use the project's `.clang-format` configuration.
- `--dry-run`: check formatting without modifying source files.
- `--Werror`: treat formatting warnings as errors.
- `--ferror-limit=1`: limit diagnostic output to one formatting error
  per file.

Both formatter versions successfully read the configuration. Both
reported formatting violations in all eight source files.

| Formatter | Files checked | Files with formatting violations | Result |
|---|---:|---:|---|
| clang-format 18.1.8 | 8 | 8 | FAIL |
| clang-format 22.1.8 | 8 | 8 | FAIL |

The first reported locations were identical for both versions:

| File | Line | Column |
|---|---:|---:|
| `src/ethtool.c` | 27 | 39 |
| `src/manage.c` | 81 | 41 |
| `src/file.c` | 151 | 39 |
| `src/ext4_jbd2.c` | 13 | 41 |
| `include/e1000.h` | 30 | 30 |
| `include/phy.h` | 71 | 27 |
| `include/ext4_extents.h` | 49 | 8 |
| `include/mballoc.h` | 30 | 31 |

Example diagnostic:

```text
./src/ethtool.c:27:39: error: code should be clang-formatted [-Wclang-format-violations]
```

These messages indicate formatting differences, not compiler errors.
No compilation was performed. The `--Werror` option causes formatting
violations to be reported as errors.

The script returned exit code `1`. Neither the source files nor
`.clang-format` were modified during the check.

### Initial observations

The original source files do not fully match the formatting produced
by either selected formatter version with the supplied configuration.

Identical first diagnostic locations do not prove that both versions
would produce identical formatted files. Because diagnostic output is
limited, additional formatting differences may exist within each file.

This check establishes the baseline for the subsequent experiments:
formatting with each version and comparing the resulting Git diffs.

### Execution logs

- [Clang-format 18 results](additional-files/checks/clang-18-format-check.txt)
- [Clang-format 22 results](additional-files/checks/clang-22-format-check.txt)
- [Clang-format results comprasion](additional-files/checks/clang-comp.txt)

## Linux formatting version comparison

### Experiment setup

The eight source files were formatted sequentially with clang-format
18.1.8 and 22.1.8. The original Linux `.clang-format` configuration
remained unchanged throughout the experiment.

After each formatting operation, `check_format.sh` checked the project
with both formatter versions.

### Formatting with clang-format 18

Commands:

```bash
./clang-format-scripts/make_format_clang-18.sh ./dummy
./clang-format-scripts/check_format.sh ./dummy
git diff --stat -- dummy/src dummy/include
```

Formatting completed successfully. The formatting script's own check
passed, and the subsequent check reported `[format-pass]` for both
clang-format 18 and clang-format 22.

Git reported the following changes relative to the original sources:

```text
8 files changed, 639 insertions(+), 687 deletions(-)
```

The example diff for `dummy/src/manage.c` shows changes to continuation
line alignment and line wrapping in expressions, function declarations,
and function calls.

Git counts replaced and rewrapped lines as deletions and insertions.
Therefore, this substantial diff does not by itself indicate the
addition or removal of program functionality.

The formatting changes were recorded in commit `b2d34d4`.

### Formatting with clang-format 22

Commands:

```bash
./clang-format-scripts/make_format_clang-22.sh ./dummy
./clang-format-scripts/check_format.sh ./dummy
git diff --stat -- dummy/src dummy/include
```

Clang-format 22 was applied to the files already formatted by
clang-format 18.

Formatting completed successfully, and both formatter versions again
reported `[format-pass]`.

No additional changes appeared in `dummy/src` or `dummy/include`.
A comparison of commits `b2d34d4` and `6e60e93` confirmed that the source
files and `.clang-format` were identical between these two stages.

Commit `6e60e93` recorded the second experiment through changes to the
logs and the dummy project journal.

### Results and Git statistics

The statistics below include only files in `dummy/src` and
`dummy/include`, excluding logs and documentation.

| Operation | Files changed | Insertions | Deletions | Check with 18 | Check with 22 |
|---|---:|---:|---:|---|---|
| Original sources → clang-format 18 | 8 | 639 | 687 | PASS | PASS |
| Clang-format 18 output → clang-format 22 | 0 | 0 | 0 | PASS | PASS |

### Conclusions

The original Linux source files required formatting changes under the
supplied configuration. Applying clang-format 18 changed all eight files.

Switching to clang-format 22 introduced no further changes. For this
sample and configuration, the output of clang-format 18 was also accepted
by clang-format 22.

This result does not establish equivalence between the formatter versions
for other source files or configurations. The experiment verifies
formatting consistency; it does not verify compilation or runtime behavior.

### Execution logs

- [Clang-format 18 results](additional-files/makes/clang-18-format-make.txt)
- [Clang-format 22 results](additional-files/makes/clang-22-format-make.txt)

