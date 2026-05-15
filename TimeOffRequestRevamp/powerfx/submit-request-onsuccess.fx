// Use this as frmTimeOffRequest.OnSuccess in the new request screen.
// It keeps the existing behavior and adds the requested duration to the manager email.

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
