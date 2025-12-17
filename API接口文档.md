# 驾照考试系统 API 接口文档

## 基础信息

- **Base URL**: `http://localhost:8080`
- **数据格式**: JSON
- **字符编码**: UTF-8

## 统一响应格式

### 成功响应
```json
{
    "code": 1,
    "msg": "success",
    "data": {}
}
```

### 失败响应
```json
{
    "code": 0,
    "msg": "错误信息",
    "data": null
}
```

---

## 1. 用户认证接口

### 1.1 用户登录
- **接口地址**: `POST /api/login`
- **接口说明**: 用户登录，返回Token
- **请求参数**:
```json
{
    "username": "admin",
    "password": "admin123"
}
```
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "id": 1,
        "username": "admin",
        "name": "管理员",
        "token": "eyJhbGciOiJIUzI1NiJ9..."
    }
}
```

---

## 2. 题目管理接口

### 2.1 获取题目列表
- **接口地址**: `GET /api/questions`
- **接口说明**: 分页查询题目列表
- **请求参数**:
  - `typeId` (可选): 题型ID
  - `subjectType` (可选): 科目类型（科目一、科目四）
  - `difficulty` (可选): 难度（简单、中等、困难）
  - `page` (可选): 页码，默认1
  - `pageSize` (可选): 每页数量，默认10
- **请求示例**: `GET /api/questions?subjectType=科目一&page=1&pageSize=10`
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "total": 1040,
        "records": [
            {
                "questionId": 2404,
                "subjectType": "科目一",
                "typeId": 3,
                "questionContent": "饮酒后驾驶机动车的，一次记12分。",
                "optionA": "",
                "optionB": "",
                "optionC": "",
                "optionD": "",
                "correctAnswer": "√",
                "analysis": null,
                "score": 1,
                "difficulty": "易",
                "hasImage": 0,
                "imagePath": "",
                "createTime": "2025-12-16T11:45:46",
                "updateTime": "2025-12-16T11:45:46"
            },
            {
                "questionId": 934,
                "subjectType": "科目一",
                "typeId": 1,
                "questionContent": "23.牵引故障车时，牵引车和被牵引车均应当开启危险报警闪光灯。",
                "optionA": "正确",
                "optionB": "错误",
                "optionC": "",
                "optionD": "",
                "correctAnswer": "A",
                "analysis": "",
                "score": 1,
                "difficulty": "易",
                "hasImage": 0,
                "imagePath": "",
                "createTime": "2025-12-16T11:37:54",
                "updateTime": "2025-12-16T11:37:54"
            },
            {
                "questionId": 935,
                "subjectType": "科目一",
                "typeId": 3,
                "questionContent": "24. 行车中遇交通事故受伤者需要抢救时，应怎样做？\nA、及时将伤者送医院抢救或拨打急救电话\nB、尽量避开，少惹麻烦\nC、绕过现场行驶\nD、借故避开现场\n答案：A\n25.在道路上发生交通事故造成人身伤亡时，要立即抢救受伤人员并迅速报警。",
                "optionA": "",
                "optionB": "",
                "optionC": "",
                "optionD": "",
                "correctAnswer": "√",
                "analysis": "",
                "score": 1,
                "difficulty": "易",
                "hasImage": 0,
                "imagePath": "",
                "createTime": "2025-12-16T11:37:54",
                "updateTime": "2025-12-16T11:37:54"
            }
        ]
    }
}
```

