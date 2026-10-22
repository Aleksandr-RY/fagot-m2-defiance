# Fagot-M2 mode icon generator (512x512 PNG, dark & clean).
# Run: pwsh -NoProfile -File tools\make_icons.ps1
Add-Type -AssemblyName System.Drawing

$script:outDir   = Join-Path (Split-Path -Parent $PSScriptRoot) 'assets\icons'
$DARK            = [System.Drawing.Color]::FromArgb(255, 18, 20, 24)
$RING_GRAY       = [System.Drawing.Color]::FromArgb(255, 70, 74, 82)
$CYAN            = [System.Drawing.Color]::FromArgb(255, 46, 204, 255)
$YELLOW          = [System.Drawing.Color]::FromArgb(255, 255, 196, 0)
$GREEN           = [System.Drawing.Color]::FromArgb(255, 34, 197, 94)
$RED             = [System.Drawing.Color]::FromArgb(255, 232, 58, 58)
$WHITE           = [System.Drawing.Color]::FromArgb(255, 235, 238, 242)
$STEEL           = [System.Drawing.Color]::FromArgb(255, 88, 94, 104)
$GLITCH_CY       = [System.Drawing.Color]::FromArgb(70, 46, 204, 255)
$GLITCH_RED      = [System.Drawing.Color]::FromArgb(60, 232, 58, 58)

function New-Brush([System.Drawing.Color]$Color) {
    return [System.Drawing.SolidBrush]::new($Color)
}
function New-Pen2([System.Drawing.Color]$Color, [float]$Width) {
    return [System.Drawing.Pen]::new($Color, $Width)
}

function New-Icon([string]$Label, [System.Drawing.Color]$RingColor, [scriptblock]$Draw) {
    $bmp = [System.Drawing.Bitmap]::new(512, 512)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    $g.FillEllipse((New-Brush $DARK), 18, 18, 476, 476)
    $g.DrawEllipse((New-Pen2 $RING_GRAY 6), 40, 40, 432, 432)
    $g.DrawEllipse((New-Pen2 $RingColor 14), 62, 62, 388, 388)

    & $Draw $g

    $font = [System.Drawing.Font]::new('Segoe UI', 44, [System.Drawing.FontStyle]::Bold)
    $fmt = [System.Drawing.StringFormat]::new()
    $fmt.Alignment = 'Center'
    $labelRect = [System.Drawing.RectangleF]::new(0, 400, 512, 70)
    $g.DrawString($Label, $font, (New-Brush $WHITE), $labelRect, $fmt)

    $path = Join-Path $script:outDir ("icon_{0}.png" -f $Label.ToLower())
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    Write-Output ("OK  {0}" -f $path)
}

New-Icon 'EMP' $CYAN {
    param($g)
    $pts1 = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(288, 118),
        [System.Drawing.PointF]::new(198, 274),
        [System.Drawing.PointF]::new(252, 274),
        [System.Drawing.PointF]::new(222, 388),
        [System.Drawing.PointF]::new(330, 236),
        [System.Drawing.PointF]::new(276, 236),
        [System.Drawing.PointF]::new(306, 118)
    )
    $glow = New-Brush ([System.Drawing.Color]::FromArgb(70, 46, 204, 255))
    foreach ($i in 1..3) { $g.FillPolygon($glow, $pts1) }
    $g.FillPolygon((New-Brush $CYAN), $pts1)
    $arcPen = New-Pen2 $CYAN 8
    $g.DrawArc($arcPen, 128, 150, 130, 130, 110, 130)
    $g.DrawArc($arcPen, 268, 150, 130, 130, -60, 130)
}

New-Icon 'SCHIZO' $YELLOW {
    param($g)
    # two-faced head: left half yellow (reprogrammed flesh), right half steel
    $g.FillPie((New-Brush $YELLOW), 156, 100, 200, 220, 90, 180)    # left half
    $g.FillPie((New-Brush $STEEL), 156, 100, 200, 220, -90, 180)    # right half
    # glitch strips
    $g.FillRectangle((New-Brush $GLITCH_CY), 170, 220, 180, 8)
    $g.FillRectangle((New-Brush $GLITCH_RED), 190, 246, 150, 6)
    # eyes: human (dark) + red optic
    $g.FillEllipse((New-Brush $DARK), 196, 160, 44, 44)
    $g.FillEllipse((New-Brush $RED), 288, 160, 44, 44)
    $g.FillEllipse((New-Brush $WHITE), 302, 174, 16, 16)
    # mouth seam
    $seamPen = New-Pen2 $DARK 8
    $g.DrawLine($seamPen, 206, 272, 312, 268)
    # who-am-i question mark
    $qFont = [System.Drawing.Font]::new('Segoe UI', 60, [System.Drawing.FontStyle]::Bold)
    $qFmt = [System.Drawing.StringFormat]::new()
    $qFmt.Alignment = 'Center'
    $qRect = [System.Drawing.RectangleF]::new(0, 296, 512, 90)
    $g.DrawString('?', $qFont, (New-Brush $WHITE), $qRect, $qFmt)
}

New-Icon 'TAKEOVER' $GREEN {
    param($g)
    # busted-open padlock
    $shacklePen = New-Pen2 $GREEN 24
    $g.DrawArc($shacklePen, 190, 130, 132, 132, 180, 200)
    $g.FillRectangle((New-Brush $GREEN), 170, 240, 172, 130)
    $g.FillEllipse((New-Brush $DARK), 234, 272, 44, 44)
    $keyPen = New-Pen2 $DARK 12
    $g.DrawLine($keyPen, 256, 300, 256, 344)
    # control claws on the sides
    $clawPen = New-Pen2 $GREEN 16
    $g.DrawArc($clawPen, 120, 240, 80, 120, 90, 140)
    $g.DrawArc($clawPen, 312, 240, 80, 120, -50, 140)
}

Write-Output 'Done.'
