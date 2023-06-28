# Readonly-Packager

Readonly-Packager is a wrapper script designed for systems mounted as read-only, providing a warning to users when attempting to use the package manager. This script helps prevent unintended modifications to the system in read-only mode.

## Usage

To set up Readonly-Packager, follow these steps:

1. Create a symbolic link for the package manager that points to the Readonly-Packager script. Ensure the symbolic link is placed in a directory that is ahead of the actual package manager in the system's PATH.

   For example, if you want to create a symbolic link for `apt`:

   ```bash
   sudo ln -s packager.sh /usr/local/bin/apt
   ```

2. Make the symbolic link executable:

   ```bash
   sudo chmod +x /usr/local/bin/apt
   ```

   Replace `/usr/local/bin/apt` with the appropriate path and filename for the package manager you are using.

Now, when a user attempts to use the package manager, the Readonly-Packager script will be invoked. It will check if the system is mounted as read-only, and if so, display a message indicating that the package manager should not be used on a read-only system.

If the system is not mounted as read-only, the package manager will be executed as usual, and all arguments passed to the Readonly-Packager script will be transparently forwarded to the actual package manager.

Please note that Readonly-Packager assumes the system is running with appropriate privileges (e.g., using `sudo`) to modify system files and create the symbolic link. Ensure you have the necessary permissions before proceeding with the setup.

Remember to adjust the symbolic link creation step and commands according to the package manager you wish to wrap with the Readonly-Packager script.

By using Readonly-Packager, you can help prevent accidental modifications to a read-only system and promote awareness that the package manager should not be used in such scenarios.
