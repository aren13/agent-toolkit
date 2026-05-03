# Prompt Shorthand Modes

Speech-to-text friendly shortcuts for AI coding assistants. Say `[word] mode` in your prompt to activate the corresponding behavior.

## Research & Analysis

| Shorthand | What it triggers |
|-----------|-----------------|
| **drill mode** | Read all relevant code, explore thoroughly, consider multiple hypotheses before acting. Never assume — verify everything first. |
| **xray mode** | Map the complete execution/data flow end-to-end before responding. Trace every layer. |
| **rca mode** | Root Cause Analysis. Don't fix symptoms. Ask "why" repeatedly until the actual root cause is found. |

## Completion & Validation

| Shorthand | What it triggers |
|-----------|-----------------|
| **seal mode** | Implement + test + fix until it actually works. Do not stop at "should work" — run it and prove it. |
| **prove mode** | Define explicit success criteria, write tests/checks, run them, and show green results before declaring done. |
| **clamp mode** | Keep looping fix → test → fix until zero failures. Do not ask if you should continue — just keep going. |

## Combos

| Shorthand | What it triggers |
|-----------|-----------------|
| **ironclad mode** | Full combination: drill + seal + prove. Maximum thoroughness at every stage — deep research, complete implementation, and validated results. |
| **full send mode** | Don't over-ask for clarification. You have enough context — just execute autonomously and deliver results. |

## Usage Examples

```
fix the login bug, rca mode, clamp mode
```

```
add dark mode to settings, ironclad mode
```

```
refactor the auth service, drill mode
```

```
deploy the feature, full send mode
```

## Why "mode" suffix?

- Works with speech-to-text (no special characters needed)
- No clash with technical terms (e.g., "trace", "ship", "lock" all have software meanings)
- Natural to say in conversation
- Unambiguous — "[word] mode" is always a shorthand trigger, never a technical instruction

## How to use with other AI tools

Copy the shorthand table into your AI tool's system prompt or custom instructions. The key instruction is:

> When the user says "[word] mode" in their prompt, activate the corresponding behavior described in the table.
