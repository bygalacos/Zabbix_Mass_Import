#  Version:        1.0
#  Author:         bygalacos
#  Github:         github.com/bygalacos
#  Creation Date:  21.12.2023
#  Purpose/Change: Initial script release

current_version="1.0"

clear

echo "Made with ♥ by bygalacos"

# Check if the web server is reachable
if ping -q -c 1 -W 1 raw.githubusercontent.com > /dev/null; then
  printf "\nUpdate server is reachable.\n"

  # Check for updates to the script
  printf "\nChecking for script updates...\n"

  # Download the latest version number from the web
  latest_version=$(wget -qO- https://raw.githubusercontent.com/bygalacos/Zabbix_Mass_Import/main/Linux/version.txt)

  # Compare the current and latest version numbers
  if [ "$current_version" != "$latest_version" ]; then
    printf "\nA newer version of the script is available: $latest_version\n"

	# Download and print the changelog
	changelog=$(wget -qO- https://raw.githubusercontent.com/bygalacos/Zabbix_Mass_Import/main/Linux/changelog.txt)
	printf "\nChangelog:\n$changelog\n\n"

    # Prompt the user to confirm updating the script
    read -p "Update script to the latest version (y/n)?" update_confirm
    if [ "$update_confirm" = "y" ]; then
      # Download the latest version of the script
      wget -qO $0 https://raw.githubusercontent.com/bygalacos/Zabbix_Mass_Import/main/Linux/zabbix_mass_import.sh

      # Give the script execute permissions
      chmod +x $0

      # Restart the script to use the updated version
      printf "\nRestarting script...\n"
      exec "$0" "$@"
    else
      printf "\nContinuing with current version of the script.\n"
    fi
  else
    printf "\nScript is up to date.\n"
  fi
else
  printf "\nServer is not reachable. Skipping update check.\n"
fi

# Prompt the user to enter the input filename
printf "\nPlease insert your input file below...\n"
read -p 'File input: '  f_input

# Exit the script if the file does not exist
if [ ! -f "$f_input" ]; then
  printf "\nInput file does not exist. Aborting operation.\n"
  exit 1
fi

# Check if the file uses (CR LF) and convert to (LF)
if grep -q $'\r' $f_input; then
  printf "\nConverting input file from (CR LF) to (LF)\n"
  sed -i 's/\r//' $f_input
fi

# Prompt the user to enter the output filename
printf "\nPlease insert your output file below...\n";
read -p 'File Output: ' f_output

# Check if output file exits
if [ -f "$f_output" ]; then
  # Prompt the user to confirm overwriting the output file
  read -p "Output file already exist. Overwrite and continue (y/n)?" f_confirm
  if [ "$f_confirm" = "y" ]; then
    # Delete the file if the user confirms
    rm -rf "$f_output"
  else
    # Exit the script if the user does not confirm
	printf "\nAborting operation. Existing output file will not be modified.\n"
    exit 1
  fi
fi

# Prompt the user to enter the group name
printf "\nPlease insert your Group Name below...\n";
read -p 'Group Name: ' f_group

# Write the XML header to the output file
printf "<?xml version='1.0' encoding='UTF-8'?>\n" >> $f_output
printf "<zabbix_export>\n" >> $f_output
printf "\t<version>5.2</version>\n" >> $f_output
printf "\t<date>"`date +"%Y-%m-%dT%TZ"`"</date>\n" >> $f_output

# Write the group information to the output file
printf "\t<groups>\n" >> $f_output
printf "\t\t<group>\n" >> $f_output
printf "\t\t\t<name>"$f_group"</name>\n" >> $f_output
printf "\t\t</group>\n" >> $f_output
printf "\t</groups>\n" >> $f_output

# Write the host information to the output file
printf "\t<hosts>\n" >> $f_output

awk  -v Group=${f_group%%*( )} 'BEGIN {FS = " "} {hostname=$1; IP=$2}
	{printf "\t\t<host>\n"
	 printf "\t\t\t<host>"hostname"</host>\n"
	 printf "\t\t\t<name>"hostname"</name>\n"
	 printf "\t\t\t<groups>\n"
	 printf "\t\t\t\t<group>\n"
	 printf "\t\t\t\t\t<name>"Group"</name>\n"
	 printf "\t\t\t\t</group>\n"
	 printf "\t\t\t</groups>\n"
	 printf "\t\t\t<interfaces>\n"
	 printf "\t\t\t\t<interface>\n"
	 printf "\t\t\t\t\t<ip>"IP"</ip>\n"
	 printf "\t\t\t\t\t<interface_ref>if1</interface_ref>\n"
	 printf "\t\t\t\t</interface>\n"
	 printf "\t\t\t\t<interface>\n"
	 printf "\t\t\t\t\t<type>SNMP</type>\n"
	 printf "\t\t\t\t\t<ip>"IP"</ip>\n"
	 printf "\t\t\t\t\t<port>161</port>\n"
	 printf "\t\t\t\t\t<details>\n"
	 printf "\t\t\t\t\t\t<community>{$SNMP_COMMUNITY}</community>\n"
	 printf "\t\t\t\t\t</details>\n"
	 printf "\t\t\t\t\t<interface_ref>if2</interface_ref>\n"
	 printf "\t\t\t\t</interface>\n"
	 printf "\t\t\t</interfaces>\n"
	 printf "\t\t\t<inventory_mode>DISABLED</inventory_mode>\n"
	 printf "\t\t</host>\n";    }' $f_input >>$f_output

# Close the host and zabbix_export tags in the output file
printf "\t</hosts>\n" >> $f_output
printf "</zabbix_export>\n" >> $f_output

exit 0