-- =============================================
-- 驾照考试系统一键建库脚本（支持清空重建）
-- 执行方式：mysql -u root -p < driving_exam_create_db.sql
-- =============================================

-- 1. 关闭外键检查（避免删除表时因外键关联报错）
SET FOREIGN_KEY_CHECKS = 0;

-- 2. 一键删除旧数据库（核心：实现“重建”）
DROP DATABASE IF EXISTS driving_exam_system;

-- 3. 创建新数据库（指定UTF8MB4编码，支持中文/特殊字符）
CREATE DATABASE driving_exam_system 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 4. 切换到新数据库
USE driving_exam_system;

-- -------------------------- 表1：系统用户表（管理员/学员） --------------------------
CREATE TABLE sys_user (
    user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID（自增主键）',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录账号（唯一）',
    password VARCHAR(100) NOT NULL COMMENT '密码（MD5加密）',
    real_name VARCHAR(20) NOT NULL COMMENT '真实姓名',
    phone VARCHAR(11) UNIQUE COMMENT '手机号（唯一）',
    role VARCHAR(20) NOT NULL COMMENT '角色：admin/student',
    status TINYINT DEFAULT 1 COMMENT '状态：1=正常，0=禁用',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_role (role) COMMENT '按角色查询索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- -------------------------- 表2：题型字典表（基础数据） --------------------------
CREATE TABLE question_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '题型ID（自增主键）',
    type_name VARCHAR(20) NOT NULL UNIQUE COMMENT '题型名称：单选/多选/判断',
    type_desc VARCHAR(100) DEFAULT '' COMMENT '题型描述',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题型字典表';

-- -------------------------- 表3：题库主表（核心业务表） --------------------------
CREATE TABLE question_bank (
    question_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '题目ID（自增主键）',
    subject_type VARCHAR(20) NOT NULL COMMENT '科目：科目一/科目四',
    type_id INT NOT NULL COMMENT '题型ID（关联question_type）',
    question_content TEXT NOT NULL COMMENT '题干内容',
    option_a VARCHAR(500) DEFAULT '' COMMENT '选项A',
    option_b VARCHAR(500) DEFAULT '' COMMENT '选项B',
    option_c VARCHAR(500) DEFAULT '' COMMENT '选项C',
    option_d VARCHAR(500) DEFAULT '' COMMENT '选项D',
    correct_answer VARCHAR(50) NOT NULL COMMENT '正确答案（A/AB/对）',
    analysis TEXT COMMENT '答案解析',  -- 移除DEFAULT ''，允许NULL（插入时无解析则为NULL）
    score TINYINT DEFAULT 1 COMMENT '题目分值',
    difficulty VARCHAR(10) DEFAULT '易' COMMENT '难度：易/中/难',
    has_image TINYINT DEFAULT 0 COMMENT '是否有图片：0=无，1=有',
    image_path VARCHAR(255) DEFAULT '' COMMENT '图片路径',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    -- 索引：优化查询速度
    INDEX idx_subject (subject_type) COMMENT '按科目查询索引',
    INDEX idx_type (type_id) COMMENT '按题型查询索引',
    -- 外键：关联题型表，禁止删除被引用的题型
    FOREIGN KEY (type_id) REFERENCES question_type(type_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='驾照考试题库主表';

-- -------------------------- 表4：试卷配置表（模拟/正式考试） --------------------------
CREATE TABLE exam_paper (
    paper_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '试卷ID（自增主键）',
    paper_name VARCHAR(100) NOT NULL COMMENT '试卷名称（如：科目一模拟考试1）',
    subject_type VARCHAR(20) NOT NULL COMMENT '科目：科目一/科目四',
    total_score TINYINT NOT NULL COMMENT '试卷总分',
    pass_score TINYINT NOT NULL COMMENT '及格分',
    total_question TINYINT NOT NULL COMMENT '总题数',
    single_num TINYINT DEFAULT 0 COMMENT '单选题数',
    multi_num TINYINT DEFAULT 0 COMMENT '多选题数',
    judge_num TINYINT DEFAULT 0 COMMENT '判断题数',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_paper_subject (subject_type) COMMENT '按科目查询试卷索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷配置表';

-- -------------------------- 表5：考试记录表（用户考试整体记录） --------------------------
CREATE TABLE exam_record (
    record_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID（自增主键）',
    user_id INT NOT NULL COMMENT '用户ID（关联sys_user）',
    paper_id INT NOT NULL COMMENT '试卷ID（关联exam_paper）',
    exam_score TINYINT NOT NULL COMMENT '考试得分',
    exam_time INT NOT NULL COMMENT '考试时长（分钟）',
    is_pass TINYINT COMMENT '是否及格：1=是，0=否',
    exam_start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '考试开始时间',
    exam_end_time TIMESTAMP COMMENT '考试结束时间',
    -- 索引：按用户+考试时间快速查询
    INDEX idx_user_exam (user_id, exam_start_time),
    -- 外键：关联用户/试卷表
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (paper_id) REFERENCES exam_paper(paper_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户考试记录表';

-- -------------------------- 表6：考试答题详情表（每道题记录） --------------------------
CREATE TABLE exam_record_detail (
    detail_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '详情ID（自增主键）',
    record_id INT NOT NULL COMMENT '考试记录ID（关联exam_record）',
    question_id INT NOT NULL COMMENT '题目ID（关联question_bank）',
    user_answer VARCHAR(50) DEFAULT '' COMMENT '用户作答答案',
    is_correct TINYINT COMMENT '是否正确：1=是，0=否',
    -- 外键：删除考试记录时，同步删除答题详情
    FOREIGN KEY (record_id) REFERENCES exam_record(record_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question_bank(question_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试答题详情表';

-- -------------------------- 表7：错题本表 --------------------------
CREATE TABLE wrong_question (
    wrong_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '错题ID（自增主键）',
    user_id INT NOT NULL COMMENT '用户ID（关联sys_user）',
    question_id INT NOT NULL COMMENT '题目ID（关联question_bank）',
    wrong_answer VARCHAR(50) DEFAULT '' COMMENT '用户错误答案',
    wrong_reason VARCHAR(200) DEFAULT '' COMMENT '错误原因',
    add_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '加入错题本时间',
    INDEX idx_user_wrong (user_id) COMMENT '按用户查询错题索引',
    -- 外键：删除用户时，同步删除其错题
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question_bank(question_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户错题本表';

-- 5. 初始化基础数据（无需手动录入的固定数据）
-- 初始化题型字典
INSERT INTO question_type (type_name, type_desc) VALUES 
('单选', '单选题，仅一个正确答案'),
('多选', '多选题，多个正确答案'),
('判断', '判断题，对/错二选一');

-- 初始化管理员账号（密码：123456，MD5加密后：e10adc3949ba59abbe56e057f20f883e）
INSERT INTO sys_user (username, password, real_name, phone, role) VALUES 
('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', '13800138000', 'admin');

-- ======================== 新增：3个核心视图 ========================
-- 视图1：v_question_with_type（题目 + 题型名称）
CREATE OR REPLACE VIEW v_question_with_type AS
SELECT 
    q.question_id,
    q.subject_type,       -- 科目一/科目四
    t.type_name,          -- 单选/多选/判断（题型名称）
    q.question_content,   -- 题干
    q.option_a,
    q.option_b,
    q.option_c,
    q.option_d,
    q.correct_answer,     -- 正确答案
    q.analysis,           -- 答案解析
    q.has_image,          -- 是否有图片
    q.image_path          -- 图片路径
FROM question_bank q
LEFT JOIN question_type t ON q.type_id = t.type_id
ORDER BY q.question_id;

-- 视图2：v_exam_record_summary（考试记录汇总：用户名、考试时间、分数）
CREATE OR REPLACE VIEW v_exam_record_summary AS
SELECT 
    u.user_id,
    u.username,           -- 用户名
    u.real_name,          -- 真实姓名（扩展字段）
    p.paper_name,         -- 试卷名称（扩展字段）
    r.exam_score,         -- 考试分数
    r.is_pass,            -- 是否及格（扩展字段）
    r.exam_start_time AS exam_time,  -- 考试时间（重命名）
    r.exam_time AS exam_duration     -- 考试时长（分钟，扩展字段）
FROM exam_record r
LEFT JOIN sys_user u ON r.user_id = u.user_id
LEFT JOIN exam_paper p ON r.paper_id = p.paper_id
ORDER BY r.exam_start_time DESC;

-- 视图3：v_user_wrong_questions（某用户的错题列表）
CREATE OR REPLACE VIEW v_user_wrong_questions AS
SELECT 
    w.wrong_id,
    u.user_id,
    u.username,           -- 用户名
    q.question_id,
    q.subject_type,       -- 科目
    t.type_name,          -- 题型
    q.question_content,   -- 错题题干
    q.correct_answer,     -- 正确答案
    w.wrong_answer,       -- 用户错误答案
    w.wrong_reason,       -- 错误原因
    w.add_time            -- 加入错题本时间
FROM wrong_question w
LEFT JOIN sys_user u ON w.user_id = u.user_id
LEFT JOIN question_bank q ON w.question_id = q.question_id
LEFT JOIN question_type t ON q.type_id = t.type_id
ORDER BY w.add_time DESC;

-- 6. 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 7. 执行成功提示
SELECT '✅ 驾照考试系统数据库创建成功！' AS result,
       '🔑 管理员账号：admin，密码：123456' AS admin_info;