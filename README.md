# vms

English | [简体中文](README_CN.md)

Vertical Management System(vms) is a utility suite for big data, or more.

# Environment

Linux/Bash required.

# Install

git clone OR download and unzip the tar package:

```bash
git clone https://github.com/TikaFlow/vms.git
# OR download tar package
tar -zxvf vms.tar.gz
```

then, run the install script and specify a ***EMPTY*** folder as installation path:

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

    COMMAND
        run bash command if it doesn't conflict with vms command.
    !!
        rerun the last command(Just like in bash).
    : STRING
        search history commands that contains STRING.
    help [plugin]
        print help info, vms help info by default.
        plugin
            print plugin help info.
    exit
        exit vms-cli.
    info
        print vms info.
    his[tory] [-c | -w | index]
        show history command.
        -c
            clear history.
        -w
            cut history file so that it's number of rows never exceeds limit, automatic called when exit.
        index
            rerun the command of the index.
            NOTE THAT IF THE COMMAND ITSELF ALSO CALLS HISTORY COMMAND, IT WILL BE CALLED RECURSIVELY!
    m[run]
        run command on several hosts one by one.
        -h hosts
            run command on hosts instead of default nodes.

# Uninstall

run the uninstall script:

```bash
vms/uninstall
```
