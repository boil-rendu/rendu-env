# rendu-env

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/FRBoiling/rendu-env?style=social)](https://github.com/FRBoiling/rendu-env)

## 项目简介

`rendu-env` 是一个完整的 Linux 开发环境配置模板项目，旨在帮助开发者快速搭建高效的开发环境。本项目基于 Docker 容器化技术，提供了多种编程语言和服务的开发环境配置，包括 C++、Golang、数据库等，并整合了常用的 Shell 和 Vim 配置。

### 主要特性

- 🐳 **容器化开发环境**：基于 Docker 和 Docker Compose 的一键部署方案
- 🔧 **多语言支持**：C++、Golang 等主流开发语言环境
- 🗄️ **数据库服务**：MariaDB、Redis 等常用数据库容器
- 🎨 **丰富的工具集**：精心配置的 Shell (zsh + oh-my-zsh) 和 Vim 环境
- 📚 **完善的文档**：详细的使用说明和最佳实践

## 目录结构

```
rendu-env/
├── README.md                    # 项目主文档
├── CHANGELOG.md                 # 变更日志
├── API文档.md                    # 服务接口文档
├── 代码注释说明.md               # 代码注释规范
├── 文档索引.md                   # 文档快速导航
│
├── dockers/                     # Docker 容器配置
│   ├── docker-compose.yml      # Docker Compose 主配置
│   ├── Docker笔记-常用命令.md   # Docker 常用命令文档
│   ├── Docker笔记-c++开发环境.md # C++ 开发环境配置文档
│   ├── run_env.sh              # 环境启动脚本
│   ├── centos/                 # CentOS 环境配置
│   ├── cpp_env/                # C++ 开发环境配置
│   ├── golang_env/             # Golang 开发环境配置
│   ├── mariadb/                # MariaDB 数据库配置
│   ├── redis/                  # Redis 缓存配置
│   └── ubuntu/                 # Ubuntu 环境配置
│
├── git/                        # Git 配置
│   └── 配置自己的git忽略文件.md  # Git 忽略文件配置指南
│
├── shell/                      # Shell 配置
│   ├── Oh-My-Zsh/              # Oh My Zsh 相关
│   │   ├── install.sh          # Oh My Zsh 安装脚本（含详细注释）
│   │   ├── zshrc               # Zsh 配置文件（含详细注释）
│   │   └── 最好用的Shell(zsh).md # Zsh 使用指南
│   └── brew/                   # Homebrew 包管理
│       ├── list-brew-packages-by-date.sh   # 按日期列出已安装包（含注释）
│       ├── uninstall-brew-by-date.sh     # 按日期卸载包（含注释）
│       └── Homebrew包管理工具.md        # Homebrew 工具使用文档
│
└── vim/                        # Vim 配置
    ├── 配置自己的vim.md         # Vim 配置指南（快速开始）
    ├── Vim配置使用指南.md        # Vim 完整使用文档（新增）
    ├── vimrc1                  # Vim 配置文件（版本1，含注释）
    └── vimrc2                  # Vim 配置文件（版本2）
```

## 快速开始

### 前置要求

- Docker >= 20.10
- Docker Compose >= 2.0
- Git
- Zsh（推荐用于 Shell 模块）

### 安装步骤

1. **克隆项目**

```bash
git clone https://github.com/FRBoiling/rendu-env.git
cd rendu-env
```

2. **启动 Docker 环境**

```bash
cd dockers
./run_env.sh
```

或使用 Docker Compose 命令：

```bash
docker-compose -p rd_env -f docker-compose.yml up -d --build
```

3. **配置 Shell 环境（可选）**

```bash
cd shell/Oh-My-Zsh
chmod +x install.sh
./install.sh
```

4. **配置 Vim（可选）**

```bash
cd ../vim
cp vimrc1 ~/.vimrc
```

### 验证安装

```bash
# 查看运行中的容器
docker ps

# 查看容器日志
docker-compose logs -f

# 测试 SSH 连接到 C++ 环境容器
ssh -p 23 root@localhost
# 密码：root
```

## 模块说明

### Docker 模块

Docker 模块提供完整的容器化开发环境，包括：

| 服务 | 容器名称 | 端口映射 | 说明 |
|------|----------|----------|------|
| C++ 开发环境 | rd_cpp_env | 23:22, 873:873 | Ubuntu 20.04 + GCC + GDB + CMake |
| Golang 开发环境 | rd_golang_env | - | Go 1.19+ 开发环境 |
| Redis | rd_redis | 6379:6379 | 内存数据库 |
| MariaDB | rd_mariadb | 3306:3306 | MySQL 兼容数据库 |
| Ubuntu | rd_ubuntu | 22:22, 873:873 | 通用 Ubuntu 环境 |

**网络配置**：
- 网络名称：`network_inner`
- 子网：`172.20.0.0/16`
- 网关：`172.20.0.1`

详细配置说明请参考：
- [Docker 常用命令](dockers/Docker笔记-常用命令.md)
- [C++ 开发环境配置](dockers/Docker笔记-c++开发环境.md)

### Shell 模块

Shell 模块提供基于 Zsh 和 Oh My Zsh 的高效终端环境，以及 Homebrew 包管理工具：

**Zsh + Oh My Zsh**：

**核心特性**：
- 智能补全和自动纠错
- 历史命令快速查找
- 丰富的插件支持（git、autojump、语法高亮等）
- 自定义别名和主题

**主要插件**：
- `git`：Git 命令简化和状态提示
- `autojump`：智能目录跳转
- `zsh-syntax-highlighting`：语法高亮
- `zsh-autosuggestions`：命令自动建议

**Homebrew 包管理**：

**核心功能**：
- 按日期查看已安装包
- 按日期批量卸载包
- 支持 Intel 和 Apple Silicon Mac

**使用示例**：
```bash
# 查看包安装时间
./shell/brew/list-brew-packages-by-date.sh

# 卸载指定日期的包
./shell/brew/uninstall-brew-by-date.sh 2025-01-30
```

详细使用说明请参考：
- [Zsh 配置指南](shell/Oh-My-Zsh/最好用的Shell(zsh).md)
- [Homebrew 包管理工具](shell/brew/Homebrew包管理工具.md)

### Vim 模块

Vim 模块提供两个版本的 Vim 配置和完整的使用文档：

**vimrc1 特性**：
- 语法高亮和自动缩进
- 代码补全和括号自动匹配
- 快捷键映射（F5 编译运行、F8 调试）
- CTags 标签浏览
- Tablist 和 MiniBufExpl 插件集成
- 自动插入文件头

**vimrc2 特性**：
- 配置简洁轻量
- UTF-8 编码支持
- 智能补全
- 适合服务器远程编辑

详细配置说明请参考：
- [Vim 配置指南](vim/配置自己的vim.md) - 快速开始
- [Vim 使用指南](vim/Vim配置使用指南.md) - 完整文档（新增）

### Git 模块

Git 模块提供 Git 忽略文件配置参考，基于 [GitHub Gitignore](https://github.com/github/gitignore) 仓库的常用模板。

## 使用示例

### C++ 开发

1. 连接到 C++ 容器：
```bash
ssh -p 23 root@localhost
```

2. 创建并编译项目：
```bash
cd /root/sync
vim hello.cpp
g++ hello.cpp -o hello
./hello
```

### 数据库操作

**Redis 连接**：
```bash
redis-cli -h 127.0.0.1 -p 6379 -a redis
```

**MariaDB 连接**：
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
# 密码：root
```

### Shell 高效使用

**智能跳转**：
```bash
j hadoop  # 跳转到包含 hadoop 的目录
j --stat   # 查看访问历史
```

**Git 快捷命令**：
```bash
gst       # git status
gco main  # git checkout main
gdiff     # git diff
```

## 常见问题

### Docker 相关

**Q: 容器无法启动？**
A: 检查端口占用：
```bash
lsof -i :6379  # 检查 Redis 端口
lsof -i :3306  # 检查 MariaDB 端口
```

**Q: 如何更新镜像？**
A:
```bash
docker-compose pull
docker-compose up -d --build
```

### Shell 相关

**Q: zsh: no matches found 错误？**
A: 在 `.zshrc` 中添加：
```bash
setopt no_nomatch
source ~/.zshrc
```

### Vim 相关

**Q: 如何启用语法高亮？**
A: 确保配置文件中有：
```vim
syntax on
filetype plugin on
```

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 参考资源

- [Docker 官方文档](https://docs.docker.com/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Vim 官方文档](https://www.vim.org/docs.php)

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 联系方式

- 作者：Boil
- 邮箱：free22858@live.com
- GitHub：https://github.com/FRBoiling/rendu-env

---

如果本项目对您有帮助，请给一个 ⭐️ Star！

