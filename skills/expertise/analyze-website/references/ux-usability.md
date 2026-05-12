<overview>
Usability ensures websites are easy to use and understand. Nielsen's 10 Heuristics provide a framework for evaluation. Good UX leads to higher engagement, conversion, and user satisfaction.
</overview>

<nielsen_heuristics>
## Nielsen's 10 Usability Heuristics

<heuristic number="1" name="Visibility of System Status">
Keep users informed about what's happening.

**Examples:**
- Loading indicators
- Progress bars
- Form submission confirmation
- "Saving..." status

**Check:** Does the user always know what's happening?
</heuristic>

<heuristic number="2" name="Match Between System and Real World">
Use familiar language and concepts.

**Examples:**
- Use "Shopping Cart" not "Purchase Queue"
- Icons match real-world metaphors
- Familiar patterns (trash = delete)

**Check:** Would a new user understand the terminology?
</heuristic>

<heuristic number="3" name="User Control and Freedom">
Provide exits and undo options.

**Examples:**
- Cancel buttons
- Undo functionality
- Clear navigation to exit flows
- Back button works

**Check:** Can users easily back out of actions?
</heuristic>

<heuristic number="4" name="Consistency and Standards">
Follow platform conventions.

**Examples:**
- Links are blue/underlined
- Primary actions are prominent
- Forms follow common patterns
- Icons used consistently

**Check:** Does the site follow web conventions?
</heuristic>

<heuristic number="5" name="Error Prevention">
Prevent errors before they happen.

**Examples:**
- Confirmation dialogs for destructive actions
- Input validation as you type
- Disabling invalid options
- Clear constraints

**Check:** Does the design prevent common mistakes?
</heuristic>

<heuristic number="6" name="Recognition Rather Than Recall">
Make options visible, don't require memory.

**Examples:**
- Visible navigation
- Search suggestions/autocomplete
- Recently viewed items
- Clear labels on everything

**Check:** Does the user need to remember information?
</heuristic>

<heuristic number="7" name="Flexibility and Efficiency of Use">
Cater to both novice and expert users.

**Examples:**
- Keyboard shortcuts
- Quick actions
- Saved preferences
- Customizable settings

**Check:** Can power users be efficient?
</heuristic>

<heuristic number="8" name="Aesthetic and Minimalist Design">
Only show what's needed.

**Examples:**
- Clean layouts
- Focused content
- Minimal distractions
- Clear visual hierarchy

**Check:** Is there anything that could be removed?
</heuristic>

<heuristic number="9" name="Help Users Recognize and Recover from Errors">
Error messages should be helpful.

**Examples:**
- "Email is invalid" not "Error 422"
- Suggest how to fix
- Highlight the field with error
- Don't clear valid fields

**Check:** Do error messages help users recover?
</heuristic>

<heuristic number="10" name="Help and Documentation">
Provide accessible help when needed.

**Examples:**
- Tooltips
- FAQ sections
- Contextual help
- Search functionality

**Check:** Can users find help easily?
</heuristic>
</nielsen_heuristics>

<form_usability>
## Form Usability

**Labels:**
```html
<!-- Always use labels, not placeholders alone -->
<label for="email">Email address</label>
<input type="email" id="email" name="email">
```

**Error handling:**
```html
<!-- Clear, specific errors -->
<label for="phone">Phone number</label>
<input type="tel" id="phone" aria-invalid="true" aria-describedby="phone-error">
<span id="phone-error" class="error">Please enter a 10-digit phone number</span>
```

**Required fields:**
- Mark required fields clearly
- Don't just use asterisks
- Consider "(required)" or "(optional)"

**Input types:**
- Use `type="email"` for email (shows @ keyboard on mobile)
- Use `type="tel"` for phone
- Use `type="number"` for numbers
- Use `inputmode` for more control

**Validation:**
- Validate on blur, not just submit
- Show errors near the field
- Don't lose user's input
- Be forgiving with formats
</form_usability>

<navigation_usability>
## Navigation Usability

**Primary navigation:**
- Visible and consistent across pages
- Clear current page indication
- Limited items (7±2 rule)
- Mobile-friendly hamburger or bottom nav

**Breadcrumbs:**
```html
<nav aria-label="Breadcrumb">
  <ol>
    <li><a href="/">Home</a></li>
    <li><a href="/products">Products</a></li>
    <li aria-current="page">Blue Widget</li>
  </ol>
</nav>
```

**Search:**
- Visible and accessible
- Autocomplete suggestions
- Clear results display
- Handle "no results" gracefully

**Footer:**
- Secondary navigation
- Contact info
- Legal links
- Sitemap link
</navigation_usability>

<loading_states>
## Loading States

**Button states:**
```html
<button disabled aria-busy="true">
  <span class="spinner"></span>
  Saving...
</button>
```

**Content loading:**
- Skeleton screens (preferred over spinners)
- Progress indicators for long operations
- Optimistic updates when safe

**Error states:**
- Clear error message
- Retry option
- Fallback content if possible
</loading_states>

<cognitive_load>
## Reducing Cognitive Load

**Chunking:**
- Break long forms into steps
- Group related information
- Use progressive disclosure

**Hierarchy:**
- Clear visual hierarchy
- Most important information prominent
- Scannable headings

**Defaults:**
- Smart defaults reduce decisions
- Remember user preferences
- Pre-fill known information

**Microcopy:**
- Helpful instructions where needed
- Clear button labels
- Informative tooltips
</cognitive_load>

<usability_checklist>
## Usability Checklist

**Navigation:**
- [ ] Can find main navigation easily
- [ ] Know where you are in the site
- [ ] Can return to homepage easily
- [ ] Search is accessible

**Content:**
- [ ] Text is readable
- [ ] Information is scannable
- [ ] Images support content
- [ ] Videos have controls

**Interaction:**
- [ ] Buttons look clickable
- [ ] Links are distinguishable
- [ ] Forms are easy to complete
- [ ] Errors are helpful

**Feedback:**
- [ ] Loading states present
- [ ] Actions confirmed
- [ ] Errors explained
- [ ] Success communicated

**Mobile:**
- [ ] Touch targets adequate
- [ ] Content fits screen
- [ ] Forms usable
- [ ] Navigation works
</usability_checklist>

<testing_methods>
## Usability Testing Methods

**Heuristic evaluation:**
- Review against Nielsen's heuristics
- 3-5 evaluators find 75% of issues
- Quick and cost-effective

**Cognitive walkthrough:**
- Walk through key user tasks
- Note friction points
- Test with fresh perspective

**User testing:**
- Watch real users complete tasks
- 5 users find 85% of issues
- Most valuable but most effort

**A/B testing:**
- Test design variations
- Data-driven decisions
- Requires traffic volume
</testing_methods>
