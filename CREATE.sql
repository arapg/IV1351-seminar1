CREATE TABLE settings (
    max_teaching_load INT NOT NULL
);

CREATE TABLE job_title (
    job_title VARCHAR(100) NOT NULL PRIMARY KEY
);

CREATE TABLE skill_set (
    employee_skill VARCHAR(100) NOT NULL PRIMARY KEY
);

CREATE TABLE address (
    address_id VARCHAR(100) NOT NULL PRIMARY KEY,
    street VARCHAR(100) NOT NULL,
    zip CHAR(5) NOT NULL,
    city VARCHAR(100) NOT NULL,
    house_number INT NOT NULL
);

CREATE TABLE person (
    personal_number CHAR(12) NOT NULL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address_id VARCHAR(100),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE phone_number (
    personal_number CHAR(12) NOT NULL,
    number VARCHAR(100) NOT NULL,
    PRIMARY KEY (personal_number, number),
    FOREIGN KEY (personal_number) REFERENCES person(personal_number)
);

CREATE TABLE employee (
    employee_id VARCHAR(100) NOT NULL PRIMARY KEY,
    supervisor VARCHAR(100),
    personal_number CHAR(12) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    FOREIGN KEY (personal_number) REFERENCES person(personal_number),
    FOREIGN KEY (job_title) REFERENCES job_title(job_title),
    FOREIGN KEY (supervisor) REFERENCES employee(employee_id)
);

CREATE TABLE department (
    department_name VARCHAR(100) NOT NULL PRIMARY KEY,
    manager_id VARCHAR(100),
    FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);

CREATE TABLE employee_department (
    employee_id VARCHAR(100) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee_id, department_name),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (department_name) REFERENCES department(department_name)
);

CREATE TABLE employee_skill_set (
    employee_skill VARCHAR(100) NOT NULL,
    employee_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee_skill, employee_id),
    FOREIGN KEY (employee_skill) REFERENCES skill_set(employee_skill),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE employee_salary_history (
    employee_id VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    PRIMARY KEY (employee_id, valid_from),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE course_layout (
    course_code CHAR(6) NOT NULL,
    layout_version INT NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    min_student INT NOT NULL,
    max_student INT NOT NULL,
    hp DECIMAL(4, 1) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    is_current BOOLEAN,
    PRIMARY KEY (course_code, layout_version)
);

CREATE TABLE course_instance (
    instance_id VARCHAR(100) NOT NULL PRIMARY KEY,
    course_code CHAR(6) NOT NULL,
    layout_version INT NOT NULL,
    num_students INT NOT NULL,
    study_period INT NOT NULL,
    study_year DATE NOT NULL,
    FOREIGN KEY (course_code, layout_version) REFERENCES course_layout(course_code, layout_version)
);

CREATE TABLE teaching_activity (
    activity_id VARCHAR(100) NOT NULL PRIMARY KEY,
    instance_id VARCHAR(100) NOT NULL,
    course_code CHAR(6) NOT NULL,
    layout_version INT NOT NULL,
    activity_type CHAR(100) NOT NULL,
    factor DECIMAL(4, 1),
    FOREIGN KEY (instance_id) REFERENCES course_instance(instance_id),
    FOREIGN KEY (course_code, layout_version) REFERENCES course_layout(course_code, layout_version)
);

CREATE TABLE planned_activity (
    instance_id VARCHAR(100) NOT NULL,
    activity_id CHAR(10) NOT NULL,
    course_code CHAR(6) NOT NULL,
    layout_version INT NOT NULL,
    planned_hours INT NOT NULL,
    PRIMARY KEY (instance_id, activity_id),
    FOREIGN KEY (instance_id) REFERENCES course_instance(instance_id),
    FOREIGN KEY (activity_id) REFERENCES teaching_activity(activity_id),
    FOREIGN KEY (course_code, layout_version) REFERENCES course_layout(course_code, layout_version)
);

CREATE TABLE allocation (
    instance_id VARCHAR(100) NOT NULL,
    activity_id CHAR(10) NOT NULL,
    employee_id VARCHAR(100) NOT NULL,
    course_code CHAR(6) NOT NULL,
    layout_version INT NOT NULL,
    allocated_hours DECIMAL(5, 2),
    PRIMARY KEY (instance_id, activity_id, employee_id),
    FOREIGN KEY (instance_id) REFERENCES course_instance(instance_id),
    FOREIGN KEY (activity_id) REFERENCES teaching_activity(activity_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (course_code, layout_version) REFERENCES course_layout(course_code, layout_version)
);