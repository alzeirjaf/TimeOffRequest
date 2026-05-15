// Time Off Request Revamp - combined Power Fx formulas.
// Use this when you want one file to copy from while building in Power Apps Studio.

// ----------------------------------------------------------------------
// App.OnStart
// ----------------------------------------------------------------------

Set(varFontMain, "Poppins");

Set(varColorBackground, RGBA(238, 247, 255, 1));
Set(varColorPanel, RGBA(255, 255, 255, 0.76));
Set(varColorGlass, RGBA(255, 255, 255, 0.52));
Set(varColorGlassStrong, RGBA(255, 255, 255, 0.82));
Set(varColorPrimary, RGBA(47, 125, 225, 1));
Set(varColorPrimaryDark, RGBA(24, 93, 183, 1));
Set(varColorText, RGBA(31, 41, 55, 1));
Set(varColorMuted, RGBA(96, 112, 137, 1));
Set(varColorBorder, RGBA(176, 203, 231, 0.72));
Set(varColorChipBlue, RGBA(219, 234, 254, 0.86));
Set(varColorSuccess, RGBA(22, 163, 74, 1));
Set(varColorWarning, RGBA(217, 119, 6, 1));
Set(varColorError, RGBA(220, 38, 38, 1));

Set(varRadiusPanel, 18);
Set(varRadiusControl, 13);
Set(varRadiusCard, 16);
Set(varRadiusPill, 999);

Set(varHeaderHeight, 72);
Set(varPagePadding, 24);
Set(varPanelPadding, 24);

// ----------------------------------------------------------------------
// Request screen - submit button OnSelect
// ----------------------------------------------------------------------

SubmitForm(frmTimeOffRequest)

// ----------------------------------------------------------------------
// Request screen - submit button DisplayMode
// ----------------------------------------------------------------------

If(
    frmTimeOffRequest.Valid &&
    !IsBlank(StartDate_Input.SelectedDate) &&
    !IsBlank(EndDate_Input.SelectedDate) &&
    DateTime(
        Year(EndDate_Input.SelectedDate),
        Month(EndDate_Input.SelectedDate),
        Day(EndDate_Input.SelectedDate),
        Value(EndHour.Selected.Value),
        Value(EndMinute.Selected.Value),
        0
    ) >= DateTime(
        Year(StartDate_Input.SelectedDate),
        Month(StartDate_Input.SelectedDate),
        Day(StartDate_Input.SelectedDate),
        Value(StartHour.Selected.Value),
        Value(StartMinute.Selected.Value),
        0
    ),
    DisplayMode.Edit,
    DisplayMode.Disabled
)

// ----------------------------------------------------------------------
// Request screen - live duration label Text
// ----------------------------------------------------------------------

If(
    IsBlank(StartDate_Input.SelectedDate) || IsBlank(EndDate_Input.SelectedDate),
    "Select start and end dates",
    With(
        {
            requestStart: DateTime(
                Year(StartDate_Input.SelectedDate),
                Month(StartDate_Input.SelectedDate),
                Day(StartDate_Input.SelectedDate),
                Value(StartHour.Selected.Value),
                Value(StartMinute.Selected.Value),
                0
            ),
            requestEnd: DateTime(
                Year(EndDate_Input.SelectedDate),
                Month(EndDate_Input.SelectedDate),
                Day(EndDate_Input.SelectedDate),
                Value(EndHour.Selected.Value),
                Value(EndMinute.Selected.Value),
                0
            )
        },
        With(
            {
                durationDays: DateDiff(
                    Date(Year(requestStart), Month(requestStart), Day(requestStart)),
                    Date(Year(requestEnd), Month(requestEnd), Day(requestEnd)),
                    TimeUnit.Days
                ) + 1,
                durationHours: Round(DateDiff(requestStart, requestEnd, TimeUnit.Minutes) / 60, 1)
            },
            If(
                requestEnd < requestStart,
                "End date must be after start date",
                If(
                    durationDays = 1,
                    durationHours & If(durationHours = 1, " hour", " hours"),
                    durationDays & " calendar days / " & durationHours & " hours"
                )
            )
        )
    )
)

