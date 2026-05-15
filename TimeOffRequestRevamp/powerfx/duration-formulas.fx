// Duration label for a request form summary panel.
// Use this in a Text/Label control after replacing the control names if needed.

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

// Duration label for gallery cards where ThisItem is a TimeOffRequests record.

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

// Submit button DisplayMode.

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