### 2.2 根据ID获取题目
- **接口地址**: `GET /api/questions/{id}`
- **接口说明**: 根据题目ID获取题目详情
- **响应示例**:
- ```json
  {
    "code": 1,
    "msg": "success",
    "data": {
        "questionId": 1,
        "subjectType": "科目一",
        "typeId": 1,
        "questionContent": "1.机动车驾驶人饮酒后驾驶机动车的，一次记几分？",
        "optionA": "1分",
        "optionB": "3分",
        "optionC": "6分",
        "optionD": "12分",
        "correctAnswer": "D",
        "analysis": "",
        "score": 1,
        "difficulty": "易",
        "hasImage": 0,
        "imagePath": "",
        "createTime": "2025-12-16T11:37:54",
        "updateTime": "2025-12-16T11:37:54"
    }
}

### 2.3 新增题目
- **接口地址**: `POST /api/questions`
- **接口说明**: 新增题目（管理员功能）
- **请求参数**:
```json
{
    "subjectType": "科目一",
    "typeId": 1,
    "content": "题目内容",
    "optionA": "选项A",
    "optionB": "选项B",
    "optionC": "选项C",
    "optionD": "选项D",
    "answer": "B",
    "score": "2",
    "difficulty": "简单",
    "explanation": "解析内容"
}
```

### 2.4 更新题目
- **接口地址**: `PUT /api/questions`
- **接口说明**: 更新题目信息（管理员功能）

### 2.5 删除题目
- **接口地址**: `DELETE /api/questions/{id}`
- **接口说明**: 删除题目（管理员功能）

---

## 3. 试卷管理接口

### 3.1 获取所有试卷
- **接口地址**: `GET /api/exam-paper`
- **接口说明**: 获取所有启用的试卷列表
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": [
        {
            "paperId": 3,
            "paperName": "科目一模拟考试1",
            "subjectType": "科目一",
            "totalScore": 100,
            "passScore": 90,
            "totalQuestion": 100,
            "singleNum": 80,
            "multiNum": 0,
            "judgeNum": 20,
            "createTime": "2025-12-16T11:45:53",
            "updateTime": "2025-12-16T11:45:53"
        },
    ]
}
```

### 3.2 根据ID获取试卷
- **接口地址**: `GET /api/exam-paper/{id}`

### 3.3 新增试卷
- **接口地址**: `POST /api/exam-paper`
- **接口说明**: 创建新试卷（管理员功能）

### 3.4 更新试卷
- **接口地址**: `PUT /api/exam-paper`
- **接口说明**: 更新试卷信息（管理员功能）

### 3.5 删除试卷
- **接口地址**: `DELETE /api/exam-paper/{id}`
- **接口说明**: 删除试卷（管理员功能）

---

## 4. 考试相关接口

### 4.1 获取试卷题目
- **接口地址**: `GET /api/exam/{examId}/questions`
- **接口说明**: 根据试卷ID获取题目列表（随机抽取）
- **请求示例**: `GET /api/exam/1/questions`
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "questions": [
            {
                "questionId": 881,
                "subjectType": "科目一",
                "typeId": 1,
                "questionContent": "61. 驾驶人未携带哪种证件驾驶机动车上路，交通警察可依法扣留车辆？",
                "optionA": "机动车通行证",
                "optionB": "居民身份证",
                "optionC": "从业资格证",
                "optionD": "机动车行驶证",
                "correctAnswer": "D",
                "analysis": "",
                "score": 1,
                "difficulty": "易",
                "hasImage": 0,
                "imagePath": "",
                "createTime": "2025-12-16T11:37:54",
                "updateTime": "2025-12-16T11:37:54"
            },
          ......
          ......
          ......
       ]
    }
}

```

### 4.2 开始考试
- **接口地址**: `POST /api/exam/{examId}/start`
- **接口说明**: 创建考试记录，开始考试
- **请求参数**: `userId` (Query参数)
- **请求示例**: `POST /api/exam/1/start?userId=1`
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "recordId": 2,
        "userId": 1,
        "paperId": 1,
        "examScore": 0,
        "examTime": 0,
        "isPass": 0,
        "examStartTime": "2025-12-17T20:42:30.2402783",
        "examEndTime": null
    }
}
```