// ----------------------------------------------------------------------
// frmTimeOffRequest.OnSuccess
// ----------------------------------------------------------------------

With(
    {
        submittedRequest: frmTimeOffRequest.LastSubmit,
        requestStart: frmTimeOffRequest.LastSubmit.'Start Date',
        requestEnd: frmTimeOffRequest.LastSubmit.'End Date',
        durationDays: DateDiff(
            Date(
                Year(frmTimeOffRequest.LastSubmit.'Start Date'),
                Month(frmTimeOffRequest.LastSubmit.'Start Date'),
                Day(frmTimeOffRequest.LastSubmit.'Start Date')
            ),
            Date(
                Year(frmTimeOffRequest.LastSubmit.'End Date'),
                Month(frmTimeOffRequest.LastSubmit.'End Date'),
                Day(frmTimeOffRequest.LastSubmit.'End Date')
            ),
            TimeUnit.Days
        ) + 1,
        durationHours: Round(
            DateDiff(
                frmTimeOffRequest.LastSubmit.'Start Date',
                frmTimeOffRequest.LastSubmit.'End Date',
                TimeUnit.Minutes
            ) / 60,
            1
        )
    },
    Patch(
        TimeOffRequests,
        submittedRequest,
        {
            Title: User().FullName,
            'Submitted Date': Now(),
            Status: {Value: "Pending"},
            Email: User().Email
        }
    );
    Office365Outlook.SendEmailV2(
        "IGREWAL1@calgary.ca",
        "New Time Off Request Submitted",
        "Employee: " & User().FullName & Char(10) &
        "Leave type: " & submittedRequest.'Leave Type'.Value & Char(10) &
        "Start: " & Text(requestStart, "[$-en-US]mmm dd, yyyy h:mm AM/PM") & Char(10) &
        "End: " & Text(requestEnd, "[$-en-US]mmm dd, yyyy h:mm AM/PM") & Char(10) &
        "Duration requested: " &
            If(
                durationDays = 1,
                durationHours & If(durationHours = 1, " hour", " hours"),
                durationDays & " calendar days (" & durationHours & " hours based on selected times)"
            ) & Char(10) &
        "Reason: " & Coalesce(submittedRequest.Reason, "No reason provided") & Char(10) & Char(10) &
        "Please review this request in the Time Off Request app."
    );
    Notify(
        "Time off request submitted. Your manager has been notified.",
        NotificationType.Success
    );
    ResetForm(frmTimeOffRequest)
)

// ----------------------------------------------------------------------
// Gallery card duration label Text
// ----------------------------------------------------------------------

With(
    {
        durationDays: DateDiff(
            Date(Year(ThisItem.'Start Date'), Month(ThisItem.'Start Date'), Day(ThisItem.'Start Date')),
            Date(Year(ThisItem.'End Date'), Month(ThisItem.'End Date'), Day(ThisItem.'End Date')),
            TimeUnit.Days
        ) + 1,
        durationHours: Round(DateDiff(ThisItem.'Start Date', ThisItem.'End Date', TimeUnit.Minutes) / 60, 1)
    },
    If(
        durationDays = 1,
        durationHours & If(durationHours = 1, " hour", " hours"),
        durationDays & " days / " & durationHours & " hours"
    )
)

// ----------------------------------------------------------------------
// My Requests gallery Items
// ----------------------------------------------------------------------

SortByColumns(
    Filter(TimeOffRequests, Email = User().Email),
    "SubmittedDate",
    SortOrder.Descending
)

// ----------------------------------------------------------------------
// Manager gallery Items
// ----------------------------------------------------------------------

