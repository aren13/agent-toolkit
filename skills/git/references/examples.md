# Workflow Examples

## Example 1: Bug Fix with Migration

```bash
git checkout -b fix/donation-invoiceable-scope
git add app/models/donation.rb spec/models/donation_spec.rb
git commit -m "fix(models): replace memory-intensive donation scopes with SQL

PROBLEM:
- not_invoiceable scope loaded all IDs into Ruby memory
- Array subtraction caused O(n) memory usage
- Performance degraded with large datasets

SOLUTION:
- Use SQL subquery for not_invoiceable scope
- Replace select(&:approved?) with SQL joins
- Maintain semantic equivalence with tests

IMPACT:
- Memory: O(n) -> O(1)
- Query: Multiple + Ruby -> Single SQL
- Tests: 10 new specs, all passing

Refs: #6297"

git push -u origin fix/donation-invoiceable-scope
gh pr create --title "Fix memory-intensive donation scopes" --body "..."
```

## Example 2: Feature with Documentation

Multiple logical commits on a single branch:

```bash
git checkout -b feat/sms-6350-ai-menu-analysis

# Commit 1: Services
git add app/services/ai/ app/services/iot/smart_scale/
git commit -m "feat(services): add AI vision clients for menu analysis

Add abstraction layer for AI vision providers:
- Ai::BaseVisionClient abstract base class
- Ai::AnthropicVisionClient for Claude Sonnet
- Ai::OpenaiVisionClient for GPT-4o
- Iot::SmartScale::AiMenuItemSuggestionService orchestrator

Supports image analysis for menu item matching with
confidence scoring and multi-provider fallback.

Refs: #6350"

# Commit 2: UI layer
git add app/controllers/admin/iot/ app/views/admin/iot/ app/helpers/
git commit -m "feat(iot): add AI analysis UI for smart scale measurements

Add admin interface for AI-powered menu item analysis:
- AiAnalysesController with index/show/analyze actions
- Search by measurement ID or scale+date
- Result view with confidence-scored suggestions
- Helper for confidence color formatting

Refs: #6350"

# Commit 3: Docs
git add docs/features/iot/
git commit -m "docs(iot): add AI menu analysis feature guide

Document AI vision analysis feature including:
- Architecture overview
- Provider configuration
- Usage examples
- API integration details

Refs: #6350"

git push -u origin feat/sms-6350-ai-menu-analysis
gh pr create --title "Add AI vision analysis for smart scale menu matching" --body "..."
```

## Example 3: Refactoring (Incremental Commits)

```bash
git checkout -b refactor/extract-approval-logic

# Commit 1: Create service
git add app/services/approval_service.rb spec/services/
git commit -m "refactor(services): extract approval workflow to service object

Extract approval logic from Approvable concern into
dedicated ApprovalService for better testability and
single responsibility.

- Handles multi-user approval requirements
- Manages approval state transitions
- Validates approver permissions

No behavior changes, semantically equivalent.

Refs: #6401"

# Commit 2: Update models
git add app/models/concerns/approvable.rb app/models/donation.rb
git commit -m "refactor(models): delegate approval logic to service

Update Approvable concern and Donation model to use
new ApprovalService instead of inline logic.

Reduces model complexity from 425 -> 380 lines.

Refs: #6401"

# Commit 3: Update tests
git add spec/models/donation_spec.rb spec/models/concerns/
git commit -m "test(models): update approval specs for service delegation

Update tests to reflect service-based approval workflow.
All existing tests passing, coverage maintained at 85%.

Refs: #6401"
```
