param(
  [Parameter(Position = 0)]
  [string]$TargetRepo = (Get-Location).Path,

  [ValidateSet('copy', 'link')]
  [string]$Mode = 'copy'
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path -LiteralPath $TargetRepo -PathType Container)) {
  throw "Target repository does not exist: $TargetRepo"
}

$skills = @('spec', 'domain', 'slice', 'tdd', 'holistic', 'architect', 'qa')
$instructionsDir = Join-Path $TargetRepo '.github/instructions'
New-Item -ItemType Directory -Force -Path $instructionsDir | Out-Null

function Get-Description {
  param([string]$Path)

  $line = Select-String -Path $Path -Pattern '^description:\s*(.*)$' | Select-Object -First 1
  if ($null -eq $line) {
    return ''
  }

  $desc = $line.Matches[0].Groups[1].Value.Trim()
  if ($desc.StartsWith('"') -and $desc.EndsWith('"')) {
    $desc = $desc.Substring(1, $desc.Length - 2)
  }

  return $desc
}

function Get-BodyWithoutFrontmatter {
  param([string]$Path)

  $content = Get-Content -LiteralPath $Path
  if ($content.Count -lt 3 -or $content[0].Trim() -ne '---') {
    return $content -join "`n"
  }

  $end = -1
  for ($i = 1; $i -lt $content.Count; $i++) {
    if ($content[$i].Trim() -eq '---') {
      $end = $i
      break
    }
  }

  if ($end -eq -1) {
    return $content -join "`n"
  }

  return ($content[($end + 1)..($content.Count - 1)] -join "`n")
}

foreach ($skill in $skills) {
  $src = Join-Path $ScriptDir "$skill/SKILL.md"
  $dest = Join-Path $instructionsDir "$skill.instructions.md"

  if (-not (Test-Path -LiteralPath $src -PathType Leaf)) {
    throw "Missing source skill: $src"
  }

  if ($Mode -eq 'link') {
    if (Test-Path -LiteralPath $dest) {
      Remove-Item -LiteralPath $dest -Force
    }

    New-Item -ItemType SymbolicLink -Path $dest -Target $src | Out-Null
    Write-Host "linked $skill.instructions.md -> $src"
    continue
  }

  $desc = Get-Description -Path $src
  $body = Get-BodyWithoutFrontmatter -Path $src

  $text = @(
    '---'
    'applyTo: "**"'
    ('description: "' + ($desc.Replace('"', '\"')) + '"')
    '---'
    ''
    ('# ' + $skill + ' Skill')
    ''
    ('Imported from AgentiveStack/skills `' + $skill + '/SKILL.md`.')
    ''
    $body
    ''
  ) -join "`n"

  Set-Content -LiteralPath $dest -Value $text -NoNewline
  Write-Host "created $skill.instructions.md"
}

$copilotInstructions = @'
# Agentive Skills for Copilot

This repository uses Agentive workflow skills adapted for VS Code Copilot instructions.

## How to use

When planning or implementing work, explicitly request one of these workflows in chat:

- "Use the spec skill"
- "Use the domain skill"
- "Use the slice skill"
- "Use the tdd skill"
- "Use the holistic skill"
- "Use the architect skill"
- "Use the qa skill"

The full instructions are in `.github/instructions/*.instructions.md`.

## Working agreement

- Prefer domain language from `docs/UBIQUITOUS_LANGUAGE.md` when present.
- Respect bounded contexts and contracts from `docs/CONTEXT_MAP.md` and `docs/contexts/*/CONTEXT.md`.
- Prefer vertical slices and tracer-bullet delivery.
- Use pragmatic TDD: test core logic and boundaries, keep UI/glue testing proportional.
'@

Set-Content -LiteralPath (Join-Path $TargetRepo '.github/copilot-instructions.md') -Value $copilotInstructions -NoNewline

Write-Host ""
Write-Host "Installed Copilot instruction files to: $TargetRepo/.github"
Write-Host "Mode: $Mode"
Write-Host ("Skills: " + ($skills -join ', '))
