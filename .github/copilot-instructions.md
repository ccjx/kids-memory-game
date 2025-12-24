# GitHub Copilot Instructions

## Project Overview
This is a kids memory game project with a structured requirements and implementation planning workflow.

## Request Classification

When the user makes a request, first determine if it's a **Requirement** (what to build) or an **Implementation** (how/when to build it).

### Handling Requirements

If the user describes a feature, functionality, or behavior:

1. Create a new requirement file: `/requirements/R{ID}.md` (e.g., R001.md, R002.md)
2. Follow this template:

```markdown
# R{ID}: [Title]

## Overview
Brief description of what this requirement aims to achieve.

## Detailed Description
Comprehensive explanation of the requirement, including context and rationale.

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Dependencies
- None / List of other requirement IDs this depends on

## Notes
Any additional information, constraints, or considerations.

## Related Plans
- [P-R{ID}](../plans/P-R{ID}.md) - If implementation plan exists

---
**Status**: Not Started  
**Created**: YYYY-MM-DD  
**Last Updated**: YYYY-MM-DD
```

3. Update `/requirements/index.md`:
```markdown
| R{ID} | [Short Title] | Not Started |
```

### Handling Implementation Requests

If the user asks to implement a requirement (must reference R{ID}):

1. Create implementation plan: `/plans/P-R{ID}.md`
2. Follow this template:

```markdown
# P-R{ID}: Implementation Plan for R{ID}

## Requirement Reference
[R{ID}: Title](../requirements/R{ID}.md)

## Objective
Clear statement of what this implementation will achieve.

## Proposed Approach
Detailed explanation of how the requirement will be implemented.

## Implementation Steps
1. Step 1 description
2. Step 2 description
3. Step 3 description

## Files to be Modified/Created
- `path/to/file1.ext` - Description of changes
- `path/to/file2.ext` - Description of changes

## Technical Considerations
- Performance implications
- Security considerations
- Compatibility requirements
- Testing approach

## Clarification Needed
- [ ] Question 1?
- [ ] Question 2?

## Risks and Mitigation
- **Risk 1**: Description and mitigation strategy
- **Risk 2**: Description and mitigation strategy

## Estimated Effort
Time/complexity estimate if applicable

---
**Status**: Proposed  
**Created**: YYYY-MM-DD  
**Last Updated**: YYYY-MM-DD  
**Approved By**: N/A
```

3. Update `/plans/plans-index.md`:
```markdown
| P-R{ID} | R{ID} | [Short Title] | Proposed |
```

4. **Ask clarification questions** if anything is unclear in the requirement
5. **Present the plan and WAIT for user approval** before implementing
6. After approval, implement and update statuses:
   - Plan status → "Implemented"
   - Requirement status → "Completed"

## Critical Rules

- ✅ Always create requirement files before implementation plans
- ✅ Update both index files when adding new requirements or plans
- ✅ **When user provides clarifications or updates to requirements, always update the corresponding requirement file(s)**
- ✅ Ask clarifying questions rather than making assumptions
- ✅ NEVER implement without explicit user approval of the plan
- ✅ Maintain traceability: R{ID} ↔ P-R{ID}
- ✅ Use dates in YYYY-MM-DD format

## Status Values

**Requirements:**
- Not Started
- WIP
- Completed

**Plans:**
- Proposed
- Rejected
- Implemented

## Workflow

```
User Request
    ↓
Is it Requirement or Implementation?
    ↓                    ↓
Requirement        Implementation
    ↓                    ↓
Create R{ID}.md    Must have R{ID}
Update index           ↓
                   Create P-R{ID}.md
                   Update plans-index
                       ↓
                   Clarify if needed
                       ↓
                   Present & Wait for Approval
                       ↓
                   Implement
                       ↓
                   Update statuses
```
