# Time Off Request Revamp

This folder is a separate rebuild package for the existing Power App. It does not overwrite the copied 2025 screen exports.

## Goals

- Make the request form easier to understand at a glance.
- Show the employee the requested duration before they submit.
- Include the requested duration in the manager notification email.
- Make manager review faster by showing employee, leave type, dates, duration, reason, and status in one clean request row/card.
- Keep the existing SharePoint list/data source shape: `TimeOffRequests`.

## Recommended App Structure

Use these screens in the new app:

1. `scrnRequestNew`
   - Employee creates a leave request.
   - Main content is one clean form panel with a live summary panel.
   - Submit button stays disabled until start date, end date, and leave type are present.

2. `scrnMyRequestsNew`
   - Employee sees their own requests in compact cards.
   - Each card shows status, leave type, date range, duration, and reason.

3. `scrnCalendarNew`
   - Calendar view keeps the month layout but uses softer day cells and status chips.
   - Approved leave displays as short chips instead of large text blocks.

4. `scrnManagerNew`
   - Manager dashboard uses filters across the top.
   - Request rows/cards show duration directly so the manager does not have to calculate it.

## Visual Direction

- Background: `RGBA(247, 249, 252, 1)`
- Primary: `RGBA(16, 86, 185, 1)`
- Primary hover: `RGBA(11, 66, 145, 1)`
- Text: `RGBA(31, 41, 55, 1)`
- Muted text: `RGBA(107, 114, 128, 1)`
- Border: `RGBA(226, 232, 240, 1)`
- Success: `RGBA(22, 163, 74, 1)`
- Warning: `RGBA(217, 119, 6, 1)`
- Error: `RGBA(220, 38, 38, 1)`

Use an app header with the title `Time Off Request`, then a simple top navigation:

- Request
- My Requests
- Calendar
- Manager

Avoid the current bottom navigation because it forces the user to scan away from the work area and makes the app feel less polished on desktop.

## Files

- `powerfx/submit-request-onsuccess.fx`: replacement `frmTimeOffRequest.OnSuccess` formula with leave duration in the manager email.
- `powerfx/duration-formulas.fx`: reusable duration formulas for labels, cards, and validation.
- `powerfx/manager-actions.fx`: improved approve/deny email formulas that also include duration.
- `build-guide.md`: screen-by-screen implementation notes for rebuilding the new app in Power Apps Studio.
- `prototype/index.html`: clickable-free visual mockup of the refreshed UI direction.
