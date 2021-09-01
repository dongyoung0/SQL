use ssac;
# DROP TABLE user;
CREATE TABLE user(
	user_id int primary key auto_increment, 
    name VARCHAR(30) NOT NULL
);
# DROP table addr;
CREATE TABLE addr(
	addr_id INT PRIMARY KEY AUTO_INCREMENT,
    addr_name VARCHAR(30) NOT NULL,
    user_id INT NOT NULL
);

INSERT INTO user(name)
VALUES ('Jin'), ('Po'), ('Alice');
SELECT * FROM user;

INSERT INTO addr(addr_name, user_id)
VALUES ('Seoul', 1), ('Busan', 2), ('Daegu', 4), ('Seoul', 5);
SELECT * FROM addr;

# INNER JOIN
SELECT *
FROM user
JOIN addr
WHERE user.user_id = addr.user_id;

SELECT user.user_id, user.name, addr.addr_name
FROM user
JOIN addr -- INNER JOIN 을 써줘야 하지만 INNER 는 생략 가능
ON user.user_id = addr.user_id; -- JOIN 아래 ON이 WHERE랑 같은 역할


# LEFT JOIN
SELECT user.user_id, user.name, addr.addr_name
FROM user
LEFT JOIN addr
ON user.user_id = addr.user_id; -- JOIN 아래 ON이 WHERE랑 같은 역할

#RIGHT JOIN
SELECT addr.user_id, user.name, addr.addr_name -- user.user_id를 출력하면 NULL값이 생겨시 addr.user_id로
FROM user
RIGHT JOIN addr
ON user.user_id = addr.user_id; -- JOIN 아래 ON이 WHERE랑 같은 역할

# 국가코드, 국가이름, 국가인구, 도시이름, 도시인구를 출력
use world;
SELECT country.code, country.name, country.population, city.name, city.population
FROM country
JOIN city
ON country.code = city.countrycode;

# 도시 인구가 500만명 이상인 도시만 출력
# 도시 인구수 내림치순으로 정렬
use world;
SELECT country.code, country.name, country.population
		 , city.name, city.population
FROM country
JOIN city
ON country.code = city.countrycode
HAVING city.population >= 500*10000
ORDER BY city.population DESC;

# 도시별 국가 인구에 대한 비율을 출력하는 컬럼을 추가하세요.
SELECT country.code, country.name, country.population
		 , city.name, city.population
		 , city.population / country.population * 100 as ratio
FROM country
JOIN city
ON country.code = city.countrycode
HAVING city.population >= 500*10000
ORDER BY ratio DESC
LIMIT 10;

# 스태프 아이디, 스태프 풀네임, 매출액
use sakila;
SELECT * 
FROM payment;
SELECT * 
FROM staff;

SELECT staff.staff_id, CONCAT(staff.first_name, staff.last_name) as full_name
	 , sum(amount) as total_amount
FROM staff
JOIN payment
ON payment.staff_id = staff.staff_id
GROUP BY payment.staff_id;

# 테이블 세개 조인
# 국가이름, 도시이름, 사용언어, 사용언어 비율
use world;
select country.name as country_name, city.name as city_name
	   , language, percentage
from country
join city
on country.code = city.countrycode
join countrylanguage
on country.code = countrylanguage.countrycode;

select country.name as country_name, city.name as city_name
	   , language, percentage
from country, city, countrylanguage
where country.code = city.countrycode 
      and country.code = countrylanguage.countrycode;

# 국가의 언어 사용 비율을 도시의 언어 사용 비율과 같다고 가정할 떄 
# 도시의 언어 사용 인구를 출력

select country.name as country_name, city.name as city_name
	   , countrylanguage.language, countrylanguage.percentage
       , round(city.population * countrylanguage.percentage / 100, 0) as rate
from country, city, countrylanguage
where country.code = city.countrycode 
      and country.code = countrylanguage.countrycode;

# UNION : 쿼리를 실행한 결과를 row 데이터 기준으로 합쳐서 출력
use ssac;
SELECT name
FROM user
UNION -- all : 중복 데이터 제거하지 않고 합침
SELECT addr_name
from addr;

