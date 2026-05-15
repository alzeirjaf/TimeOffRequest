# Power Apps Build Checklist

This checklist recreates the `prototype/index.html` design in Power Apps Studio as closely as Canvas Apps allow.

Canvas Apps do not support true CSS glass blur, but the same feel can be built with translucent white fills, light blue borders, soft shadows, rounded corners, and a consistent Poppins/Arial font.

## 1. Create The New App

1. Create a new tablet canvas app.
2. Name it `Time Off Request Revamp`.
3. Add data source `TimeOffRequests`.
4. Add the Office 365 Outlook connector.
5. In `App.OnStart`, paste the formula from `powerfx/theme-and-layout.fx`.
6. Run `App.OnStart`.

## 2. App-Wide Settings

Set these where available:

- App background: `varColorBackground`
- Main font: `varFontMain`
- Screen fill: `varColorBackground`

Use `varFontMain` for every label, input, button, dropdown, gallery text, and header text.

## 3. Screen Names

Create these screens:

- `scrnRequestNew`
- `scrnMyRequestsNew`
- `scrnCalendarNew`
- `scrnManagerNew`

Keep the old screens only as reference until the new version is done.

## 4. Shared Header

At the top of each screen, create a horizontal container:

- Height: `72`
- Width: `Parent.Width`
- Fill: `RGBA(255, 255, 255, 0.66)`
- BorderColor: `varColorBorder`
- PaddingLeft/Right: `28`

Inside it:

- Left label: `Time Off Request`
- Font: `varFontMain`
- Size: `21`
- Weight: `FontWeight.Semibold`

Add top navigation buttons:

- `Request` navigates to `scrnRequestNew`
- `My Requests` navigates to `scrnMyRequestsNew`
- `Calendar` navigates to `scrnCalendarNew`
- `Manager` navigates to `scrnManagerNew`

Button style:

- Font: `varFontMain`
- Size: `16`
- BorderRadius: `varRadiusPill`
- Fill active: `varColorGlassStrong`
- Fill inactive: `varColorGlass`
- Color: `varColorPrimaryDark`

## 5. Request Screen

Create the main area as two panels:

- Left panel: request form
- Right panel: request summary

Panel style:

- Fill: `varColorPanel`
- BorderColor: `varColorBorder`
- BorderRadius: `varRadiusPanel`
- Padding: `24`

Title label:

- Text: `New Time Off Request`
- Font: `varFontMain`
- Size: `24`
- Weight: `FontWeight.Semibold`

Subtitle label:

- Text: `Choose your dates, leave type, and add any context your manager should know.`
- Color: `varColorMuted`
- Size: `14`

Use an edit form named `frmTimeOffRequest`:

- DataSource: `TimeOffRequests`
- DefaultMode: `FormMode.New`
- Include: `Start Date`, `End Date`, `Leave Type`, `Reason`

Rename or confirm these controls exist:

- Start date picker: `StartDate_Input`
- Start hour dropdown: `StartHour`
- Start minute dropdown: `StartMinute`
- End date picker: `EndDate_Input`
- End hour dropdown: `EndHour`
- End minute dropdown: `EndMinute`
- Leave type combo box: `DataCardValue13`
- Reason text input: `DataCardValue17`

Set `frmTimeOffRequest.OnSuccess` to `powerfx/submit-request-onsuccess.fx`.

Set submit button:

- Text: `Submit request`
- OnSelect: `SubmitForm(frmTimeOffRequest)`
- DisplayMode: use the submit `DisplayMode` formula in `powerfx/duration-formulas.fx`

## 6. Request Summary Panel

Create a right-side panel with title:

- Text: `Request Summary`
- Font: `varFontMain`
- Size: `24`
- Weight: `FontWeight.Semibold`

Add summary labels:

- Employee: `User().FullName`
- Leave type: `Coalesce(DataCardValue13.Selected.Value, "Not selected")`
- Start: selected start date/time
- End: selected end date/time
- Duration: use the live duration formula from `powerfx/duration-formulas.fx`

Status chip:

- Text: `Pending manager review`
- Fill: `varColorChipBlue`
- Color: `varColorPrimaryDark`
- BorderRadius: `varRadiusPill`

## 7. My Requests Screen

Create gallery `galMyRequests`.

Items:

```powerfx
SortByColumns(
    Filter(TimeOffRequests, Email = User().Email),
    "SubmittedDate",
    SortOrder.Descending
)
```

If `SubmittedDate` fails because SharePoint uses a different internal name, use:

```powerfx
Filter(TimeOffRequests, Email = User().Email)
```

Each card should show:

- Leave type
- Status chip
- Start date/time
- End date/time
- Duration
- Reason
- Delete button only for pending requests

Delete button:

```powerfx
Remove(TimeOffRequests, ThisItem);
Notify("Request deleted successfully.", NotificationType.Success)
```

Visible:

```powerfx
ThisItem.Status.Value = "Pending"
```

## 8. Calendar Screen

Use the existing calendar logic from `scrnCalendar.txt`.

Keep:

- `varCurrentMonth`
- `colCalendarDays`
- Previous/next month logic
- Approved request filtering

Restyle:

- Screen fill: `varColorBackground`
- Day cell fill: `varColorGlassStrong`
- Day cell border: `varColorBorder`
- Day cell radius: `14`
- Approved leave chips: `varColorChipBlue`

Approved request chip text:

```powerfx
If(
    varShowAll,
    ThisItem.Title & " - " & ThisItem.'Leave Type'.Value,
    ThisItem.'Leave Type'.Value
)
```

## 9. Manager Screen

Create `scrnManagerNew`.

Top filter row:

- Status dropdown
- Leave type dropdown
- Employee dropdown
- Clear filters button

Manager gallery `galManagerRequests.Items`:

```powerfx
Filter(
    TimeOffRequests,
    (IsBlank(Dropdown_EmployeeName.Selected.Value) || Title = Dropdown_EmployeeName.Selected.Value) &&
    (IsBlank(Dropdown_LeaveType.Selected.Value.Value) || 'Leave Type'.Value = Dropdown_LeaveType.Selected.Value.Value) &&
    (IsBlank(Dropdown_Status.Selected.Value.Value) || Status.Value = Dropdown_Status.Selected.Value.Value)
)
```

Each row/card should show:

- Employee name
- Leave type
- Start and end date/time
- Duration
- Status chip
- Reason
- Approve button
- Deny button

Use `powerfx/manager-actions.fx` for approve/deny actions.

## 10. Manager Access

For now, use the existing hard-coded manager email check:

```powerfx
User().Email = "IGREWAL1@calgary.ca"
```

Apply it to the Manager nav button `Visible` property.

## 11. Final Checks

Before sharing the app:

- Submit a 4-hour request and confirm the manager email says `4 hours`.
- Submit a multi-day request and confirm the manager email includes calendar days and hours.
- Approve a request and confirm employee receives date, time, and duration.
- Deny a request and confirm employee receives date, time, and duration.
- Check that Poppins renders in Play mode.
- If Poppins does not render, change `varFontMain` in `App.OnStart` to `"Arial"`.
