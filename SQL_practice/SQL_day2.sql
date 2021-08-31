# SQL Day-2

use ssac;

# 정수 타입 (integer types)
create table number1( data tinyint );
show tables;
desc number1;
insert into number1 value(128); # tinyint는 127까지만 입력으로 받아서 오류 남.
insert into number1 value(127);
select * from number1;
-- unsigned : 입력값을 양수만 받음
create table number2( data tinyint unsigned);
show tables;
insert into number2 value(128);
select * from number2;

# 실수 타입 (float types)
create table number3( data float );
insert into number3 value(123.456789);
select * from number3; -- float type은 6자리 숫자 저장
create table number4( data double );
insert into number4 value(123.4567890123456789);
select * from number4; -- double type은 17자리 숫자 저장


# DECIMAL, NUMERIC

# CHAR, VARCHAR (character, variable character)
# VARCHAR : CHAR 보다 1바이트씩 많이 쓰지만, 길이에 맞게 사용.
use world;
SELECT * FROM country;

#TEXT
-- 긴 문자열 저장시 사용

# DATE, DATETIME, TIMESTAMP, TIME, YEAR


# 2. Constraint: 제약조건

# foreign key
use world;
desc city; -- Key 값에 MUL. 다른 테이블과 관계

desc country; -- Default 값

# 3. CREATE USE ALTER DROP (DDL)
# DDL : CREATE
CREATE database test;
SHOW databases;
use ssac;
select database(); -- 현재 선택된 데이터베이스 확인
create table user1(
	user_id int,
    name varchar(20),
    email varchar(30),
    age int,
    rdate date
);
show tables;
desc user1;

-- 제약조건 추가해서 테이블 생성
create table user2(
	user_id int primary key auto_increment, -- 자동으로 1씩 증가
    name varchar(20) not null,
    email varchar(30) not null unique, -- 보통 primary key는 한번만 사용하기에, not null unique 사용
    age int default 30,
    rdate timestamp
);
desc user2;

# DDL : ALTER
SHOW variables like 'character_set_database'; -- 현재 데이터베이스의 인코딩 방식
ALTER database ssac character set = ascii; -- utf8 -> ascii
ALTER database ssac character set = utf8; -- ascii -> utf8

# Column ADD
ALTER TABLE user2 ADD tmp TEXT;
# Column Modify
ALTER TABLE user2 MODIFY COLUMN tmp INT; -- data type 변경
DESC user2;
# Column Drop
ALTER TABLE user2 DROP tmp;
# table 인코딩 확인
SHOW FULL COLUMNS FROM user2;
# table 인코딩 변경
ALTER TABLE user2 CONVERT TO character set ascii;
ALTER TABLE user2 CONVERT TO character set utf8;
DESC user2;

# DDL : DEL
SHOW tables;
DROP TABLE number1;
DROP TABLE number2, number3, number4;

SHOW databases;
DROP DATABASE test;

# CRUD : CREATE : INSERT
USE ssac;
DESC user2;
INSERT INTO user2(name, email, age)
VALUE('peter', 'peter@gmail.com', 23);
SELECT * FROM user2;
-- 여러개 입력할땐 VALUES
INSERT INTO user2(name, email, age)
VALUES('andy', 'andy@gmail.com', 23)
, ('po', 'po@gmail.com', 25)
, ('ted', 'ted@gmail.com', 39)
;
SELECT * FROM user2;

INSERT INTO user2(name, email)
VALUE('mysql', 'mysql@gmail.com'); -- age 입력이 없으면 default값 30 입력
SELECT * FROM user2;

INSERT INTO user2(name, email)
value ('alice', 'ted@gamil.com'); -- 메일은 unique해야해서 중복으로 오류남.
SELECT * FROM user2;

USE world;
SELECT countrycode, name, population
FROM city
WHERE population >= 800*10000;

CREATE TABLE city_800(
	countrycode CHAR(3),
    name VARCHAR(50),
    population INT
);
DESC city_800;
-- 실행 결과 city_800에 저장
INSERT INTO city_800
SELECT countrycode, name, population
FROM city
WHERE population >= 800*10000;

SELECT * FROM city_800;

# UPDATE
USE ssac;
SELECT * FROM user2;
UPDATE user2
SET email='mysql@daum.net', age=40
WHERE name = 'mysql'
LIMIT 5; -- safe update mode 때문에 오류 남! -> limit 걸어줘야 함


