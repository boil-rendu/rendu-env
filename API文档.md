# rendu-env API 文档

> 本项目为开发环境配置模板，不提供传统的 Web API 接口。本文档说明各模块的配置接口和服务端口。

---

## 目录

- [Docker 服务接口](#docker-服务接口)
  - [Redis 服务](#redis-服务)
  - [MariaDB 服务](#mariadb-服务)
  - [C++ 开发环境](#c-开发环境)
  - [Golang 开发环境](#golang-开发环境)
  - [Ubuntu 环境](#ubuntu-环境)
- [Shell 配置接口](#shell-配置接口)
- [Vim 配置接口](#vim-配置接口)
- [Git 配置接口](#git-配置接口)

---

## Docker 服务接口

### Redis 服务

#### 服务配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 容器名称 | rd_redis | Docker 容器标识 |
| 镜像 | boiling/redis:latest | Redis 镜像版本 |
| 宿主机端口 | 6379 | Redis 服务端口 |
| 容器端口 | 6379 | Redis 内部端口 |
| 密码 | redis | 连接密码 |
| 时区 | Asia/Shanghai | 容器时区设置 |
| 数据卷 | `./data:/data` | 数据持久化路径 |

#### 网络配置

- **网络**：network_inner
- **别名**：REDIS_URL
- **IP 地址**：自动分配（172.20.0.x 段）

#### 连接方式

**命令行连接**：
```bash
redis-cli -h 127.0.0.1 -p 6379 -a redis
```

**编程语言连接示例**：

**Python**：
```python
import redis

r = redis.Redis(
    host='127.0.0.1',
    port=6379,
    password='redis',
    decode_responses=True
)
r.set('key', 'value')
print(r.get('key'))
```

**Go**：
```go
import (
    "github.com/go-redis/redis/v8"
    "context"
)

func main() {
    rdb := redis.NewClient(&redis.Options{
        Addr:     "127.0.0.1:6379",
        Password: "redis",
        DB:       0,
    })
    ctx := context.Background()
    rdb.Set(ctx, "key", "value", 0)
    val := rdb.Get(ctx, "key")
}
```

**Node.js**：
```javascript
const redis = require('redis');

const client = redis.createClient({
    host: '127.0.0.1',
    port: 6379,
    password: 'redis'
});

client.set('key', 'value', (err, reply) => {
    if (err) throw err;
    console.log(reply);
});

client.get('key', (err, reply) => {
    if (err) throw err;
    console.log(reply);
});
```

#### 配置文件

**位置**：`./dockers/redis/conf/redis.conf`

**主要配置**：
```conf
# 绑定地址
bind 0.0.0.0

# 端口
port 6379

# 认证密码
requirepass redis

# 持久化配置
appendonly yes
appendfsync everysec

# 日志级别
loglevel notice

# 最大内存
maxmemory 256mb
maxmemory-policy allkeys-lru
```

#### 管理命令

```bash
# 启动 Redis
docker-compose start redis

# 停止 Redis
docker-compose stop redis

# 重启 Redis
docker-compose restart redis

# 查看日志
docker-compose logs -f redis

# 进入容器
docker exec -it rd_redis redis-cli -a redis

# 备份数据
docker exec rd_redis redis-cli -a redis BGSAVE

# 查看信息
docker exec rd_redis redis-cli -a redis INFO
```

---

### MariaDB 服务

#### 服务配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 容器名称 | rd_mariadb | Docker 容器标识 |
| 镜像 | boiling/mariadb:latest | MariaDB 镜像版本 |
| 宿主机端口 | 3306 | MySQL 服务端口 |
| 容器端口 | 3306 | MySQL 内部端口 |
| Root 密码 | root | 管理员密码 |
| 允许主机 | % | 允许所有主机连接 |
| 时区 | Asia/Shanghai | 容器时区设置 |

#### 网络配置

- **网络**：network_inner
- **别名**：MYSQL_URL
- **IP 地址**：自动分配（172.20.0.x 段）

#### 连接方式

**命令行连接**：
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
# 输入密码：root
```

**编程语言连接示例**：

**Python**：
```python
import pymysql

conn = pymysql.connect(
    host='127.0.0.1',
    port=3306,
    user='root',
    password='root',
    database='mysql',
    charset='utf8mb4'
)

cursor = conn.cursor()
cursor.execute('SELECT VERSION()')
print(cursor.fetchone())
conn.close()
```

**Go**：
```go
import (
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    dsn := "root:root@tcp(127.0.0.1:3306)/mysql?charset=utf8mb4&parseTime=True"
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        panic(err)
    }
    defer db.Close()
}
```

**Node.js**：
```javascript
const mysql = require('mysql2/promise');

async function main() {
    const connection = await mysql.createConnection({
        host: '127.0.0.1',
        port: 3306,
        user: 'root',
        password: 'root',
        database: 'mysql'
    });

    const [rows] = await connection.execute('SELECT VERSION()');
    console.log(rows[0]);
}

main();
```

#### 配置文件

**位置**：`./dockers/mariadb/conf/my.cnf`

**主要配置**：
```ini
[mysqld]
# 字符集设置
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

# 连接设置
max_connections=200
max_connect_errors=1000

# 缓存设置
innodb_buffer_pool_size=256M
innodb_log_file_size=64M

# 日志设置
slow_query_log=1
slow_query_log_file=/var/log/mysql/slow.log
long_query_time=2

# 时区
default-time-zone='+08:00'
```

#### 数据卷

| 宿主机路径 | 容器路径 | 说明 |
|-----------|---------|------|
| `./dockers/mariadb/conf` | `/etc/mysql/conf.d` | 配置文件目录 |
| `./dockers/mariadb/logs` | `/var/log/mysql` | 日志文件目录 |
| `./dockers/mariadb/data` | `/var/lib/mysql` | 数据文件目录 |

#### 管理命令

```bash
# 启动 MariaDB
docker-compose start mariadb

# 停止 MariaDB
docker-compose stop mariadb

# 重启 MariaDB
docker-compose restart mariadb

# 查看日志
docker-compose logs -f mariadb

# 进入容器
docker exec -it rd_mariadb mysql -u root -p

# 备份数据
docker exec rd_mariadb mysqldump -u root -proot --all-databases > backup.sql

# 恢复数据
docker exec -i rd_mariadb mysql -u root -proot < backup.sql

# 查看运行状态
docker-compose ps mariadb
```

---

### C++ 开发环境

#### 服务配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 容器名称 | rd_cpp_env | Docker 容器标识 |
| 镜像 | boiling/cpp_env:latest | C++ 开发环境镜像 |
| 基础镜像 | ubuntu:20.04 | Ubuntu 版本 |
| SSH 端口 | 23:22 | SSH 服务端口 |
| Rsync 端口 | 873:873 | 文件同步端口 |
| Root 密码 | root | SSH 登录密码 |
| 时区 | Asia/Shanghai | 容器时区设置 |

#### 网络配置

- **网络**：network_inner
- **别名**：CPP_URL
- **IP 地址**：自动分配（172.20.0.x 段）

#### 连接方式

**SSH 连接**：
```bash
ssh -p 23 root@localhost
# 密码：root
```

**SSH 配置（~/.ssh/config）**：
```
Host cpp-env
    HostName localhost
    Port 23
    User root
    StrictHostKeyChecking no
```

**连接命令**：
```bash
ssh cpp-env
```

#### 开发工具

**编译器**：
- GCC (GNU Compiler Collection)
- G++ (C++ Compiler)

**构建工具**：
- CMake
- Ninja
- Make

**调试器**：
- GDB (GNU Debugger)

**编辑器**：
- Vim

**其他工具**：
- Git
- rsync（支持 CLion 远程开发）
- net-tools
- iputils-ping

#### 环境信息

```bash
# 查看 GCC 版本
g++ --version

# 查看 CMake 版本
cmake --version

# 查看 GDB 版本
gdb --version

# 查看系统信息
uname -a
cat /etc/os-release
```

#### 管理命令

```bash
# 启动容器
docker-compose start cpp_env

# 停止容器
docker-compose stop cpp_env

# 重启容器
docker-compose restart cpp_env

# 查看日志
docker-compose logs -f cpp_env

# 进入容器
docker exec -it rd_cpp_env /bin/bash

# 查看运行状态
docker-compose ps cpp_env

# 查看容器资源使用
docker stats rd_cpp_env
```

#### CLion 远程开发配置

**Toolchains 设置**：
1. 打开 CLion 设置 → Build, Execution, Deployment → Toolchains
2. 新增 Remote Host：
   - Host: localhost
   - Port: 23
   - User name: root
   - Password: root

**CMake 设置**：
1. 设置 → Build, Execution, Deployment → CMake
2. 选择 Remote Host 工具链
3. 配置构建选项

**同步设置**：
1. 设置 → Build, Execution, Deployment → Deployment
2. 配置 rsync 同步路径
3. 本地路径 → 容器路径

---

### Golang 开发环境

#### 服务配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 容器名称 | rd_golang_env | Docker 容器标识 |
| 镜像 | boiling/golang_env:latest | Go 开发环境镜像 |
| 时区 | Asia/Shanghai | 容器时区设置 |

#### 网络配置

- **网络**：network_inner
- **IP 地址**：自动分配（172.20.0.x 段）

#### 开发环境

**Go 版本**：Go 1.19+

**常用工具**：
- gofmt
- go vet
- go test
- go mod

**工作目录**：`/workspace`

#### 环境变量

```bash
# 查看环境变量
docker exec -it rd_golang_env env | grep GO

# GOPATH
# /go

# GOROOT
# /usr/local/go

# PATH
# 包含 /usr/local/go/bin
```

#### 管理命令

```bash
# 启动容器
docker-compose start golang_env

# 停止容器
docker-compose stop golang_env

# 重启容器
docker-compose restart golang_env

# 查看日志
docker-compose logs -f golang_env

# 进入容器
docker exec -it rd_golang_env /bin/bash

# 运行 Go 程序
docker exec rd_golang_env go run main.go
```

---

### Ubuntu 环境

#### 服务配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 容器名称 | rd_ubuntu | Docker 容器标识 |
| 镜像 | ubuntu:latest | Ubuntu 镜像版本 |
| SSH 端口 | 22:22 | SSH 服务端口 |
| Rsync 端口 | 873:873 | 文件同步端口 |

#### 网络配置

- **网络**：network_inner
- **别名**：UBUNTU_URL
- **IP 地址**：自动分配（172.20.0.x 段）

#### 管理命令

```bash
# 启动容器
docker-compose start ubuntu

# 停止容器
docker-compose stop ubuntu

# 重启容器
docker-compose restart ubuntu

# 查看日志
docker-compose logs -f ubuntu

# 进入容器
docker exec -it rd_ubuntu /bin/bash
```

---

## Shell 配置接口

### Oh My Zsh 安装脚本

**脚本路径**：`./shell/Oh-My-Zsh/install.sh`

**功能**：一键安装 Oh My Zsh 并配置国内镜像源

**参数**：无参数，交互式安装

**依赖**：
- zsh
- curl 或 wget
- unzip
- git（可选，用于自动更新）

**返回值**：
- 0：成功
- 1：失败

**使用示例**：
```bash
cd shell/Oh-My-Zsh
chmod +x install.sh
./install.sh
```

**脚本特性**：
- 自动检测 zsh、curl/wget、unzip 等依赖
- 使用国内镜像源下载 Oh My Zsh
- 自动备份现有 .zshrc 和 .oh-my-zsh
- 配置 Gitee 镜像源用于自动更新
- 详细的代码注释和错误提示

**功能**：一键安装 Oh My Zsh 并配置国内镜像源

**参数**：无参数，交互式安装

**依赖**：
- zsh
- curl 或 wget
- unzip

**返回值**：
- 0：成功
- 1：失败

**使用示例**：
```bash
cd shell
./install.sh
```

### Shell 配置文件

**配置文件路径**：`./shell/Oh-My-Zsh/zshrc`

**使用方法**：
```bash
# 复制配置文件到用户目录
cp ./shell/Oh-My-Zsh/zshrc ~/.zshrc

# 重新加载配置
source ~/.zshrc
```

**主要配置项**：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| ZSH_THEME | robbyrussell | 主题名称 |
| plugins | git, autojump, ... | 插件列表 |
| HYPHEN_INSENSITIVE | true | 连字符不敏感 |

**自定义别名**：
```bash
alias setp='export https_proxy="http://${hostip}:7890";...'
alias unsetp='unset https_proxy; unset http_proxy; ...'
```

### Homebrew 管理脚本

**列出包按日期**：`./shell/brew/list-brew-packages-by-date.sh`
**按日期卸载包**：`./shell/brew/uninstall-brew-by-date.sh`

**功能说明**：
- `list-brew-packages-by-date.sh`: 按安装日期列出已安装的 Homebrew 包
- `uninstall-brew-by-date.sh`: 按日期选择并卸载 Homebrew 包

**使用示例**：
```bash
# 查看已安装包的安装日期
cd shell/brew
./list-brew-packages-by-date.sh

# 按日期卸载包
./uninstall-brew-by-date.sh
```

---

## Vim 配置接口

### 配置文件

| 文件 | 路径 | 说明 |
|------|------|------|
| vimrc1 | `./vim/vimrc1` | Vim 配置版本 1 |
| vimrc2 | `./vim/vimrc2` | Vim 配置版本 2 |

### 主要功能

#### 快捷键映射

| 快捷键 | 功能 |
|--------|------|
| F5 | 编译并运行 C/C++/Java 程序 |
| F8 | 使用 GDB 调试 C/C++ 程序 |
| Ctrl+A | 全选 + 复制 |
| F2 | 删除空行 |
| Ctrl+F2 | 垂直比较文件 |

#### 插件配置

| 插件 | 功能 |
|------|------|
| CTags | 代码标签浏览 |
| Taglist | 标签列表窗口 |
| MiniBufExpl | 缓冲区管理 |

### 使用方法

```bash
# 复制配置文件到用户目录
cp ./vim/vimrc1 ~/.vimrc

# 或使用 vimrc2
cp ./vim/vimrc2 ~/.vimrc

# 重新加载配置
source ~/.vimrc
```

---

## Git 配置接口

### Git 忽略文件

**参考路径**：`https://github.com/github/gitignore.git`

**常用语言模板**：
- Python
- Go
- C/C++
- Java
- Node.js
- etc.

**使用方法**：
```bash
# 下载模板
curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore
```

### 配置项

| 配置项 | 说明 |
|--------|------|
| user.name | 用户名 |
| user.email | 用户邮箱 |
| core.autocrlf | 换行符处理 |
| push.default | 推送策略 |

---

## 附录

### 容器状态查询

```bash
# 查看所有容器状态
docker-compose ps

# 查看资源使用情况
docker stats

# 查看网络配置
docker network inspect network_inner
```

### 日志管理

```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs -f [service_name]

# 限制日志行数
docker-compose logs --tail=100 [service_name]
```

### 数据备份

```bash
# Redis 备份
docker exec rd_redis redis-cli -a redis BGSAVE

# MariaDB 备份
docker exec rd_mariadb mysqldump -u root -proot --all-databases > backup.sql

# 数据卷备份
docker run --rm -v rd_mariadb_data:/data -v $(pwd):/backup alpine tar czf /backup/mariadb-data.tar.gz /data
```

### 故障排除

```bash
# 检查容器健康状态
docker inspect rd_redis | grep -A 10 Health

# 查看容器详细日志
docker logs rd_redis --tail 500

# 重新构建容器
docker-compose up -d --build --force-recreate
```

---

## 更新日志

- 2025-01-31：初始版本发布，包含所有基础服务接口文档
