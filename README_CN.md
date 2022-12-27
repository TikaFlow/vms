# vms

垂直管理系统(vms)是一个大数据实用工具。

# 环境

需要Linux/Bash环境.

# 安装

克隆或下载并解压tar包:

```bash
git clone https://github.com/TikaFlow/vms.git
# OR download tar package
tar -zxvf vms.tar.gz
```

运行安装脚本并指定***空文件夹***作为安装路径:

```bash
vms/install install/path
```

# 用法

```bash
# 运行主程序
vms
# 进入命令行后，输入 help 查看帮助信息
help
```

命令列表:

    COMMAND
        运行bash命令.
    !!
        重新运行上一条命令(与在bash中一样).
    : STRING
        搜索包含STRING的历史命令.
    help [plugin]
        查看帮助信息, 默认为vms的帮助信息.
        plugin
            查看plugin的帮助信息.
    exit
        退出vms命令行.
    info
        查看vms信息.
    his[tory] [-c | -w | index]
        查看历史命令.
        -c
            清空历史命令.
        -w
            裁剪历史命令文件使之不超过行数限制, 退出前自动调用.
        index
            重新运行指定索引的命令.
            注意：如果历史命令也调用历史命令，将会递归执行，直到调用普通命令!
    m[run]
        在多个主机上连续执行命令.
        -h hosts
            在指定主机上执行命令，不使用默认主机列表.

# 卸载

运行卸载脚本:

```bash
vms/uninstall
```
