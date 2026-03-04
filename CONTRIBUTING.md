# Contributing

Shellcraft is now profile-driven and safety-first. Contributions should
preserve both properties.

## What belongs here

Good contributions:

- adding or refining profile packages
- improving preview/apply/doctor behavior
- making config adoption safer or more transparent
- expanding the maintainer toolchain
- improving tests, CI, or documentation
- adding exercises that match the installed toolset

Still out of scope:

- paid tooling
- sign-in-required defaults
- Linux support
- GUI app management beyond optional font installation
- package managers other than Homebrew

## Repository Model

Package ownership lives in:

- `profiles/*.Brewfile`

Behavior lives in:

- `lib/profile_metadata.sh`
- `lib/planner.sh`
- `lib/config_adoption.sh`
- `lib/verifier.sh`

Managed config templates live in:

- `templates/*`

User-facing local commands live in:

- `Makefile`

Engine behavior lives in:

- `setup-my-mac.sh`

## Adding A Tool

### 1. Put it in the right profile

Add the formula to the matching Brewfile:

```bash
profiles/core.Brewfile
profiles/backend.Brewfile
profiles/ai.Brewfile
profiles/maintainer.Brewfile
profiles/containers.Brewfile
profiles/local-ai.Brewfile
```

Do not default new tools into `core` unless they are broadly useful to nearly
every machine.

### 2. Map formula name to command name if needed

If the binary name differs from the formula name, update `formula_cmd()` in
[lib/profile_metadata.sh](/Users/ajitg/workspace/shellcraft/lib/profile_metadata.sh).

Examples:

- `ripgrep` -> `rg`
- `kubernetes-cli` -> `kubectl`
- `go-task` -> `task`

### 3. Add profile-aware shell behavior only when justified

If the tool needs shell integration:

- add plugin wiring in `profile_plugins()`
- add minimal shell helpers in `profile_snippets()`

Do not enable a plugin unless the matching profile installs the tool.

### 4. Update docs and tests

At minimum:

- update [README.md](/Users/ajitg/workspace/shellcraft/README.md)
- add or extend a temp-HOME smoke test in `tests/*.bats`
- update exercises if the tool changes the learning surface area

## Safety Rules

These are non-negotiable:

- `--plan` must stay non-mutating with respect to the user home directory
- top-level dotfiles must not be rewritten wholesale
- existing user config must be preserved outside the Shellcraft marker block
- Shellcraft must never write placeholder Git identity
- system-level changes must remain opt-in flags

If a change makes Shellcraft more convenient but less predictable on an
existing machine, it is the wrong change.

## Bash Constraints

The script must run under stock macOS Bash 3.2.

Avoid:

- associative arrays
- Bash 4+ only parameter features
- dependencies on GNU-only shell behavior unless the code is already running
  after Homebrew bootstrap

Shellcraft intentionally avoids `set -e`. Handle failures explicitly and
report them clearly.

## Test Expectations

Use temp-HOME scenarios to prove safety.

Required coverage areas:

- default run stays in plan mode
- apply on a fresh home
- apply on an existing home with preserved custom config
- profile-specific plugin rendering
- Docker CLI plugin merge behavior
- blocked Xcode install path without `--allow-gui-installs`

## Local Checks

After installing the `maintainer` profile:

```bash
task lint
task fmt-check
task test
pre-commit run --all-files
```

If `bats` is not installed locally, you can still run the smoke scenarios by
sourcing `tests/test_helper.bash` and invoking `setup-my-mac.sh` under a temp
`HOME`.

At commit time, pre-commit runs `task lint` as a repo-wide lint pass. If the
repo has any lint failures, the commit is blocked and pre-commit reports the
full set of findings from that run.
