# Power Apps Rebuild Guide

## 1. Data

Keep the existing `TimeOffRequests` data source and fields:

- `Title`
- `Start Date`
- `End Date`
- `Leave Type`
- `Reason`
- `Status`
- `Submitted Date`
- `Approved Date`
- `Denied Date`
- `Email`

No new column is required for duration because it can be calculated from start and end dates.

## 2. Request Screen

Create `scrnRequestNew`.

Recommended layout:

- Header container, height `72`
- Main horizontal container
- Left panel: `frmTimeOffRequest`
- Right panel: live request summary

Form improvements:

- Rename title/header from `My Requests` to `New Time Off Request`.
- Keep only one label for each field:
  - `Start`
  - `End`
  - `Leave type`
  - `Reason`
- Put each date and time picker in the same visual row.
- Add helper text under Reason: `Optional, but helpful for your manager.`
- Use the formula in `powerfx/duration-formulas.fx` for a live summary label.
- Set submit button text to `Submit request`.
- Set submit button `DisplayMode` from `powerfx/duration-formulas.fx`.
- Replace `frmTimeOffRequest.OnSuccess` with `powerfx/submit-request-onsuccess.fx`.

Summary panel should show:

- Employee: `User().FullName`
- Leave type
- Start date and time
- End date and time
- Duration, including hours for same-day or partial-day leave
- Status after submit: `Pending manager review`

## 3. My Requests Screen

Create `scrnMyRequestsNew`.

Gallery item formula:

```powerfx
SortByColumns(
    Filter(TimeOffRequests, Email = User().Email),
    "SubmittedDate",
    SortOrder.Descending
)
```

If `SubmittedDate` does not work because of the SharePoint internal name, keep the current filter and sort manually in the view.

Each card should show:

- Leave type as the main title.
- Status chip using green, amber, or red.
- Start and end date/time.
- Duration using the gallery formula in `powerfx/duration-formulas.fx`.
- Reason preview.
- Delete button only when status is `Pending`.

## 4. Calendar Screen

Create `scrnCalendarNew`.

Keep the existing month-generation logic. Improve the display:

- Month header on the left.
- Previous/next icon buttons beside it.
- `Show everyone` toggle on the right.
- Day cells with white fill, light border, and subtle current-month contrast.
- Approved requests shown as small chips:

```powerfx
If(
    varShowAll,
    ThisItem.Title & " - " & ThisItem.'Leave Type'.Value,
    ThisItem.'Leave Type'.Value
)
```

## 5. Manager Screen

Create `scrnManagerNew`.

Filter area:

- Status
- Leave type
- Employee
- Clear filters button

Gallery item formula can stay close to the current one:

```powerfx
Filter(
    TimeOffRequests,
    (IsBlank(Dropdown_EmployeeName.Selected.Value) || Title = Dropdown_EmployeeName.Selected.Value) &&
    (IsBlank(Dropdown_LeaveType.Selected.Value.Value) || 'Leave Type'.Value = Dropdown_LeaveType.Selected.Value.Value) &&
    (IsBlank(Dropdown_Status.Selected.Value.Value) || Status.Value = Dropdown_Status.Selected.Value.Value)
)
```

Each manager card/row should show:

- Employee name
- Leave type
- Start and end date/time
- Duration
- Reason
- Status
- Approve and deny buttons for pending requests only

Use `powerfx/manager-actions.fx` for the approve and deny button formulas.

## 6. Access

The existing manager button is hard-coded to:

```powerfx
User().Email = "IGREWAL1@calgary.ca"
```

That is fine for a quick rebuild. A cleaner future version would use a SharePoint list of manager emails, but that is not required for this revamp.
