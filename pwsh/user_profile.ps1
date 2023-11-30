# Prompt
# Install-Module -Name Terminal-Icons -Repository PSGallery -Force
# Install-Module -Name z -Force
# Install-Module -Name PSReadLine --AllowPrerelease -Scope CurrentUser -Force -Skip
# Install-Module -Name PSFzf -Scope CurrentUser -Force
Import-Module posh-git
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
# echo $(pwd)

# Load prompt config
function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }
$PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) "wft.omp.json"
oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG  | Invoke-Expression
# Alias
Set-Alias ll  ls
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Icons
Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -PredictionViewStyle  ListView

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | 
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

