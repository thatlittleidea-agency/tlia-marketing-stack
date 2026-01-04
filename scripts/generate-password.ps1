# =============================================================================
# TLIA Marketing Stack - Generate Strong Password
# =============================================================================
# Usage:
#   .\scripts\generate-password.ps1           # Generate 1 password
#   .\scripts\generate-password.ps1 -Count 5  # Generate 5 passwords
#   .\scripts\generate-password.ps1 -Length 30 # Generate 30-char password
# =============================================================================

param(
    [int]$Length = 20,
    [int]$Count = 1
)

function New-SecurePassword {
    param([int]$PasswordLength)

    # Character sets
    $Lowercase = 'abcdefghijklmnopqrstuvwxyz'
    $Uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $Numbers = '0123456789'
    $Symbols = '@#%&*_+-'

    # Combined character set
    $AllChars = $Lowercase + $Uppercase + $Numbers + $Symbols

    # Ensure at least one of each type
    $Password = @()
    $Password += $Lowercase[(Get-Random -Maximum $Lowercase.Length)]
    $Password += $Uppercase[(Get-Random -Maximum $Uppercase.Length)]
    $Password += $Numbers[(Get-Random -Maximum $Numbers.Length)]
    $Password += $Symbols[(Get-Random -Maximum $Symbols.Length)]

    # Fill remaining length with random characters
    for ($i = $Password.Count; $i -lt $PasswordLength; $i++) {
        $Password += $AllChars[(Get-Random -Maximum $AllChars.Length)]
    }

    # Shuffle the password array
    $ShuffledPassword = $Password | Sort-Object { Get-Random }

    return -join $ShuffledPassword
}

Write-Host ""
Write-Host "Generated Password(s):" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""

for ($i = 1; $i -le $Count; $i++) {
    $NewPassword = New-SecurePassword -PasswordLength $Length

    if ($Count -gt 1) {
        Write-Host "[$i] " -ForegroundColor Gray -NoNewline
    }

    Write-Host $NewPassword -ForegroundColor Green
}

Write-Host ""
Write-Host "Length: $Length characters" -ForegroundColor Gray
Write-Host "Characters: a-z, A-Z, 0-9, @#%&*_+-" -ForegroundColor Gray
Write-Host ""
