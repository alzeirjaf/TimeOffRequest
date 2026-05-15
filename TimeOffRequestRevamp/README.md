# Time Off Request Revamp

This folder is a complete rebuild package for the existing Time Off Request Power App. It keeps the original app exports untouched and gives you everything needed to recreate the refreshed version in Power Apps Studio.

## Start Here

Use these files in this order:

1. `prototype/index.html`
   - Visual reference for the final blue-white glass UI and Poppins-style typography.

2. `powerfx/theme-and-layout.fx`
   - App theme variables, colors, font name, and reusable style values to paste into Power Apps.

3. `power-apps-build-checklist.md`
   - Step-by-step instructions for recreating the app in Power Apps Studio.

4. `powerfx/all-formulas.fx`
   - All important formulas in one paste-ready file.

5. `build-guide.md`
   - Longer screen notes and implementation guidance.

## Goals

- Make the request form easier to understand at a glance.
- Show the employee the requested duration before they submit.
- Include the requested duration in the manager notification email.
- Include the selected start/end times because some requests may only be a few hours.
- Make manager review faster by showing employee, leave type, start/end time, duration, reason, and status in one clean request card.
- Keep the existing SharePoint list/data source shape: `TimeOffRequests`.

## Recommended App Structure

Use these screens in the new app:

1. `scrnRequestNew`
   - Employee creates a leave request.
   - Main content is one clean form panel with a live summary panel.
   - Submit button stays disabled until start date, end date, and leave type are present.

2. `scrnMyRequestsNew`
   - Employee sees their own requests in compact cards.
   - Each card shows status, leave type, start/end date and time, duration, and reason.

3. `scrnCalendarNew`
   - Calendar view keeps the month layout but uses softer day cells and status chips.
   - Approved leave displays as short chips instead of large text blocks.

4. `scrnManagerNew`
   - Manager dashboard uses filters across the top.
   - Request cards show duration directly so the manager does not have to calculate it.

## Font Note

The HTML mockup uses `Poppins`. In Power Apps, set controls to:

```powerfx
varFontMain
```

Where `varFontMain` is set in `powerfx/theme-and-layout.fx`:

```powerfx
"Poppins"
```

If Power Apps does not render Poppins consistently for all users, change `varFontMain` to:

```powerfx
"Arial"
```

## Power Apps Glass Approximation

Canvas Apps cannot exactly reproduce CSS `backdrop-filter` blur. Use these approximations:

- Translucent white fills
- Light blue borders
- Rounded panels and pill buttons
- Soft shadows where supported
- Generous padding
- Consistent Poppins/Arial typography

## Files

- `prototype/index.html`: HTML mockup for the refreshed visual direction.
- `power-apps-build-checklist.md`: practical Power Apps Studio build steps.
- `design-reference.md`: typography, color, shape, and status chip reference.
- `build-guide.md`: screen-by-screen implementation notes.
- `powerfx/theme-and-layout.fx`: app-level theme variables.
- `powerfx/all-formulas.fx`: combined paste-ready formulas.
- `powerfx/submit-request-onsuccess.fx`: replacement `frmTimeOffRequest.OnSuccess` formula with date, time, and duration in the manager email.
- `powerfx/duration-formulas.fx`: reusable duration formulas for labels, cards, and validation.
- `powerfx/manager-actions.fx`: improved approve/deny formulas that also include date, time, and duration.
