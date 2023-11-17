#  Version:        rev1.2
#  Author:         bygalacos
#  Github:         github.com/bygalacos
#  Creation Date:  21.12.2023
#  Purpose/Change: Initial script release

Clear-Host

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

# Prompt the user to enter the group uuid
Write-Output "`nPlease insert your UUID below...`n"
$f_uuid = Read-Host 'Group UUID'

# Prompt the user to enter the hostname prefix
Write-Output "`nPlease insert your Hostname Prefix below...`n"
$f_hostnameprefix = Read-Host 'Hostname Prefix'

# Prompt the user to enter the proxy name
Write-Output "`nPlease insert your Proxy Name below...`n"
$f_proxyname = Read-Host 'Proxy Name'

# Prompt the user to enter the template name
Write-Output "`nPlease insert your Template Name below...`n"
$f_templatename = Read-Host 'Template Name'

# Write the XML header to the output file
Add-Content -Path $f_output "<?xml version='1.0' encoding='UTF-8'?>"
Add-Content -Path $f_output "<zabbix_export>"
Add-Content -Path $f_output ([char]9 + "<version>6.4</version>")

# Write the group information to the output file
Add-Content -Path $f_output ([char]9 + "<host_groups>")
Add-Content -Path $f_output ([char]9 + ([char]9 + "<host_group>"))
Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<uuid>$f_uuid</uuid>")))
Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<name>$f_group</name>")))
Add-Content -Path $f_output ([char]9 + ([char]9 + "</host_group>"))
Add-Content -Path $f_output ([char]9 + "</host_groups>")

# Write the host information to the output file
Add-Content -Path $f_output ([char]9 + "<hosts>")

Get-Content $f_input | Foreach-Object {
    $parts = $_ -split [char]9
    $hostname = $parts[0]
    $IP = $parts[1]

    Add-Content -Path $f_output ([char]9 + ([char]9 + "<host>"))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<host>$hostname</host>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<name>$f_hostnameprefix$hostname</name>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<proxy>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<name>$f_proxyname</name>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "</proxy>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "<templates>")))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<template>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + ([char]9 + "<name>$f_templatename</name>")))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + ([char]9 + "</template>"))))
    Add-Content -Path $f_output ([char]9 + ([char]9 + ([char]9 + "</templates>")))
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