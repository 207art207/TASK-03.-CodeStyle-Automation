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