### 4.3 提交考试答案
- **接口地址**: `POST /api/exam/{examId}/submit`
- **接口说明**: 提交考试答案，系统自动判分
- **请求参数**:
```json
{
    "examRecordId": 1,
    "answers": [
        {
            "questionId": 1,
            "userAnswer": "B"
        },
        {
            "questionId": 2,
            "userAnswer": "A"
        }
    ]
}
```
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "recordId": 2,
        "userId": 1,
        "paperId": 1,
        "examScore": 1,
        "examTime": 12,
        "isPass": 0,
        "examStartTime": "2025-12-17T20:42:30",
        "examEndTime": "2025-12-17T20:54:44.6177706"
    }
}
```

### 4.4 获取考试记录详情
- **接口地址**: `GET /api/exam/record/{recordId}`
- **接口说明**: 获取某次考试的详细答题记录
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "recordId": 1,
        "details": [
            {
                "id": 1,
                "examRecordId": 1,
                "questionId": 1,
                "userAnswer": "B",
                "correctAnswer": "B",
                "isCorrect": true,
                "score": 2
            }
        ]
    }
}
```

---

## 5. 用户相关接口

### 5.1 获取用户考试记录
- **接口地址**: `GET /api/user/{userId}/records`
- **接口说明**: 获取用户的所有考试记录
- **请求示例**: `GET /api/user/1/records`
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "userId": 1,
        "records": [
            {
                "id": 1,
                "examPaperId": 1,
                "score": 95,
                "totalScore": 100,
                "correctCount": 95,
                "wrongCount": 5,
                "status": "已完成",
                "startTime": "2024-01-01T10:00:00",
                "submitTime": "2024-01-01T10:45:00"
            }
        ]
    }
}
```

### 5.2 获取用户错题列表
- **接口地址**: `GET /api/user/{userId}/wrong-questions`
- **接口说明**: 获取用户的错题本
- **请求示例**: `GET /api/user/1/wrong-questions`
- **响应示例**:
```json
{
    "code": 1,
    "msg": "success",
    "data": {
        "userId": 1,
        "wrongQuestions": [
            {
                "id": 1,
                "content": "题目内容",
                "optionA": "选项A",
                "optionB": "选项B",
                "optionC": "选项C",
                "optionD": "选项D",
                "answer": "B",
                "explanation": "解析内容"
            }
        ]
    }
}
```

### 5.3 删除错题
- **接口地址**: `DELETE /api/user/{userId}/wrong-questions/{questionId}`
- **接口说明**: 从错题本中删除指定题目

---

## 6. 用户管理接口（Web管理端）

### 6.1 获取用户列表
- **接口地址**: `GET /admin/users`
- **接口说明**: 分页查询用户列表（管理员功能）
- **请求参数**:
  - `page` (可选): 页码，默认1
  - `pageSize` (可选): 每页数量，默认10

### 6.2 根据ID获取用户
- **接口地址**: `GET /admin/users/{id}`

### 6.3 新增用户
- **接口地址**: `POST /admin/users`
- **请求参数**:
```json
{
    "username": "test",
    "password": "123456",
    "name": "测试用户",
    "phone": "13800138000",
    "role": "学员",
    "status": "正常"
}
```

### 6.4 更新用户
- **接口地址**: `PUT /admin/users`

### 6.5 删除用户
- **接口地址**: `DELETE /admin/users/{id}`

---

## 错误码说明

| 错误码 | 说明 |
|--------|------|
| 0 | 操作失败 |
| 1 | 操作成功 |

## 注意事项

1. 所有需要认证的接口需要在请求头中携带Token: `Authorization: Bearer {token}`
2. 时间格式统一使用ISO 8601格式: `yyyy-MM-ddTHH:mm:ss`
3. 分页查询默认从第1页开始
4. 所有接口都支持CORS跨域访问

## 测试工具推荐

- Postman
- Thunder Client (VS Code插件)
- Apifox
- Swagger UI (可集成到项目中)