# DELETE 
SELECT * FROM user2 WHERE age <= 30;
DELETE * FROM user2 WHERE age <= 30;
SELECT * FROM user2

# Foreign Key 
# 데이터의 무결성을 지킬 수 있는 제약조건.
CREATE DATABASE test;
USE test;
CREATE TABLE user(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    addr VARCHAR(20)
);

CREATE TABLE money(
	money_id INT PRIMARY KEY AUTO_INCREMENT,
    income INT,
    user_id INT
);

show tables;

# foreign key 생성
DESC money;
ALTER TABLE money ADD CONSTRAINT fk_user
FOREIGN KEY (user_id)
REFERENCES user (user_id);

INSERT INTO user(name, addr)
VALUES ('peter', 'seoul'), ('andy', 'busan');
SELECT * FROM user;

INSERT INTO money(income, user_id)
VALUES(5000, 1), (6000,2);
SELECT * FROM money;

-- error : user 테이블에 2번까지밖에 없어서 3번은 안들어가짐. 
-- money table의 무결성 지켜줌.
INSERT INTO money(income, user_id)
VALUES(10000, 3);

-- foreign key 떄문에 삭제 안됨
-- money 테이블에서 참조중이기 때문에
DELETE FROM user
WHERE user_id = 1
limit 1;


# ON DELETE, ON UPDATE 설정
# 참조되는 데이터를 수정, 삭제할 때 참조하는 데이터를 어떻게 처리할 지를 설정
# CASCADE : 참조되는 테이블에서 데이터를 삭제/수정하면 참조하는 테이블 데이터도 삭제/수정.
# SET NULL : 참조하는 데이터 NULL 값으로 변경
# NO ACTION : 참조하는 데이터를 변경하지 않음
# SET DEFAULT : 참조하는 데이터를 컬럼의 default 값으로 변경
# RESTRICT : 참조하는 데이터를 삭제하거나 수정할 수 없음 -- 보통 기본적인 FOREIGN KEY 설정임

DROP TABLE money;
DROP TABLE user;
CREATE TABLE user(
	user_id int primary key auto_increment,
    name varchar(20),
    addr varchar(20)
);
INSERT INTO user(name, addr)
VALUES ("peter", "seoul"), ("andy", "pusan");
SELECT * FROM user;

DROP TABLE money;
CREATE TABLE money(
	money_id INT PRIMARY KEY AUTO_INCREMENT,
    income INT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
	ON UPDATE CASCADE ON DELETE SET NULL -- user_id가 삭제되면, money 테이블의 user_id를 null데이터로 바꿈
);
INSERT INTO money(income, user_id)
VALUES (5000,1), (6000,1), (9000,2), (3000,2);
SELECT * FROM money;

UPDATE user
SET user_id=3
WHERE user_id=2
LIMIT 1;
SELECT * FROM money;

DELETE FROM user
WHERE user_id=3
LIMIT 1;
SELECT * FROM money;


# Functions 1 : round, date_format, concat, count, distinct
USE world;
SELECT countrycode, language, percentage
	   , ceil(percentage), round(percentage, 0), truncate(percentage, 0)
FROM countrylanguage;

# date_format(): 날짜데이터에 대한 포맷을 변경
use sakila;
SELECT payment_date, date_format(payment_date, '%Y-%m')
FROM payment;
SELECT DISTINCT(date_format(payment_date, '%H')) as unique_hour
FROM payment
ORDER BY unique_hour;


# CONCAT
USE world;
SELECT code, name, concat(name, '(', code, ')')
FROM country;

# COUNT : row의 개수를 셈
SELECT COUNT(*)
FROM city
WHERE population >= 100 * 10000;

# countrylanguage 테이블에서 전세계 언어 종류의 개수를 출력
SELECT COUNT(DISTINCT(language))
FROM countrylanguage;

# Functions 2 : if, ifnull, case when then
# if
# 도시의 인구가 100만이 넘으면 big, 아니면 small을 출력하는 sclae 컬럼을 출력하세요.
SELECT name, population, IF(population>=100*10000, 'big', 'small') AS scale
FROM city
ORDER BY population DESC;

#ifnull
SELECT code, name, indepyear, ifnull(indepyear, 0)
FROM country;

# case when then : 조건이 여러개인 경우 사용
# 국가의 인구가 1억이상 big, 1천만 이상 medium, 1천만 미만 small
SELECT name, population,
	   CASE 
			WHEN population >= 10000*10000 THEN 'big'
            WHEN population >= 1000*10000 THEN 'medium' 
            ELSE 'small'
	   END AS scale
