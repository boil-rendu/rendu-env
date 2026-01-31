# Git 配置使用指南

本指南介绍如何高效使用 Git 进行版本控制，包括常用命令、配置技巧和最佳实践。

## 目录

- [快速开始](#快速开始)
- [基础配置](#基础配置)
- [常用命令](#常用命令)
- [分支管理](#分支管理)
- [合并与冲突解决](#合并与冲突解决)
- [忽略文件配置](#忽略文件配置)
- [常见问题](#常见问题)

## 快速开始

### 安装 Git

**macOS:**
```bash
brew install git
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install git
```

**Windows:**
下载并安装 [Git for Windows](https://git-scm.com/download/win)

### 初始化仓库

```bash
# 在现有目录初始化 Git 仓库
cd /path/to/project
git init

# 克隆远程仓库
git clone https://github.com/username/repo.git
```

## 基础配置

### 用户信息配置

```bash
# 配置全局用户名和邮箱
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 配置特定项目的用户名和邮箱（进入项目目录）
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 查看当前配置
git config --list
git config user.name
git config user.email
```

### 编辑器配置

```bash
# 设置默认编辑器（Vim）
git config --global core.editor "vim"

# 设置默认编辑器（VS Code）
git config --global core.editor "code --wait"

# 设置默认编辑器（Sublime Text）
git config --global core.editor "subl -n -w"
```

### 别名配置

创建常用命令的别名，提高效率：

```bash
# 常用别名
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# 使用示例
git st          # 等同于 git status
git co master   # 等同于 git checkout master
git lg          # 美化的日志查看
```

### 差异工具配置

```bash
# 配置 VS Code 作为 diff 工具
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'

# 配置 vimdiff
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3
```

## 常用命令

### 查看状态和日志

```bash
# 查看工作区状态
git status

# 查看提交历史
git log

# 查看美化日志（一屏一行）
git log --oneline

# 查看带图形的提交历史
git log --graph --oneline --all

# 查看文件的修改历史
git log --follow filename
git log -p filename  # 查看详细的修改内容
```

### 添加和提交

```bash
# 添加文件到暂存区
git add filename
git add .                    # 添加当前目录所有修改
git add -A                   # 添加所有修改（包括删除）

# 从暂存区移除文件
git reset HEAD filename

# 提交更改
git commit -m "提交信息"

# 跳过暂存区直接提交（只适用于已跟踪文件）
git commit -am "提交信息"

# 修改最后一次提交
git commit --amend           # 修改提交信息
git commit --amend -m "新的提交信息"
```

### 查看差异

```bash
# 查看工作区与暂存区的差异
git diff

# 查看暂存区与最后提交的差异
git diff --cached

# 查看工作区与最后提交的差异
git diff HEAD

# 查看两个提交之间的差异
git diff commit1 commit2

# 查看指定文件的差异
git diff filename
```

### 撤销操作

```bash
# 撤销工作区的修改（恢复到暂存区或最后提交的状态）
git checkout -- filename
git restore filename          # Git 2.23+ 新命令

# 撤销暂存区的修改
git reset HEAD filename
git restore --staged filename # Git 2.23+ 新命令

# 撤销提交（保留修改）
git reset --soft HEAD~1

# 撤销提交（保留修改到工作区）
git reset HEAD~1

# 撤销提交并丢弃修改
git reset --hard HEAD~1

# 回到指定提交（危险操作）
git reset --hard commit_id
```

### 删除和移动

```bash
# 删除文件（从工作区和暂存区）
git rm filename

# 删除文件（只从暂存区，保留工作区文件）
git rm --cached filename

# 移动或重命名文件
git mv oldname newname
```

## 分支管理

### 分支创建和切换

```bash
# 查看所有分支
git branch

# 查看远程分支
git branch -r

# 查看所有分支（本地和远程）
git branch -a

# 创建新分支
git branch branchname

# 切换到分支
git checkout branchname
git switch branchname          # Git 2.23+ 新命令

# 创建并切换到新分支
git checkout -b branchname
git switch -c branchname      # Git 2.23+ 新命令
```

### 分支合并

```bash
# 将指定分支合并到当前分支
git merge branchname

# 合并时不自动提交（用于解决冲突后手动提交）
git merge --no-commit branchname

# 合并后压缩提交历史
git merge --squash branchname
```

### 分支删除

```bash
# 删除本地分支
git branch -d branchname      # 安全删除（已合并的分支）
git branch -D branchname      # 强制删除（未合并的分支）

# 删除远程分支
git push origin --delete branchname
git push origin :branchname   # 另一种写法
```

### 分支重命名

```bash
# 重命名当前分支
git branch -m newname

# 重命名指定分支
git branch -m oldname newname
```

## 合并与冲突解决

### 合并策略

```bash
# 快进合并（默认）
git merge branchname

# 禁用快进合并（创建合并提交）
git merge --no-ff branchname

# 变基合并
git rebase branchname          # 将当前分支的提交变基到 branchname
```

### 冲突解决

当合并或变基时出现冲突：

```bash
# 查看冲突文件
git status

# 手动编辑冲突文件，解决标记为 <<<<<<< 的冲突
# 冲突标记示例：
# <<<<<<< HEAD
# 当前分支的内容
# =======
# 合并分支的内容
# >>>>>>> branchname

# 解决冲突后，标记为已解决
git add filename

# 完成合并
git commit -m "解决冲突"

# 如果是变基操作
git rebase --continue

# 放弃合并/变基
git merge --abort
git rebase --abort
```

## 忽略文件配置

### 使用本项目提供的模板

项目提供了多个 `.gitignore` 模板：

```bash
# 查看可用的模板
ls git/gitignore/

# 复制 C++ 项目模板
cp git/gitignore/c++.gitignore .gitignore

# 复制 IDE 综合模板（推荐）
cp git/gitignore/c++Ide.gitignore .gitignore

# 组合使用
cat git/gitignore/c++.gitignore > .gitignore
cat git/gitignore/cmake.gitignore >> .gitignore
```

### 忽略已跟踪的文件

```bash
# 从版本库中删除但保留本地文件
git rm --cached filename
git rm -r --cached directory/

# 提交更改
git commit -m "从版本库中移除文件"
```

### 排除规则（本地忽略）

在项目根目录创建 `.git/info/exclude` 文件，这些规则不会被提交：

```bash
# 编辑本地排除文件
vim .git/info/exclude

# 添加要忽略的文件（语法与 .gitignore 相同）
*.log
temp/
```

### 忽略文件语法

```gitignore
# 注释以 # 开头

# 忽略文件
filename
*.log
*.tmp

# 忽略目录
node_modules/
build/

# 忽略目录下的特定文件
dist/*.js

# 使用模式匹配
temp[0-9].txt            # 匹配 temp0.txt, temp1.txt 等
test_?.c                 # ? 匹配单个字符
**/build/                # ** 匹配多级目录

# 否定规则（不忽略）
*.log
!important.log           # 不忽略 important.log

# 忽略特定文件但保留目录
temp/
!important.temp/
```

## 常见问题

### Q: 如何恢复被误删的文件？

```bash
# 查看文件历史
git log --follow -- filename

# 恢复到指定提交
git checkout commit_id -- filename
```

### Q: 如何撤销已推送的提交？

```bash
# 撤销最后一次提交（保留修改）
git revert HEAD
git push

# 强制回退到指定提交（谨慎使用！）
git reset --hard commit_id
git push --force
```

### Q: 如何清理不必要的文件？

```bash
# 清理未跟踪的文件
git clean -f

# 清理未跟踪的文件和目录
git clean -fd

# 查看将要清理的文件（不执行清理）
git clean -n
git clean -dn
```

### Q: 如何查看文件的修改历史？

```bash
# 查看文件修改历史
git log --follow -- filename

# 查看文件的详细修改
git log -p filename

# 查看文件在某次提交的内容
git show commit_id:filename
```

### Q: 如何保存当前工作进度？

```bash
# 保存当前工作进度
git stash
git stash save "描述信息"

# 查看所有保存的进度
git stash list

# 恢复最新保存的进度
git stash pop

# 恢复指定进度
git stash pop stash@{0}

# 查看保存的进度内容
git stash show -p stash@{0}

# 清除所有保存的进度
git stash clear
```

### Q: 如何查找引入问题的提交？

```bash
# 二分查找引入问题的提交
git bisect start
git bisect bad           # 标记当前提交有问题
git bisect good commit_id  # 标记某个提交是正常的

# Git 会自动切换到中间提交，测试后标记好坏
git bisect good
git bisect bad

# 完成后回到原始分支
git bisect reset
```

### Q: 如何配置 SSH 密钥？

```bash
# 生成 SSH 密钥
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"

# 复制公钥到剪贴板（macOS）
cat ~/.ssh/id_rsa.pub | pbcopy

# 将公钥添加到 GitHub/GitLab 设置中

# 测试连接
ssh -T git@github.com
```

### Q: 如何使用 .gitattributes？

在项目根目录创建 `.gitattributes` 文件：

```gitattributes
# 设置文本文件的行尾符
* text=auto

# 指定特定文件类型
*.txt text
*.py text
*.sh text eol=lf
*.bat text eol=crlf

# 指定二进制文件
*.png binary
*.jpg binary

# 设置差异工具
*.php diff=php
```

## 最佳实践

1. **提交信息规范**：
   - 使用清晰、简洁的描述
   - 第一行简述（不超过50字符）
   - 详细描述可以另起一行
   - 示例：`Fix: 修复内存泄漏问题`

2. **频繁提交**：
   - 完成一个小功能就提交一次
   - 不要积累大量修改再提交

3. **合理使用分支**：
   - 使用功能分支开发新特性
   - 主分支保持稳定
   - 定期合并到主分支

4. **使用 .gitignore**：
   - 忽略编译产物、临时文件
   - 不要提交敏感信息
   - 参考项目提供的模板

5. **定期推送**：
   - 完成阶段性工作后及时推送
   - 避免本地积攒大量未推送的提交

6. **审查提交历史**：
   - 提交前查看将要提交的内容
   - 确保没有意外包含的文件

## 参考资源

- [Git 官方文档](https://git-scm.com/doc)
- [GitHub Git 指南](https://guides.github.com/introduction/git-handbook/)
- [Pro Git 中文版](https://git-scm.com/book/zh/v2)
- [Git 忽略文件模板库](https://github.com/github/gitignore)
