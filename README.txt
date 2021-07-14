
                           Inspur Commit Script
                       https://github.com/islzh/jg

注意：这个脚本不可用于 Git for Windows 1.9.x 及以下版本。此脚本仅在 Git
for Windows v2.32.0 版本经过测试。


Inspur Commit
=============


用 法
-----

    $ inspurcommit [ <选项> ]

    可选的选项有：amend, export, exportall, template, init。详见选项章节。


详细说明
--------

不加选项使用时（即使用命令 inspurcommit），将以【模板文件的内容】作为附言，
提交已添加（staged）的改动。如果模板文件也被添加，会自动排除模板文件，提交
剩余文件。如需改动模板，使用命令 inspurcommit template。

如果对于一个代码仓库来说是第一次使用，需要做以下三件事情：

    1. 将 ChangeHistoryTemplate.txt 复制到仓库根目录下。
    2. 用 inspurcommit init 命令来将临界 commit id 写入 farewell-commit-id
       文件，用以标记导出提交历史的临界点。
    3. 将原 ChangeHistory.txt 重命名为 OldChangeHistory.txt。

为保证能正确导出提交历史，此后所有提交动作【只】能通过此脚本进行。以上三个
改动可以直接提交（需要填写模板并通过此脚本提交）或随下次代码改动提交。

使用此命令前请务必用【英文】规范填写并【保存】模板文件。模板文件中的空行和
以 # 开头的行会自动被忽略。


选 项
-----

amend

    使用命令 inspurcommit amend 来改正上一个提交。用以下几个情况来举例说
    明使用方法。

    (1) 模板文件填写有误
        修正模板文件并【保存】后，使用 inspurcommit amend 命令。

    (2) 提交的代码内容有误
        修正有误的代码，并保存后，使用 git add <文件路径> 命令来添加修正
        的改动。根据需要更新模板文件并保存后，使用 inspurcommit amend 命
        令。

    (3) 错误地提交了本不应提交的文件
        先使用 git checkout @^ <文件路径> 命令，再使用 git add <文件路径>
        命令。根据需要更新模板文件并保存后，使用 inspurcommit amend 命令。

export

    导出一份 change-history 到 ChangeHistory.txt，不包含 Scope 字段。如果
    需要指定文件名，使用命令 inpsurcommit export <文件名>。

exportall

    导出一份 change-history 到 ChangeHistory.txt。如果需要指定文件名，使用
    命令 inpsurcommit exportall <文件名>。

template

    默认情况下提交码时如果包含了模板文件，脚本会自动排除它但仍然提交其余
    改动。如果要修改模板并提交，需要加上 template 参数。

init

    当一个代码仓库开始使用此脚本提交之前，需要用一次 inspurcommit init 命
    令以标示一个临界点，未来使用 export 或 exportall 选项进行导出操作时，
    将只会导出此临界点之后的提交历史。
