# Copilot Setup (Reusable Across Repos)

This repo now includes installers that convert these skills into VS Code Copilot instructions for any target repository.

## Quick Start

From this repository:

```bash
./install-copilot.sh /path/to/your/repo
```

Windows Bash note: if you pass a Windows path, either quote it or use forward slashes.

```bash
./install-copilot.sh "C:\Users\name\repo"
./install-copilot.sh C:/Users/name/repo
```

On Windows PowerShell:

```powershell
.\install-copilot.ps1 -TargetRepo C:\path\to\your\repo
```

Both commands create/update:

- `.github/copilot-instructions.md`
- `.github/instructions/spec.instructions.md`
- `.github/instructions/domain.instructions.md`
- `.github/instructions/slice.instructions.md`
- `.github/instructions/tdd.instructions.md`
- `.github/instructions/holistic.instructions.md`
- `.github/instructions/architect.instructions.md`
- `.github/instructions/qa.instructions.md`

## Modes

Default mode is `copy`.

- `copy`: copies each skill into target repo instruction files (portable, safest)
- `link`: symlinks instruction files back to this repo (easy central updates)

Examples:

```bash
./install-copilot.sh ~/src/repo-a --mode copy
./install-copilot.sh ~/src/repo-b --mode link
```

```powershell
.\install-copilot.ps1 -TargetRepo C:\src\repo-a -Mode copy
.\install-copilot.ps1 -TargetRepo C:\src\repo-b -Mode link
```

## Recommended workflow for many repos

1. Keep this `skills` repository in one stable location.
2. Run installer in each repo when you onboard or update workflows.
3. Use `copy` if teammates should get the same setup through normal git pulls.
4. Use `link` if you want one central source of truth on your machine.

## Notes

- `link` mode requires symlink permissions on your OS.
- Existing files with the same names are overwritten/replaced.
- These files configure Copilot-style instructions; they do not configure Claude's `~/.claude/skills`.
