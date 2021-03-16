Function Get-ModuleResource {
    <#
        .SYNOPSIS
            Reads the module strings from the JSON file and returns a hashtable.
    #>
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [ValidateNotNull()]
        [ValidateScript( { If (Test-Path -Path $_ -PathType 'Leaf') { $True } Else { Throw "Cannot find file $_" } })]
        [System.String] $Path = (Join-Path -Path $MyInvocation.MyCommand.Module.ModuleBase -ChildPath "VcRedist.json")
    )
    
    try {
        Write-Verbose -Message "$($MyInvocation.MyCommand): read module resource strings from [$Path]"
        $content = Get-Content -Path $Path -Raw -ErrorAction "SilentlyContinue"
    }
    catch [System.Exception] {
        Write-Warning -Message "$($MyInvocation.MyCommand): failed to read from: $Path."
        Throw $_.Exception.Message
    }

    try {
        If (Test-PSCore) {
            $script:resourceStringsTable = $content | ConvertFrom-Json -AsHashtable -ErrorAction "SilentlyContinue"
        }
        Else {
            $script:resourceStringsTable = $content | ConvertFrom-Json -ErrorAction "SilentlyContinue" | ConvertTo-Hashtable
        }
    }
    catch [System.Exception] {
        Write-Warning -Message "$($MyInvocation.MyCommand): failed to convert strings to required object."
        Throw $_.Exception.Message
    }
    finally {
        If ($Null -ne $script:resourceStringsTable) {
            Write-Output -InputObject $script:resourceStringsTable
        }
    }
}
