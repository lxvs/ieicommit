
                           Inspur Commit Script
                       https://github.com/islzh/jg

注意：此脚本需要 Git for Windows v2.32.0 及以上版本。

This set of scripts is safe and clean, but it is always a good habit to
inspect every script before running it.


用 法
-----

    $ inspurcommit [ <操作> ]

可选的操作有：amend, export, exportall, init, push, template。
详见“操作”章节。

如果没有提供“操作”，则此命令为用来提交代码，详见“代码的提交”章节。


初始化
------

【初始化】

代码仓库初次使用该脚本时，需在该仓库根目录中执行以下命令进行初始化：

    inspurcommit init [<defaults>]

此动作是针对代码库进行的，每个代码库只需要初始化使用一次。只要有一位成员
进行了初始化动作【并上传】至 Gerrit，其他成员下载到的代码即是已初始化完成
的，不需要再次进行初始化。

init 命令可以使用参数来模板对应字段设置默认值，如 --tag EXAMPLE_TAG 参数
可将模板中 Tag# 字段内容设置为 EXAMPLE_TAG。参数详细信息及“初始化”所做的
操作请见“操作”章节。

为保证能正确导出提交历史，此后所有提交动作只能通过此脚本进行。


代码的提交
----------

    1.  在 Git Bash 中使用 git add 命令添加将要提交的代码改动。
        - git add .
          添加当前目录下所有改动（注意后面有个'.'）。
        - git add <filename>
          按文件名添加改动，可以使用通配符。
        - git add -u
          添加当前目录下的“修改”和“删除”改动，不添加新增的文件。

    2.  使用英文填写 ChangeHistory.txt 并保存。模板文件中的空行和以 # 开头
        的行将被忽略。如果代码库里面没有该文件，使用一次命令 inspurcommit，
        会生成文件 ChangeHistory.txt，然后填写该文件并保存。

    3.  使用命令 inspurcommit。如果给此命令提供了参数，它们将会被传递给
        git commit。

    4.  若要把提交的改动上传至 Gerrit，使用 inspurcommit push 命令。
        如果当前分支不为 master，使用命令 inspurcommit push <branch>。

ChangeHistoryTemplate.txt 文件的改动是无法被提交的，如需修改模板，使用命令
inspurcommit template。


操 作
-----

amend

    使用命令 inspurcommit amend 来改正上一个提交。用以下几个情况来举例说
    明使用方法。

    1. 模板文件填写有误
       (1) 修正 ChangeHistory.txt 文件，并保存
       (2) 执行命令 inspurcommit amend

    2. 提交的代码内容有误
       (1) 修正有误的代码，并保存
       (2) 使用命令 git add <文件路径>
       (3) 如果需要更改 ChangeHistory.txt，更改并保存。
       (4) 使用命令 inspurcommit amend

    3. 错误地提交了本不应提交的文件
       (1) 使用命令 git checkout @^ <文件路径>
       (2) 使用命令 inspurcommit amend

    4. 错误地提交了新文件
       (1) 删除错误提交的新文件
       (2) 使用命令 git add <文件路径>
       (2) 使用命令 inspurcommit amend。

    如果要撤消一次错误的 amend，使用如下命令：

        git reset --soft HEAD@{1}

export

    导出一份 change-history 到 ChangeHistory-%h.txt，%h 表示当前 commit
    id，不包含 Scope 字段。如果需要指定文件名，使用如下命令：

        inpsurcommit export <文件名>.txt

exportall

    导出一份 change-history 到 ChangeHistory-All-%h.txt，%h 表示当前
    commit id。如果需要指定文件名，使用如下命令：

        inpsurcommit exportall <文件名>.txt

template

    默认情况下提交码时如果包含了模板文件，脚本会自动排除它但仍然提交其余
    改动。如果要修改模板并提交，需要加上 template 参数。

init

    当一个代码仓库开始使用此脚本提交之前，需要用一次 inspurcommit init 命
    令以标示一个临界点，未来使用 export 或 exportall 操作进行导出时， 将
    只会导出此临界点之后的提交历史。

    此操作支持以下参数：

        -t, --tag <tag#>
        -l, --label <label#>
        -i, --issue <Issue#>
        -s, --scope <Scope>
        -v, --severity <Severity>
        -c, --category <Category>
        -y, --symptom <Symptom>
        -r, --rootcause <RootCause>
        -o, --solution <Solution>
        -d, --dependency <SolutionDependency>
        -f, --files <RelatedFiles>

    例如，

        inspurcommit init -t "5.19_CedarIslandCrb_0ACMT_013" -d "None"

    上述命令会将模板的 tag# 设为 5.19_CedarIslandCrb_0ACMT_013，将
    SolutionDependency 设为 None。

    初始化会做以下操作：

        1. 将 ChangeHistory.txt 重命名为 OldChangeHistory.txt
        2. 将默认模板放入代码库根目录，如果提供了参数，则根据参数修改模板
        3. 将临界点 commit id 写入文件 farewell-commit-id
        4. 将 /ChangeHistory.txt 和 /ChangeHistory-*.txt 加入 .gitignore
        5. 提交上述改动，生成一条标题为 INSPURCOMMIT-INIT 的 commit
