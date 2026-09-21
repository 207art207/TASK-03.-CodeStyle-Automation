# TASK 03 — CodeStyle Automation

A Bash scripting project for checking and automatically formatting C
source files with different clang-format versions.

The experiments compare clang-format 18.1.8 and 22.1.8 using the original
Linux `.clang-format` configuration and the Chromium style.

The dummy project contains four `.c` files and four `.h` files copied
from Linux 7.2. Their initial combined size was 158186 bytes, excluding
the configuration file.

## Documentation

- [Full experiment report](Report.md)
- [Dummy project operation journal](dummy/README.md)
- [Initial check logs](additional-files/checks/)
- [Formatting logs](additional-files/makes/)
- [Chromium configurations and comparison](additional-files/chromium-files/)

## Repository structure

```text
.
├── README.md
├── Report.md
├── clang-format-scripts/
│   ├── check_format.sh
│   ├── make_format_clang-18.sh
│   └── make_format_clang-22.sh
├── utils/
│   ├── linux-files-download-script.sh
│   └── clang-format-chromium-make.sh
├── additional-files/
│   ├── checks/
│   ├── makes/
│   └── chromium-files/
│       ├── chromium-18.clang-format
│       ├── chromium-22.clang-format
│       └── chromium-files-comp.txt
└── dummy/
    ├── .clang-format
    ├── README.md
    ├── src/
    └── include/
```

## Environment and installation

The experiments were performed on EndeavourOS, an Arch-based Linux
distribution, using Bash scripts and zsh as the interactive shell.

Required tools include Bash, Git, GNU find, diff, and both clang-format
versions. The source download utility additionally uses wget, tar
and xz.

### Install the formatter packages

The following command was used to install clang different versions:

```bash
sudo pacman -S --needed clang clang18
```

The installed formatter executables were:

| Version used | Executable |
|---|---|
| 18.1.8 | `/usr/lib/llvm18/bin/clang-format` |
| 22.1.8 | `/usr/bin/clang-format` |

### Create version-specific command names

The project scripts call `clang-format-18` and `clang-format-22`.
Local symbolic links provide these names:

```bash
mkdir -p ~/.local/bin

ln -sf /usr/lib/llvm18/bin/clang-format \
    ~/.local/bin/clang-format-18

ln -sf /usr/bin/clang-format \
    ~/.local/bin/clang-format-22
```

### Add the local executable directory to PATH

Add this line to `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Reload the shell configuration:

```bash
source ~/.zshrc
```

Verify the commands and their actual versions:

```bash
command -v clang-format-18
command -v clang-format-22

clang-format-18 --version
clang-format-22 --version
```

The versions used for the recorded results were:

```text
clang-format version 18.1.8
clang-format version 22.1.8
```

The `clang-format-22` link points to the system executable. It does not
pin the installed package to version 22.

## Usage

Run the following commands from the repository root.

The check and formatting scripts accept one project directory.
That directory must contain a `.clang-format` file and at least one
`.c` or `.h` file. Source files are processed recursively.

Running a script without arguments displays its help message:

```bash
./clang-format-scripts/check_format.sh
```

### Check formatting

```bash
./clang-format-scripts/check_format.sh ./dummy
```

The script checks both formatter versions without modifying source files.

| Exit code | Meaning |
|---|---|
| `0` | Successful check |
| `1` | Formatting violations or file-processing errors |
| `2` | Invalid arguments, missing requirements, or configuration errors |

### Format with Chromium 18

These commands replace the active configuration and rewrite source files:

```bash
cp additional-files/chromium-files/chromium-18.clang-format \
    dummy/.clang-format

./clang-format-scripts/make_format_clang-18.sh ./dummy
```

### Format with Chromium 22

```bash
cp additional-files/chromium-files/chromium-22.clang-format \
    dummy/.clang-format

./clang-format-scripts/make_format_clang-22.sh ./dummy
```

Each formatting script verifies the result with its own formatter version.

### Inspect changes

```bash
git --no-pager diff --stat -- dummy/src dummy/include
git --no-pager diff -- dummy/src/manage.c
```

## Final project state

The committed dummy project uses the Chromium configuration exported by
clang-format 22.1.8.

With this configuration:

- clang-format 22 successfully verifies the source formatting;
- clang-format 18 reports an unknown `AlignFunctionDeclarations` key;
- `check_format.sh` returns overall exit code `2`.

This is a recorded configuration compatibility result. Version 18 fails
while reading `.clang-format`, before it can check source formatting.

## Experiment results

The following statistics describe source changes at each transition.
Configuration files, logs, and documentation are excluded.

| Transition | Files changed | Insertions | Deletions |
|---|---:|---:|---:|
| Original sources → Linux formatting with version 18 | 8 | 639 | 687 |
| Linux formatting: version 18 → version 22 | 0 | 0 | 0 |
| Linux formatting → Chromium 18 | 8 | 4098 | 4208 |
| Chromium 18 → Chromium 22 | 0 | 0 | 0 |

Changing from Linux formatting to Chromium produced the largest source
diff. The tested version transitions introduced no additional source
changes, although the Chromium 22 configuration was incompatible with
clang-format 18.

These results apply to the selected files and configurations.
The project evaluates formatting; compilation and runtime behavior
were not tested.

See [Report.md](Report.md) for the detailed analysis.

## Utilities

### Download the original Linux sample

```bash
./utils/linux-files-download-script.sh
```

The source files are already included in the repository. Running this
utility again overwrites the selected dummy source files and active
configuration with their original Linux versions.

### Export Chromium configurations

```bash
./utils/clang-format-chromium-make.sh
```

This utility exports both Chromium configurations and saves their unified
diff in `additional-files/chromium-files/chromium-files-comp.txt`.

Both utilities currently use this fixed working directory:

```text
~/Projects/TASK-03.-CodeStyle-Automation
```

Adjust their `cd` command if the repository is stored elsewhere.

## Commit convention

Commit messages for the assignment use the prefix:

```text
TASK 03 : ...
```

Operations on the dummy project are recorded in
[dummy/README.md](dummy/README.md).