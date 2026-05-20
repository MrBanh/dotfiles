---
name: write-a-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill.
---

# Writing Skills

## Process

1. **Gather requirements** - ask user about:
   - What task/domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials to include?

2. **Draft the skill** - create:
   - `SKILL.md` with concise instructions (required)
   - Optional — only create if needed:
     - `scripts/` for utility scripts when deterministic operations are needed
     - `references/` for supplementary docs when SKILL.md exceeds 100 lines
     - `assets/` for templates, schemas, or static files the skill references

3. **Review with user** - present draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more/less detailed?

## Skill Structure

```
skill-name/
├── SKILL.md           # Required: Main instructions
├── scripts/           # Optional: Utility scripts
│   └── helper.js
├── references/        # Optional: Supplementary detailed docs
│   └── example.md
└── assets/            # Optional: Templates, schemas, static files
    └── example.jpg
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflows

[Step-by-step processes with checklists for complex tasks]

## Advanced features

[Link to separate files: See [references/example.md](references/example.md)]
```

## Description Requirements

The description is **the only thing your agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside all other installed skills. Your agent reads these descriptions and picks the relevant skill based on the user's request.

**Goal**: Give your agent just enough info to know:

1. What capability this skill provides
2. When/why to trigger it (specific keywords, contexts, file types)

**Format**:

- Max 1024 chars
- Write in third person
- First sentence: what it does
- Second sentence: "Use when [specific triggers]"

**Good example**:

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**Bad example**:

```
Helps with documents.
```

The bad example gives your agent no way to distinguish this from other document skills.

## When to Add Scripts

Place utility scripts under `scripts/` when:

- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

Scripts save tokens and improve reliability vs generated code.

## When to Add References

Place supplementary docs under `references/` when:

- SKILL.md exceeds 100 lines
- Content has distinct domains (finance vs sales schemas)
- Advanced features are rarely needed and should load on demand

Link to them from SKILL.md (e.g. `See [references/schemas.md](references/schemas.md)`) so the agent only loads them when needed.

## When to Add Assets

Place static files under `assets/` when the skill needs:

- Templates (boilerplate files to copy)
- Schemas (JSON Schema, config templates)
- Images or other binary fixtures referenced by the skill

## Review Checklist

After drafting, verify:

- [ ] Description includes triggers ("Use when...")
- [ ] SKILL.md under 100 lines
- [ ] Long-form content lives in `references/`, not inline
- [ ] Deterministic logic lives in `scripts/`, not prose
- [ ] Static files (templates, schemas) live in `assets/`
- [ ] No time-sensitive info
- [ ] Consistent terminology
- [ ] Concrete examples included
- [ ] References one level deep
