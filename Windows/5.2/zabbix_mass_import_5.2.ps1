#  Version:        1.0
#  Author:         bygalacos
#  Github:         github.com/bygalacos
#  Creation Date:  21.12.2023
#  Purpose/Change: Initial script release

$current_version="1.0"

Clear-Host

Write-Host "Made with ♥ by bygalacos"

# Check if the web server is reachable
if (Test-Connection "raw.githubusercontent.com" -Count 1 -Quiet) {
  Write-Host "`nUpdate server is reachable.`n"

  # Check for updates to the script
  Write-Host "`nChecking for script updates...`n"

  # Download the latest version number from the web
  $latest_version = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bygalacos/Zabbix_Mass_Import/main/Windows/5.2/version.txt").Content

  # Compare the current and latest version numbers
  if ($current_version -ne $latest_version) {
    Write-Host "`nA newer version of the script is available: $latest_version`n"

    # Download and print the changelog from the web
    $changelog = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bygalacos/Zabbix_Mass_Import/main/Windows/5.2/changelog.txt").Content
    Write-Host "`nChangelog:`n$changelog`n"

    # Prompt the user to confirm updating the script
    $update_confirm = Read-Host "Update script to the latest version (y/n)?"
    if ($update_confirm -eq "y") {
      # Download the latest version of the script
      Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bygalacos/Zabbix_Mass_Import/main/Windows/5.2/zabbix_mass_import_5.2.ps1" -OutFile $PSCommandPath

      # Give the script execute permissions
      #$script = Get-Item $PSCommandPath
      #$script.Attributes = "Archive,ReadOnly"

      # Restart the script to use the updated version
      Write-Host "`nRestarting script..."
      Start-Process powershell.exe -ArgumentList $PSCommandPath -NoNewWindow -Wait
    }
    else {
      Write-Host "`nContinuing with current version of the script.`n"
    }
  }
  else {
    Write-Host "`nScript is up to date.`n"
  }
}
else {
  Write-Host "`nWeb server is not reachable. Skipping update check.`n"
}

# Prompt the user to enter the input filename
Write-Output "`nPlease insert your input file below...`n"
$f_input = Read-Host 'File input'

# Exit the script if the file does not exist
if (-not (Test-Path $f_input)) {
  Write-Output "`nInput file does not exist. Aborting operation.`n"
  Start-Sleep -Seconds 3
  exit 1
}

# Prompt the user to enter the output filename
Write-Output "`nPlease insert your output file below...`n"
$f_output = Read-Host 'File output'

# Check if output file exits
if (Test-Path $f_output) {
  # Prompt the user to confirm overwriting the output file
  $f_confirm = Read-Host "Output file already exist. Overwrite and continue (y/n)?"
  if ($f_confirm -eq "y") {
    # Delete the file if the user confirms
    Remove-Item $f_output -Force
  } else {
    # Exit the script if the user does not confirm
    Write-Output "`nAborting operation. Existing output file will not be modified.`n"
    Start-Sleep -Seconds 3
    exit 1
  }
}

# Prompt the user to enter the group name
Write-Output "`nPlease insert your Group Name below...`n"
$f_group = Read-Host 'Group Name'

# Write the XML header to the output file
Add-Content -Path $f_output "<?xml version='1.0' encoding='UTF-8'?>"
Add-Content -Path $f_output "<zabbix_export>"
Add-Content -Path $f_output ([char]9 + "<version>5.2</version>")
Add-Content -Path $f_output ([char]9 + "<date>" + (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ') + "</date>")

# Write the group information to the output file
Add-Content -Path $f_output ([char]9 + "<groups>")
Add-Content -Path $f_output ([char]9 + ([char]9 + "<group>"))
Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<name>$f_group</name>")))
Add-Content -Path $f_output ([char]9 + ([char]9 + "</group>"))
Add-Content -Path $f_output ([char]9 + "</groups>")

# Write the host information to the output file
Add-Content -Path $f_output ([char]9 + "<hosts>")

Get-Content $f_input | Foreach-Object {
    $parts = $_ -split [char]9
    $hostname = $parts[0]
    $IP = $parts[1]

    Add-Content -Path $f_output ([char]9 + ([char]9 + "<host>"))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<host>$hostname</host>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<name>$hostname</name>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<groups>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<group>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<name>$f_group</name>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "</group>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "</groups>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<interfaces>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<interface>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<ip>$IP</ip>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<interface_ref>if1</interface_ref>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "</interface>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<interface>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<type>SNMP</type>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<ip>$IP</ip>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<port>161</port>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<details>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<community>{`$SNMP_COMMUNITY`}</community>"))))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "</details>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<interface_ref>if2</interface_ref>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "</interface>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "</interfaces>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<inventory_mode>DISABLED</inventory_mode>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + "</host>"))
}

# Close the host and zabbix_export tags in the output file
Add-Content -Path $f_output ([char]9 + "</hosts>")
Add-Content -Path $f_output "</zabbix_export>"

exit 0