# Maintainer Profile Exercises

Profile tools: shellcheck · shfmt · bats-core · pre-commit · go-task ·
markdownlint-cli · actionlint · yamllint · hadolint

Before you start:

```zsh
./setup-my-mac.sh --doctor --profile maintainer
./setup-my-mac.sh --doctor --fix --profile maintainer   # only if doctor
                                                        # reports missing tools
```

These exercises assume you are inside the Shellcraft repository:

```zsh
cd ~/workspace/shellcraft
```

---

## Sample data

Create a Dockerfile once for the hadolint section:

```zsh
mkdir -p ~/data/maintainer-lab

cat > ~/data/maintainer-lab/Dockerfile <<'EOF'
FROM alpine:3.20
RUN apk add --no-cache bash curl
WORKDIR /app
CMD ["bash", "-lc", "echo maintainer-lab"]
EOF
```

**Exercise:** Run `bat ~/data/maintainer-lab/Dockerfile` and confirm the file
is valid Dockerfile syntax.

---

## Day 1 — Shellcraft Maintainer Workflow

**Goal:** Learn the local commands that keep this repository healthy before CI
catches regressions.

### 1.1 — go-task: Discover and run the repo workflow

```zsh
task --list                 # show all available repo tasks
task doctor                 # verify the selected Shellcraft profile state
task lint                   # run the full maintainer lint bundle
task fmt-check              # shell formatting check only
task test                   # run the Bats suite
```

**Exercise:** Run `task --list` and then `task doctor`. Identify which task you
would run before opening a pull request.

---

### 1.2 — pre-commit: Run the same gates on demand

```zsh
pre-commit --version
pre-commit run --all-files

# Optional: install the hook into this repo clone
pre-commit install
```

**Exercise:** Run `pre-commit run --all-files`. Confirm you can execute the
same repo-wide `task lint` pass locally before committing.

---

### 1.3 — shellcheck + shfmt: Audit the shell entrypoints directly

```zsh
shellcheck setup-my-mac.sh lib/*.sh
shfmt -d setup-my-mac.sh lib/*.sh tests/*.bats

# Focus a single file
shellcheck setup-my-mac.sh
shfmt -d setup-my-mac.sh
```

**Exercise:** Run both commands above. Confirm you can check Shellcraft shell
code without mutating it.

---

### 1.4 — bats-core: Run the smoke tests intentionally

```zsh
bats tests

# Narrow to one file while iterating
bats tests/plan_and_safety.bats
bats tests/apply_existing.bats
```

**Exercise:** Run `bats tests/plan_and_safety.bats`. Identify which test
covers `--doctor --fix`.

---

### Day 1 Checkpoint

- [ ] Ran `task --list` and `task doctor`
- [ ] Ran `pre-commit run --all-files`
- [ ] Ran `shellcheck` and `shfmt -d` directly
- [ ] Ran at least one Bats file intentionally

---

## Day 2 — Documentation, YAML, CI, and Container Checks

**Goal:** Validate the repo surfaces that break most often during maintenance:
docs, YAML, workflows, and Dockerfiles.

### 2.1 — markdownlint-cli: Keep docs clean

```zsh
markdownlint README.md CONTRIBUTING.md exercises/*.md

# Focus one file
markdownlint exercises/maintainer-exercises.md
```

**Exercise:** Run `markdownlint README.md CONTRIBUTING.md exercises/*.md`.
Confirm all documentation passes before you edit more docs.

---

### 2.2 — yamllint: Catch structural YAML issues early

```zsh
yamllint .

# Focus the workflow directory
yamllint .github/workflows
```

**Exercise:** Run `yamllint .github/workflows`. Confirm the workflow files pass
basic YAML checks before you run deeper CI linting.

---

### 2.3 — actionlint: Validate GitHub Actions semantics

```zsh
actionlint

# Optional: inspect the current workflow while the linter output is fresh
bat .github/workflows/ci.yml
```

**Exercise:** Run `actionlint`. Then open `.github/workflows/ci.yml` and
locate the job it validated.

---

### 2.4 — hadolint: Lint a Dockerfile even if the repo does not ship one

```zsh
hadolint ~/data/maintainer-lab/Dockerfile

# Inspect the file you just linted
bat ~/data/maintainer-lab/Dockerfile
```

**Exercise:** Run `hadolint ~/data/maintainer-lab/Dockerfile`. Confirm the
sample Dockerfile passes and note which base image it uses.

---

### 2.5 — Full maintainer sweep

```zsh
task lint
task test
```

**Exercise:** Run `task lint` followed by `task test`. Use this as your final
pre-PR checklist for Shellcraft changes.

---

### Day 2 Checkpoint

- [ ] Ran `markdownlint` on the repo docs
- [ ] Ran `yamllint` on the workflow YAML
- [ ] Ran `actionlint` on the repo workflow
- [ ] Ran `hadolint` on the sample Dockerfile
- [ ] Finished with `task lint` and `task test`
