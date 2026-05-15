// Approve button OnSelect for the manager request gallery.

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

// Deny button OnSelect for the manager request gallery.

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