# OUTER JOIN
SELECT user.user_id, user.name, addr.addr_name
FROM user
LEFT JOIN addr
ON user.user_id = addr.user_id
UNION
SELECT user.user_id, user.name, addr.addr_name
FROM user
RIGHT JOIN addr
ON user.user_id = addr.user_id;


# SUB QUERY : 쿼리 안에 쿼리를 사용
# SELECT, FROM, WHERE

# SUB QUERY : SELECT
# 전체 나라수, 전체 도시수, 전체 언어수를 하나의 row, 세개의 column 으로 출력
use world;
SELECT (SELECT COUNT(*) FROM country) as country_count
	   , (SELECT COUNT(*) FROM city) as city_count
       , (SELECT COUNT(DISTINCT(language)) FROM countrylanguage) as language_count
FROM dual;

# 인구수 800만 이상이 되는 도시의 국가코드, 국가이름, 도시이름, 도시인구수 출력

SELECT country.code, country.name, city.name, city.population
FROM country
JOIN city
ON country.code = city.countrycode
HAVING city.population >= 800 * 10000;

SELECT country.code, country.name, city.name, city.population
FROM (SELECT * FROM city WHERE population >= 800*10000) AS city
JOIN country
ON country.code = city.countrycode;


# WHERE 
# 800만 이상 도시의 
use world;
SELECT countrycode
FROM city
WHERE population >= 800 * 10000;

SELECT code, name, headofstate
FROM country
WHERE code in (
	SELECT countrycode
    FROM city
    WHERE population >= 800*10000
);

SELECT code, name, headofstate, population
FROM country
WHERE population >= (SELECT population FROM country WHERE code = 'KOR');
# any : or : 둘 중에 한가지만 만족해도 True
SELECT code, name, headofstate, population
FROM country
WHERE population >= OR(
	SELECT population FROM country WHERE code IN ('KOR', 'BRA')
# all : and : 둘 다 만족해야 True
SELECT code, name, headofstate, population
FROM country
WHERE population >= ALL(
	SELECT population FROM country WHERE code IN ('KOR', 'BRA')
);

# 대륙과 지역별 사용하는 언어의 수 출력
SELECT country.continent, country.region, countrylanguage.language
FROM country
JOIN countrylanguage
ON country.code = countrylanguage.countrycode;

# continent, region별 language의 수를 출력
SELECT country.continent, country.region, countrylanguage.language
FROM country
JOIN countrylanguage
ON country.code = countrylanguage.countrycode;

SELECT continent, region, count(language)
FROM(
	SELECT country.continent, country.region, countrylanguage.language
	FROM country
	JOIN countrylanguage
	ON country.code = countrylanguage.countrycode
) AS sub
GROUP BY continent, region;

# View
# 가상의 테이블로 특정 쿼리를 실행한 결과 데이터를 출력하는 용도
# 실제 데이터를 저장 X -> 수정 및 인덱스 설정이 불가능
# 쿼리를 조금 더 단순하게 작성하게 해주는 기능

# 800만 이상의 도시인구가 있는 국가의 국가코드, 국가이름, 도시이름
SELECT country.code, country.name, city_800.name
FROM (
	SELECT countrycode, name
	FROM city
    WHERE population >= 800*10000
) AS city_800
JOIN country
ON country.code = city_800.countrycode;

CREATE view city2 as
SELECT countrycode, name
FROM city
WHERE population >= 800*10000;

SELECT country.code, country.name, city2.name
FROM city2
JOIN country
ON country.code = city2.countrycode;

use employees;
show tables;
SELECT COUNT(*) FROM salaries;
SHOW index FROM salaries;
DESC salaries;

SELECT * FROM salaries WHERE to_date < "1986-01-01"; #763ms
#인덱스 생성
CREATE index tdate ON salaries (to_date); 
SHOW index FROM salaries;

#인덱스 생성 후 속도가 훨씬 빨라짐
SELECT * FROM salaries WHERE to_date < "1986-01-01"; #37ms
#인덱스 삭제 후 속도가 엄청 느려짐
DROP index tdate On salaries;
SHOW index FROM salaries;
SELECT * FROM salaries WHERE to_date < "1986-01-01"; #1.37s

#쿼리 실행 전에 인덱스를 사용하는지 등 확인 
-- Extra : Using index condition
EXPLAIN
SELECT * FROM salaries WHERE to_date < "1986-01-01";


