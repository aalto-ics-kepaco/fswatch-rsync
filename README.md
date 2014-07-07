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
3. Set up ssh-key authentification: If you don't have an ssh key-pair, generate one using `ssh-keygen`. Then copy the key to the middle server (`james` or `rhea`) using `ssh-copy-id -i ~/.ssh/id_rsa.pub yourUser@middleserver`. Follow the same procedure for the authentification from middle to target server (create a keypair on the middle server and copy it to the target server). See Note 2 below if you're on a Mac and don't have `ssh-copy-id` installed.
4. Make the script executable: `chmod u+x ./triton-rsync.sh`

**Note 1:** If you work in a different setting than at Aalto you might want to change the middle and target server names. These can be specified in `fswatch-rsync.sh` with the variables MIDDLE and TARGET at the very top.

**Note 2:** On a Mac you can either install `ssh-copy-id` via MacPorts/Brew/etc, compile it from source or you can just append the content of your public key (default `~/.ssh/id_rsa.pub`) to the `~/.ssh/authorized_keys` file on the server. Make sure the access rights are set properly though (e.g. chmod 700 for `~/.ssh` and 600 for `~/.ssh/authorized_keys`, see <http://unix.stackexchange.com/questions/36540/why-am-i-still-getting-a-password-prompt-with-ssh-with-public-key-authentication>)


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