Filter(
    TimeOffRequests,
    (IsBlank(Dropdown_EmployeeName.Selected.Value) || Title = Dropdown_EmployeeName.Selected.Value) &&
    (IsBlank(Dropdown_LeaveType.Selected.Value.Value) || 'Leave Type'.Value = Dropdown_LeaveType.Selected.Value.Value) &&
    (IsBlank(Dropdown_Status.Selected.Value.Value) || Status.Value = Dropdown_Status.Selected.Value.Value)
)

// ----------------------------------------------------------------------
// Approve button OnSelect
// ----------------------------------------------------------------------

With(
    {
        durationDays: DateDiff(
            Date(Year(ThisItem.'Start Date'), Month(ThisItem.'Start Date'), Day(ThisItem.'Start Date')),
            Date(Year(ThisItem.'End Date'), Month(ThisItem.'End Date'), Day(ThisItem.'End Date')),
            TimeUnit.Days
        ) + 1,
        durationHours: Round(DateDiff(ThisItem.'Start Date', ThisItem.'End Date', TimeUnit.Minutes) / 60, 1)
    },
    Patch(
        TimeOffRequests,
        ThisItem,
        {
            Status: {Value: "Approved"},
            'Approved Date': Now()
        }
    );
    Office365Outlook.SendEmailV2(
        ThisItem.Email,
        "Your Time Off Request Has Been Approved",
        "Hello " & ThisItem.Title & "," & Char(10) & Char(10) &
        "Your " & ThisItem.'Leave Type'.Value & " request from " &
        Text(ThisItem.'Start Date', "[$-en-US]mmm dd, yyyy h:mm AM/PM") & " to " &
        Text(ThisItem.'End Date', "[$-en-US]mmm dd, yyyy h:mm AM/PM") &
        " has been approved." & Char(10) &
        "Duration: " &
            If(
                durationDays = 1,
                durationHours & If(durationHours = 1, " hour", " hours"),
                durationDays & " calendar days (" & durationHours & " hours based on selected times)"
            ) &
        Char(10) & Char(10) &
        "Thank you."
    );
    Notify("Request approved and email sent to " & ThisItem.Title, NotificationType.Success)
)

// ----------------------------------------------------------------------
// Deny button OnSelect
// ----------------------------------------------------------------------

With(
    {
        durationDays: DateDiff(
            Date(Year(ThisItem.'Start Date'), Month(ThisItem.'Start Date'), Day(ThisItem.'Start Date')),
            Date(Year(ThisItem.'End Date'), Month(ThisItem.'End Date'), Day(ThisItem.'End Date')),
            TimeUnit.Days
        ) + 1,
        durationHours: Round(DateDiff(ThisItem.'Start Date', ThisItem.'End Date', TimeUnit.Minutes) / 60, 1)
    },
    Patch(
        TimeOffRequests,
        ThisItem,
        {
            Status: {Value: "Denied"},
            'Denied Date': Now()
        }
    );
    Office365Outlook.SendEmailV2(
        ThisItem.Email,
        "Your Time Off Request Has Been Denied",
        "Hello " & ThisItem.Title & "," & Char(10) & Char(10) &
        "Your " & ThisItem.'Leave Type'.Value & " request from " &
        Text(ThisItem.'Start Date', "[$-en-US]mmm dd, yyyy h:mm AM/PM") & " to " &
        Text(ThisItem.'End Date', "[$-en-US]mmm dd, yyyy h:mm AM/PM") &
        " has been denied." & Char(10) &
        "Duration requested: " &
            If(
                durationDays = 1,
                durationHours & If(durationHours = 1, " hour", " hours"),
                durationDays & " calendar days (" & durationHours & " hours based on selected times)"
            ) &
        Char(10) & Char(10) &
        "Please contact your manager if you have any questions."
    );
    Notify("Request denied and email sent to " & ThisItem.Title, NotificationType.Success)
)

// ----------------------------------------------------------------------
// Manager nav visibility
// ----------------------------------------------------------------------

User().Email = "IGREWAL1@calgary.ca"
