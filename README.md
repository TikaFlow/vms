# vms

English | [简体中文](README_CN.md)

Vertical Management Suite(vms) is a utility suite for big data, or more.

# Environment

Linux/Bash needed.

# Install

download and unzip the tar package:

```bash
tar -zxvf vms.tar.gz
```

then, run the install script and specify a empty folder as installation path:

```bash
vms/install install/path
```

# Usage

```bash
# run the main program
vms
# then, in the vms-cli, type help to show hlep info
help
```

List of Commands:

    #COMMAND
        run bash command.
    !!
        rerun the last command(Just like in bash).
    :COMMAND
        search history commands that contains COMMAND.
    cd
        change directory just like in bash.
    help [plugin]
        plugin: print plugin help info, vms help info by default.
    exit
        exit vms-cli.
    info
        print vms info
    his[tory] [-c | -w | index]  show history command
        -c:     clear history.
        -w:     cut history file so that it's number of rows never exceeds limit, automatic called when exit.
        index:  rerun the command of the index.
            NOTE THAT IF THE COMMAND IS ALSO CALLS HISTORY COMMAND, IT WILL BE CALLED RECURSIVELY!

# Uninstall

run the uninstall script:

```bash
vms/uninstall
```