FROM country
ORDER BY population DESC;


#GROUP BY & HAVING
# 특정 컬럼에 있는 동일한 데이터를 합쳐주는 방법
# 반드시 결합함수를 사용해야 함 : count, min, max, avg, sum...
# 국가 코드별 도시의 개수
SELECT countrycode, count(countrycode) as city_count
FROM city
GROUP BY countrycode
ORDER BY city_count DESC
LIMIT 5;

# 국가 코드별 모든 도시의 인구 총합을 출력
SELECT countrycode, sum(population) as total_population
FROM city
GROUP BY countrycode
ORDER BY total_population DESC;

# country 테이블에서 대륙별 인구의 총합을 출력
SELECT continent, sum(population) as total_population
FROM country
GROUP BY continent
ORDER BY tota_population DESC;

# GNP의 총합, 대륙별 인당 GNP를 출력
SELECT continent, sum(gnp) as total_gnp, (sum(gnp)/sum(population)) as gnp1
FROM country
GROUP BY continent
ORDER BY gnp1 DESC;

# 년도와 월별 총 매출을 출력
use sakila;
SELECT date_format(payment_date, '%Y-%m') as ym, sum(amount) as amount_ym
FROM payment
GROUP BY ym
order by amount_ym DESC;

#시간별 매출 출력
SELECT date_format(payment_date, '%H') as hour, sum(amount) as amount_hour, count(amount) as num_payment
FROM payment
GROUP BY hour
ORDER BY amount_hour DESC;


# HAVING
# GROUP BY, JOIN 과 같은 쿼리를 실행한 결과 데이터를 필터링 할 때 사용
# 대륙별 전체 인구를 출력하고 전체 인구가 5억 이상인 대륙을 출력alter
use world;

SELECT continent, sum(population) as population
FROM country
WHERE population >= 50000*10000
GROUP BY continent;

-- 위 쿼리는 먼저 인구수 5억 이상인 국가를 필터링 후, GROUP BY로 묶음
-- HAVING을 쓰면 GROUP BY를 실행한 후에 필터링.
SELECT continent, sum(population) as population
FROM country
GROUP BY continent
HAVING population >= 50000*10000;

# WITH ROLLUP
# 여러개의 컬럼을 GROUP BY하고 각 컬럼별 총합을 row로 출력
# 대륙별, 지역별 인구수의 총합
SELECT ifnull(continent, 'total'), ifnull(region, 'total')
	   , sum(population) as population
FROM country
GROUP BY continent, region
WITH ROLLUP;

# 변수선언
SET @data = 1;
SELECT @data;

# city 테이블에서 도시의 인구수가 많은 5개 도시를 출력하고 내림차순으로 sorting
SET @RANK = 0;
SELECT @RANK := @RANK+1 AS ranking, countrycode, name, population
FROM city
ORDER BY population DESC
LIMIT 5;

# countrylanguage에서 언어별 20개 이상의 국가에서 사용하는 언어를 조회해서 
# 언어별 사용되는 국가 수에 따라서 내림차순으로 정렬해서 출력
SELECT language, count(language) as count
FROM countrylanguage
GROUP BY language
HAVING count>=20
ORDER BY count DESC;


# country 테이블에서 대륙별 전체면적, 전체인구, 인구밀도(전체인구/표면적)
# 인구밀도 높은 순으로 내림차순해서 정렬
SELECT continent, sum(surfacearea) as total_area, sum(population) as total_population,
		sum(population)/sum(surfacearea) as density
FROM country
GROUP BY continent
ORDER BY density DESC;


# Summary
# datatype : INT, FLOAT, DOUBLE, CHAR, VARCHAR, TEXGT, DATETIME, TIMESTAMP
# constraint : NOT NULL, UNIQUE, PRIMARY KEY, AUTO_INCREMENT, FOREIGN KEY
# FOREIGN KEY : 데이터 테이블의 무결성 - ON UPDATE, ON DELETE
# DDL : CREATE, ALTER, DROP
# DML : CRUD - CREATE(INSERT), READ(SELECT), UPDATE(UPDATE), DELETE(DELETE)
# Function : CEIL, ROUND, TRUNCATE, DATE_FORMAT, CONCAT, COUNT
# 			 IF, IFNULL, CASE WHEN THEN
# GROUP BY, HAVING




