# driver-license-exam-system
驾照考试系统 - Web管理端 + Android移动端

## 模块详细说明

### API 模块 (`/api/`)
- **auth.js**: 处理用户登录、注销、token刷新等认证相关API
- **question.js**: 题目CRUD操作、题目导入/导出等接口
- **user.js**: 用户管理、权限管理、用户信息修改等接口
- **exam.js**: 考试创建、配置、批改、成绩查询等接口

### 路由模块 (`/router/`)
- **index.js**: 定义应用路由规则，配置路由守卫和权限控制

### 工具函数 (`/utils/`)
- **request.js**: 基于axios封装的HTTP请求工具，包含拦截器、错误处理等
- **auth.js**: 处理token存储、验证、用户信息获取等认证相关功能

### 页面组件 (`/views/`)
- **Login.vue**: 用户登录页面
- **Layout.vue**: 主布局组件，包含侧边栏、顶部导航等公共部分
- **Dashboard.vue**: 系统仪表盘，展示统计数据
- **UserList.vue**: 用户管理页面
- **QuestionList.vue**: 题库管理页面
- **ExamConfig.vue**: 考试配置和管理页面
- **LogList.vue**: 系统操作日志查看页面

### 核心文件
- **App.vue**: Vue应用根组件，包含路由视图容器
- **main.js**: 应用入口文件，初始化Vue实例，注册全局组件和插件

## 技术栈
- Vue 3
- Vue Router
- Axios
- Element UI / Ant Design Vue (可选)

## 功能模块
1. **认证模块** - 用户登录/登出、权限验证
2. **用户管理** - 用户信息维护、角色分配
3. **题库管理** - 题目增删改查、分类管理
4. **考试管理** - 考试配置、监考、成绩管理
5. **系统监控** - 操作日志、系统状态

## 开发规范
1. API请求统一通过`utils/request.js`发送
2. 页面组件放在`views/`目录下
3. 公共组件建议放在`components/`目录（如果存在）
4. 路由配置统一在`router/index.js`中管理
5. 接口调用统一在`api/`目录下封装

## 快速开始

### 安装依赖
```bash
npm install
