
                           Inspur Commit Script
                       https://github.com/islzh/jg

注意：这个脚本不可用于 Git for Windows 1.9.x 及以下版本。此脚本仅在 Git
for Windows v2.32.0 版本经过测试。

Inspur Commit
=============

用 法
-----

    $ inspurcommit [ <选项> ]

详细说明
--------

使用【模板文件的内容】作为附言，提交已添加（staged）的改动。模板文件名由脚
本文件的第二行代码中 template_file_name 定义。

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

    导出一份 change-history，不包括 commit hash, Author, Date, commit
    title 及 Scope 字段。

exportall

    导出一份 change-history，包括 scope 字段，但不包括 commit hash,
    Author, Date, commit title。
