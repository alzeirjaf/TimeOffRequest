# Design Reference

The reference UI is `prototype/index.html`.

## Design Intent

The app should feel:

- Blue and white
- Soft
- Professional
- Less blocky than the original Power App
- Friendly for employees who only need to submit a request quickly
- Efficient for managers reviewing multiple requests

## Typography

Primary mockup font:

```text
Poppins
```

Power Apps value:

```powerfx
varFontMain
```

If Poppins does not render in Power Apps, use:

```powerfx
"Arial"
```

Recommended text sizing:

- Header/app name: `21`
- Screen titles: `24`
- Field labels: `14`
- Body/helper text: `14`
- Buttons: `15` or `16`
- Status chips: `12`

Recommended font weights:

- Titles: `FontWeight.Semibold`
- Buttons: `FontWeight.Semibold`
- Body text: `FontWeight.Normal`

## Colors

Use the variables from `powerfx/theme-and-layout.fx`.

Core palette:

- Page background: `RGBA(238, 247, 255, 1)`
- Panel: `RGBA(255, 255, 255, 0.76)`
- Glass fill: `RGBA(255, 255, 255, 0.52)`
- Strong glass fill: `RGBA(255, 255, 255, 0.82)`
- Primary blue: `RGBA(47, 125, 225, 1)`
- Dark blue text/accent: `RGBA(24, 93, 183, 1)`
- Main text: `RGBA(31, 41, 55, 1)`
- Muted text: `RGBA(96, 112, 137, 1)`
- Border: `RGBA(176, 203, 231, 0.72)`

## Shape

Use rounder corners than the original app:

- Main panels: `18`
- Cards: `16`
- Inputs: `13`
- Buttons/chips: `999`

## Power Apps Glass Approximation

The HTML mockup uses CSS blur. Power Apps cannot exactly reproduce CSS `backdrop-filter`, so approximate it with:

- White fill with opacity between `0.52` and `0.82`
- Light blue borders
- Soft shadows where available
- Plenty of padding
- Rounded corners

## Button Style

Primary button:

- Fill: `varColorGlassStrong`
- Color: `varColorPrimaryDark`
- BorderColor: `varColorBorder`
- BorderRadius: `varRadiusPill`
- Font: `varFontMain`
- Size: `15`
- FontWeight: `FontWeight.Semibold`

Secondary button:

- Fill: `varColorGlass`
- Color: `varColorText`
- BorderColor: `varColorBorder`
- BorderRadius: `varRadiusPill`

## Status Chips

Pending:

- Fill: `RGBA(254, 243, 199, 0.82)`
- Color: `RGBA(146, 64, 14, 1)`

Approved:

- Fill: `RGBA(220, 252, 231, 0.88)`
- Color: `RGBA(15, 94, 44, 1)`

Denied:

- Fill: `RGBA(254, 226, 226, 0.90)`
- Color: `RGBA(153, 27, 27, 1)`
