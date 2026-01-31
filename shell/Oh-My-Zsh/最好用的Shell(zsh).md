## 安装zsh
如果你用 Mac，就可以直接看下一节
如果你用 Redhat Linux，执行：sudo yum install zsh
如果你用 Ubuntu Linux，执行：sudo apt-get install zsh
如果你用 Windows……去洗洗睡吧。

安装完成后设置当前用户使用 zsh：chsh -s /bin/zsh，根据提示输入当前用户的密码就可以了。
## 安装oh my zsh
### 自动安装
```bash
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```
### 手动安装
```bash
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```
## 配置
zsh 的配置主要集中在用户当前目录的.zshrc里，用 vim 或你喜欢的其他编辑器打开.zshrc，在最下面会发现这么一行字：
# Customize to your needs… 或者 # Set personal aliases ... # Example aliases....
可以在此处定义自己的环境变量和别名，当然，oh my zsh 在安装时已经自动读取当前的环境变量并进行了设置，你可以继续追加其他环境变量。
接下来进行别名的设置，我自己的部分配置如下：
```bash
alias cls='clear' 
alias ll='ls -l' 
alias la='ls -a' 
alias vi='vim' 
alias javac="javac -J-Dfile.encoding=utf8" 
alias grep="grep --color=auto" 
alias -s html=mate   # 在命令行直接输入后缀为 html 的文件名，会在 TextMate 中打开
alias -s rb=mate     # 在命令行直接输入 ruby 文件，会在 TextMate 中打开 
alias -s py=vi       # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似 
alias -s js=vi 
alias -s c=vi 
alias -s java=vi 
alias -s txt=vi 
alias -s gz='tar -xzvf' 
alias -s tgz='tar -xzvf' 
alias -s zip='unzip' 
alias -s bz2='tar -xjvf'
```

zsh 的牛X之处在于不仅可以设置通用别名，还能针对文件类型设置对应的打开程序，比如：
```bash
alias -s html=mate  #在命令行输入 hello.html，zsh会为你自动打开 TextMat 并读取 hello.html； 
alias -s gz='tar -xzvf'  #自动解压后缀为 gz 的压缩包。
```
总之，只有想不到，木有做不到。

设置完环境变量和别名之后，基本上就可以用了，如果你是个主题控，还可以玩玩 zsh 的主题。在 .zshrc 里找到ZSH_THEME，就可以设置主题了，默认主题是：
```bash
ZSH_THEME="robbyrussell"
```
oh my zsh 提供了数十种主题，相关文件在~/.oh-my-zsh/themes目录下，你可以随意选择，也可以编辑主题满足自己的变态需求，我采用了默认主题robbyrussell，不过做了一点小小的改动：
```bash
PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p%{$fg[cyan]%}%d %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}>' 
#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
```
对照原来的版本，把 c 改为 d，c 表示当前目录，d 表示绝对路径，另外在末尾增加了一个「 > 」
大家可以尝试按需改造。
## 插件
oh my zsh 项目提供了完善的插件体系，相关的文件在~/.oh-my-zsh/plugins目录下，默认提供了100多种，大家可以根据自己的实际学习和工作环境采用，想了解每个插件的功能，只要打开相关目录下的 zsh 文件看一下就知道了。插件也是在.zshrc里配置，找到plugins关键字，你就可以加载自己的插件了，系统默认加载 git ，你可以在后面追加内容，如下：
```bash
plugins=(git textmate ruby autojump osx mvn gradle)
```
下面简单介绍几个：
1、git：当你处于一个 git 受控的目录下时，Shell 会明确显示 「git」和 branch，如上图所示，另外对 git 很多命令进行了简化，例如 gco=’git checkout’、gd=’git diff’、gst=’git status’、g=’git’等等，熟练使用可以大大减少 git 的命令长度，命令内容可以参考~/.oh-my-zsh/plugins/git/git.plugin.zsh
2、textmate：mr可以创建 ruby 的框架项目，tm finename 可以用 textmate 打开指定文件。
3、osx：tab 增强，quick-look filename 可以直接预览文件，man-preview grep 可以生成 grep手册 的pdf 版本等。
4、autojump：zsh 和 autojump 的组合形成了 zsh 下最强悍的插件，今天我们主要说说这货。
首先安装autojump，如果你用 Mac，可以使用 brew 安装：
brew install autojump
如果是 Linux，去下载 autojump 的最新版本，比如：
wget https://github.com/downloads/joelthelion/autojump/autojump_v21.1.2.tar.gz
解压缩后进入目录，执行
./install.sh
最后把以下代码加入.zshrc：
```bash
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh
```
## 使用 zsh
1、兼容 bash
比如，原来使用 bash 的兄弟切换过来毫无压力，该咋用咋用。
2、历史纪录功能
比如，输入 grep 然后用上下箭头可以翻阅你执行的所有 grep 命令。
3、智能拼写纠正
比如，输入gtep mactalk * -R，系统会提示：zsh: correct ‘gtep’ to ‘grep’ [nyae]?
4、各种补全
路径补全、命令补全，命令参数补全，插件内容补全等等。触发补全只需要按一下或两下 tab 键，补全项可以使用 ctrl+n/p/f/b上下左右切换。比如你想杀掉 java 的进程，只需要输入 kill java + tab键，如果只有一个 java 进程，zsh 会自动替换为进程的 pid，如果有多个则会出现选择项供你选择。ssh + 空格 + 两个tab键，zsh会列出所有访问过的主机和用户名进行补全
5、智能跳转
安装了autojump之后，zsh 会自动记录你访问过的目录，通过 j + 目录名 可以直接进行目录跳转，而且目录名支持模糊匹配和自动补全，例如你访问过hadoop-1.0.0目录，输入j hado 即可正确跳转。j –stat 可以看你的历史路径库。
6、目录浏览和跳转
输入 d，即可列出你在这个会话里访问的目录列表，输入列表前的序号，即可直接跳转。
7、在当前目录下输入 .. 或 … ，或直接输入当前目录名都可以跳转，你甚至不再需要输入 cd 命令了。
8、通配符搜索：ls -l **/*.sh，可以递归显示当前目录下的 shell 文件，文件少时可以代替 find，文件太多就歇菜了。
## 遇到的问题
### 问题1： zsh: no matches found: **********
#### 解决方法：
打开.zshrc文件
vi  ~/.zshrc 
加入一行
 setopt no_nomatch
然后保存，推出文件
执行 source ~/.zshrc 
### 问题2：
