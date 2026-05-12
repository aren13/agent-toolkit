# .gitignore defaults by project type

Pick the template that matches the project type. When in doubt, use `general`. You can also concatenate templates if a project mixes types (e.g., `research` + `code`).

## general

Use for: writing, research, mixed, or unknown.

```
# OS
.DS_Store
Thumbs.db

# Editors
.vscode/
.idea/
*.swp
*.swo
*~

# Claude Code
.claude/local/
.claude/settings.local.json

# Env / secrets
.env
.env.local
*.key
*.pem

# Output / scratch
/tmp/
/scratch/
/.cache/
```

## code

Use for: software/coding projects. Append to `general`.

```
# Dependencies
node_modules/
vendor/
.venv/
__pycache__/
*.pyc

# Build output
dist/
build/
out/
*.log

# Test coverage
coverage/
.nyc_output/
```

## research

Use for: research/notes/data projects. Append to `general`.

```
# Data — usually too large or sensitive for a public-pattern repo
data/raw/
data/private/
*.csv
*.parquet
*.xlsx

# Notebook checkpoints
.ipynb_checkpoints/

# Outputs
exports/
figures/local/
```

## writing

Use for: writing/documentation projects. Append to `general`.

```
# Drafts that shouldn't be committed
*.draft.md
drafts/local/

# Build artifacts
_site/
public/
.next/
```

## How workflows pick

1. Start with `general`.
2. Append the project-type-specific block if applicable.
3. Write to `./.gitignore`.
