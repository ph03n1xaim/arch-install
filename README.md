# Arch Installer can now live without Humans

Unmanned Arch Installer Drones from Future!

## Warning
- Remember to change the variables at the top of the script before you wipe your system clean. I am in no way responsible for wiping your production servers with all your Kubernetes! (This meme was made by "I run Arch on servers, btw" gang)

- First rule of Arch Club: Keep backups! Duh!
- Run in a VM first, maybe?

## Installation

- Fetch script from git into live installer usb:
```bash
git clone https://github.com/ph03n1x-aim/arch-install.git
```
- Make the script executable:
```
chmod +x <script-name-here>.sh
```
Example:
```
chmod +x install-gnome.sh
```

- Run the script from bash to install Arch with gnome:
```
./install-gnome.sh
````
- For minimal install without any DE but with xorg:
```
./install-xorg.sh
```

- Rerun script to continue off where you left

## Contribute
- Send pull requests after testing my script
- Post your issues on github. I'll look into them!

## Things to do while the installation script takes over humanity
- Grab a cup of coffee!
- Rub your pet's belly!
- Get on your socials and spam "I use arch, btw" till they ban you!
- Get some sunlight and touch grass (Wouldn't advice the same for the vampires out there!)
