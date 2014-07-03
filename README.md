fswatch-rsync
=============
Clemens Westrup

About
-----

This is a script written to automatically synchronize a local project folder to a folder on a cluster server, namely for the triton cluster at Aalto University. It watches the local folder for changes and automatically synchronizes the remote folder when a change is detected. The script should work in a similar setup then at Aalto. 

Prerequisites
-------------

The script uses fswatch (<https://github.com/alandipert/fswatch>) and rsync (typically available on all UNIX based systems). To build and install fswatch you will need a C++ compiler. Also it is assumed that your username for the middle server (james or rhea at Aalto) is the same as your cluster (triton) username. It is needed to set up ssh-key based authentification at least to the cluster because the data is piped through ssh and the password prompt of the cluster won't appear in your local terminal.

Setup
-----

1. Download and install fswatch: <https://github.com/alandipert/fswatch>.
2. Make fswatch available in your PATH variable. This can be achieved by appending PATH=/path/to/where/you/installed/fswatch:$PATH to ~/.bash_profile (OSX) or ~/.bash_rc (most Linux). ** OR ** you can add your path to fswatch to the script itself instead where it now just calls fswatch.
3. Set up ssh-key authentification: If you don't have an ssh key-pair, generate one using `ssh-keygen` and just confirm or enter a passphrase if you like. That creates two a private and a public key in `~./ssh/`. Now append the content of `~./ssh/id_rsa.pub` (your public key) to `~/.ssh/authorized_keys` on the middle server (rhea/james). Then do the same for the middle server: Generate a pair on the middle server and append the middle server's to the  `~/.ssh/authorized_keys` on the cluster (triton). This way you don't need to authenticate with a password anymore when you ssh on the servers.
4. Make the script executable: `chmod u+x ./triton-rsync.sh`

Usage
-----

Just run the script and enjoy: `./triton-rsync.sh /your/local/path /path/on/triton yourClusterUserName` 

The arguments are 1. your local project path, 2. the path on the target cluster server and 3. your username. As mentioned above the username must be the same for the middle and target cluster server.

**Warning:** 
This script enforces the local state of the folder to the remote location, meaning if additional files are created on the remote location they will be deleted, so don't store results or any other work in subfolders on the remote location.

Contact and Contribution
------------------------

Please let me know if there's any problems with this script or the setup. I'm happy about any feedback and of course also feel free to fork this and contribute to it here on GitHub. The package is free to use without any license (public domain).

Email: firstname.lastname@aalto.fi