# Johnny's Git Kit

It adds several more convenient commands to Git Bash. The term `Johnny's Git` is come from `jg`, rather than the contrary. `jg` was chosen as the prefix of all these commands because there is no common command that initials with `jg` in BASH.

Besides, all these commands has the unique initial after `jg`. Therefore, for example, you can simply type `jgc` and press <kbd>Tab</kbd> to get command `jgcommitnumber`.

<br/>

## Amend Last Commit

#### Synopsis

```bash
jgamendlastcommit [<message>]
```

#### Description

Amend last commit, equivalent to `git commit --amend --no-edit` when no `<message>` provided, otherwise equivalent to `git commit --amend -m <message>`.

***Note:*** Quote `<message>` when it contains white spaces.

***Note:*** If you did an amend unexpectedly, use `git reset --soft HEAD@{1}` to revert.

<br/>

## Commit Number

#### Synopsis

```bash
jgcommitnumber [<length>]
```

#### Description

Copy the first `<length>` characters of commit number to clipboard.

`<length>` ranges from `1` to `40`, default `8`.

<br/>

## For Each Repo Do ...

#### Synopsis

```bash
jgforeachrepodo <command> [<command-argument> ...]
```

#### Description

Execute `<command>` for each repo in current folder. Won't execute for the repo without `.git` folder or whose name contains spaces.

#### Example:
````bash
jgforeachrepodo git pull
````

<br/>

## Grep a Commit

#### Synopsis

```bash
jggrepacommit [<option>] <pattern>
```

#### Description

Search for commits that meet the given regex pattern, and copy the first found commit number.

***Note:*** `\` itself needs another `\` to be escaped in Bash. E.g. if searching for `[`, pattern `\\[` should be used.

#### Options

Options are same with `grep`. Here are some common ones. Try `grep --help` for more information.

| option                  | description                                       |
| ----------------------- | ------------------------------------------------- |
| `-E, --extended-regexp` | `<pattern>` is an extended regular expression     |
| `-F, --fixed-strings`   | `<pattern>` is a set of newline-separated strings |
| `-P, --perl-regexp`     | `<pattern>` is a Perl regular expression          |
| `-i, --ignore-case`     | ignore case distinctions                          |

<br/>

## Make Some Diff

#### Synopsis

```bash
jgmakesomediff [-d <output-dir>] [-o <orig-dir>] [-m <mod-dir>] [<orig-revision>] [<mod-revision>]
```

#### Description

Export two directories to `<output-dir>` for compare. One is named `<mod-dir>`, containing modified files in revision `<mod-revision>` compared to revision `<orig-revision>`, the other named `<orig-dir>` containing those files in `<orig-revision>`.

#### Default Value of Parameters

| Parameter         | Default            |
| ----------------- | ------------------ |
| `<output-dir>`    | `$HOME`/Desktop/   |
| `<orig-dir>`      | orig               |
| `<mod-dir>`       | mod                |
| `<orig-revision>` | `@` (means `HEAD`) |
| `<mod-revision>`  | (working tree)     |

#### Examples

`jgmakesomediff `

* Export modified/added files in working tree compared to HEAD to folder `~/Desktop/mod`, those modified files and removed files in HEAD to folder `~/Desktop/orig`.

`jgmakesomediff -d $HOME/Desktop/last-commit-diff -o original -m modified @^ @`

* Export modified/added files in last commit compared to second last commit to folder `~/Desktop/last-commit-diff/modified`, those modified files and removed files in second last commit to folder `~/Desktop/last-commit-diff/original`.

<br/>

## Number for the History

#### Synopsis

```bash
jgnumberforthehistory
```

#### Description

Output a list of modified/added/deleted/renamed/copied files of **staged** changes, with leading numbers before each line.

For example, you

* modified `some-folder/some-file` and `some-folder/another-file`
* added a new file `new-file`
* removed file `some-useless-file`

After execution of this `jgnumberforthehistory`, you will get

```
Related Files:
Modified:
1. some-folder\another-file
2. some-folder\some-file
Added:
1. new-file
Deleted:
1. some-useless-file
```

<br/>

## Push

#### Synopsis

```bash
jgpush [-r <remote>] [<branch>]
```

#### Description

Push local commits to Gerrit for review, equivalent to

```bash
git push <remote> HEAD:refs/for/<branch>
```

#### Default Value of Parameters

| Parameter  | Default |
| ---------- | ------- |
| `<remote>` | origin  |
| `<branch>` | master  |

<br/>

## Version

#### Synopsis

```bash
jgversion
```

#### Description

Show current version of Johnny's Git Kit.

<br/>
