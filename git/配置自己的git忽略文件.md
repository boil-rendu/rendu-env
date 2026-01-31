# Git忽略文件配置指南

本目录提供了一系列常用的 `.gitignore` 模板文件，用于忽略各种编程语言和开发工具生成的临时文件和配置文件。

## 快速开始

访问官方仓库获取完整模板：
https://github.com/github/gitignore.git

## 目录结构

```
git/
├── gitignore/
│   ├── c++.gitignore          # C++ 项目忽略规则
│   ├── c++Ide.gitignore       # C++ IDE (CLion/VSCode) 忽略规则
│   ├── cmake.gitignore        # CMake 构建系统忽略规则
│   └── unity.gitignore        # Unity3D 项目忽略规则
└── 配置自己的git忽略文件.md    # 本文档
```

## 使用方法

### 方法一：直接复制

将对应的 `.gitignore` 文件内容复制到项目根目录下的 `.gitignore` 文件中。

### 方法二：符号链接（推荐）

```bash
# 在项目根目录创建符号链接
ln -s /path/to/rendu-env/git/gitignore/c++.gitignore .gitignore
```

### 方法三：组合多个模板

```bash
# 创建组合的 .gitignore 文件
cat /path/to/rendu-env/git/gitignore/c++.gitignore > .gitignore
cat /path/to/rendu-env/git/gitignore/cmake.gitignore >> .gitignore
```

## 模板说明

### c++.gitignore

适用于标准的 C/C++ 项目，忽略：
- 预编译头文件 (*.gch, *.pch)
- 编译生成的目标文件 (*.o, *.obj)
- 动态库和静态库 (*.so, *.a, *.lib)
- 可执行文件 (*.exe, *.out)

**适用场景**：使用 Makefile 或直接命令行编译的 C/C++ 项目

### c++Ide.gitignore

综合模板，包含：
- **JetBrains IDE** (CLion, IntelliJ IDEA 等) 配置文件
- **VSCode** 配置文件（保留 settings.json、tasks.json 等重要配置）
- **C++** 编译文件
- **CMake** 构建文件

**适用场景**：使用现代 IDE 开发的 C/C++ 项目

### cmake.gitignore

专注于 CMake 构建系统，忽略：
- CMake 缓存文件 (CMakeCache.txt)
- CMake 生成的构建目录 (CMakeFiles, CMakeScripts)
- 构建产物 (bin/, build/)
- 编译命令数据库 (compile_commands.json)

**适用场景**：所有使用 CMake 作为构建系统的项目

### unity.gitignore

Unity3D 游戏开发项目专用，忽略：
- Unity 编辑器生成的资源库
- 临时文件和缓存
- 构建输出
- IDE 配置文件

**适用场景**：Unity3D 游戏开发项目

## 自定义规则

在模板文件末尾，我们预留了 `# User ================================` 部分，可以添加项目特定的忽略规则：

```gitignore
# User ================================
# 项目特定的临时文件
temp/
*.log

# 密钥文件（不要提交到版本库）
.env
secret.key
```

## 常见问题

### Q: 为什么忽略文件不生效？

A: 可能的原因：
1. 文件已经被 Git 跟踪，需要先执行：`git rm --cached filename`
2. 规则路径不正确，注意使用相对路径
3. 文件名大小写不匹配

### Q: 如何忽略已提交的文件？

A: 使用以下命令：
```bash
# 从版本库中删除，但保留本地文件
git rm --cached filename

# 更新并提交
git commit -m "Remove ignored files"
```

### Q: 如何查看被忽略的文件？

A: 使用以下命令：
```bash
# 查看所有被忽略的文件
git status --ignored

# 查看某个特定文件的忽略状态
git check-ignore -v filename
```

## 注意事项

1. **不要提交敏感信息**：确保 `.env`、密钥文件等被正确忽略
2. **IDE 配置文件**：建议忽略用户特定的 IDE 配置，但可以提交团队共享的配置
3. **构建产物**：所有编译生成的文件都应该被忽略
4. **依赖文件**：`node_modules`、`vendor` 等依赖目录应该被忽略
5. **定期审查**：随着项目发展，需要定期审查 `.gitignore` 文件是否满足需求

## 参考资源

- Git 官方文档：https://git-scm.com/docs/gitignore
- GitHub 官方模板库：https://github.com/github/gitignore
- gitignore.io：https://www.toptal.com/developers/gitignore（在线生成工具）
