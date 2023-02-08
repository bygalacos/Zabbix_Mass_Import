# Zabbix Mass Import
## Import Zabbix Hosts with ease!

[![Build Status](https://camo.githubusercontent.com/4e084bac046962268fcf7a8aaf3d4ac422d3327564f9685c9d1b57aa56b142e9/68747470733a2f2f7472617669732d63692e6f72672f6477796c2f657374612e7376673f6272616e63683d6d6173746572)](https://travis-ci.org/joemccann/dillinger)

Releasing script that adds multiple zabbix hosts at the same time without any hassle.

## Features

- OTA Updates which can be disabled
- UNIX version can convert files from CR LF to LF
- More user-friendly prompts
- %100 easier!

## Usage

**Zabbix Mass Import** script requires a Windows or Linux operating system, depending on which platform you're using.

```sh
First grant executable permissions using chmod +x zabbix_mass_import.sh
```

To launch the script:

```sh
./zabbix_mass_import.sh
./zabbix_mass_import.ps1
```
Note: If you encounter any errors while launching the script, try right-clicking and selecting "Run with Powershell".

The input file must be formatted as "$hostname [tab] $ip". Please make sure to press the "tab" key to separate $hostname and $ip. In the case of hostnames with unsupported characters, an error message will appear during the import process. This feature for correcting unsupported characters will be added in the future. 

The output file will be generated upon script execution and can be imported into Zabbix via the web interface.

![zabbix_mass_import](https://user-images.githubusercontent.com/57764369/208874180-cefc2527-b031-4365-b2c0-da1d14ced5de.gif)

## License

This software is licensed under GPL-3.0

**Made with ♥ by bygalacos**
