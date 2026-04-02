# PR Description Template

Use this template when creating pull requests:

```markdown
## Summary
[2-3 sentence overview of changes and motivation]

## Changes
- [Key change 1 with file references]
- [Key change 2 with file references]
- [Key change 3 with file references]

## Technical Details
### Before
[Previous behavior or architecture]

### After
[New behavior or architecture]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] Edge cases covered

## Database
- [ ] Migration included (if applicable)
- [ ] Migration reversible
- [ ] Indexes added for new queries

## Security
- [ ] No sensitive data exposed
- [ ] Authorization checks in place
- [ ] SQL injection prevention verified
- [ ] XSS prevention verified

## Performance
- [ ] No N+1 queries introduced
- [ ] Eager loading used appropriately
- [ ] Background jobs for heavy operations
- [ ] Database indexes for new queries

## Documentation
- [ ] Code comments for complex logic
- [ ] README updated (if needed)
- [ ] API docs updated (if API changes)

## Deployment Notes
[Any special deployment considerations, environment variables, manual steps]

## Related Issues
Refs: #[ticket-number]
```
