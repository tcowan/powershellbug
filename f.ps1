#!/usr/bin/env pwsh
# Ted Cowan
# tedcowan@weber.edu
# 385 204-6655

set-strictmode -version latest

if ($args.length -lt 2) {
	write-Output("Usage: ./f.ps1 path/to/output/file recordcount")
	exit 1
}

# Convert arg[1] to integer and set as recordCount
try{
    [int]$recordCount = $args[1]    # The number of records that should be added to the output file
}
catch {
    Write-Output("Error: Unable to convert arg[2] to integer")
    exit 1
}

if ($recordCount -lt 0 -or -not ($recordCount -is [Int32]))
{
    Write-Error "Error: RecordCount must be a number and cannot be less than 0"
    exit 1
}

# Create output file
try{
    # Set outputFile path
    [string]$outputFile = $args[0]
    New-Item -path $outputFile -force -erroraction stop | Out-Null
} 
catch {
    Write-Error -Message "Error: Unable to create new output file"
    exit 1
}

Write-Output ("Writing $($recordCount) records to the output file")

function WriteToFile ($outputString)
{
    try {
        add-content -path $outputFile -value $outputString 
    }
    catch {
        Write-Output "Write failed to file $($outputFile): $($_)"
        exit 1
    }
}

function SetOutputTed ($newCmd)
{

    Write-Output("this string should appear on the console and not in my output file")
    WriteTofile($newCmd)

}

for($i = 0; $i -lt $recordCount; $i++)
{
    write-output("This string should appear on the console and does.")
    [string]$tempString = SetOutputTed ("Record $($i)")
    WriteToFile($tempString)
    write-output("This string should also appear on the console and does.")
}

exit 0
