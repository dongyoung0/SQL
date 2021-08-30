# CRUD : READ
# SELECT FROM
# SQL DAY 1

USE world;

SELECT *
FROM country;

SELECT code, name, population
FROM country;

SELECT code as country_code, name as country_name, population
FROM country;

-- 주석 처리 방법
/* show databases;
show tables; */
-- desc country;
# 주석 workbench

SELECT code
#	   , name
FROM country;

# 산술연산자 사용
SELECT code, name, gnp * 1000 as gnp1000
FROM country;

-- 아시아 국가만 출력
SELECT code, name, continent, continent = "Asia" as is_asia
FROM country;

-- 기대수명이 70살 이상이면서 인구수가 5000만명 이상인 국가 출력
SELECT code, name, population, lifeexpectancy
	   , (LifeExpectancy >= 70) and (population >= 5000*10000) as II
FROM country
ORDER BY II desc;

# WHERE
-- 인구가 1억 이상인 국가 출력
SELECT code, name, population
FROM country
WHERE population >= 10000 * 10000;

-- 인구가 7천만 ~ 1억인 국가 출력
SELECT code, name, population
FROM country
WHERE (population >= 7000 * 10000) and (population <= 10000*10000);

# BETWEEN
-- 인구수가 7000만명~1억 사이인 국가 출력
SELECT code, name, population
FROM country
WHERE population BETWEEN 7000*10000 and 10000*10000;

-- 아시아와 아프리카 대륙의 국가 출력
SELECT code, name, continent, population
FROM country
WHERE continent = "Asia" or continent = "Africa";

# IN, NOT IN
-- 아시아, 아프리카 국가 출력
SELECT code, name, continent, population
FROM country
WHERE continent IN ("Asia", "Africa");

SELECT code, name, continent, population
FROM country
WHERE continent NOT IN ("Asia", "Africa");

# LIKE : 특정 문자열이 포함되어 있는 데이터를 출력
-- 가장 앞에 A가 들어가는 국가 출력
SELECT code, name, localname
FROM country
WHERE localname LIKE "A%";

-- 국가 이름에 ca가 들어가는 국가 출력
SELECT code, name, localname
FROM country
WHERE localname LIKE "%ca%";

# ORDER BY : 데이터의 순서를 정렬
-- 인구수가 많은 순으로 국가를 출력
SELECT code, name, population
FROM country
ORDER BY population DESC;

-- countrycode 기준 오름차순으로 출력
SELECT countrycode, name, population
FROM city
ORDER BY countrycode ASC;

-- countrycode로 내림차순 정렬하는데, 동일한 경우 인구수 오름차순으로 출력
SELECT countrycode, name, population
FROM city
ORDER BY countrycode DESC, population ASC;

# LIMIT : 조회되는 데이터의 수를 제한함
-- 인구 상위 5개의 국가를 내림차순으로 출력
SELECT code, name, population
from country
ORDER BY population DESC
LIMIT 5;

-- 인구 상위 6위 ~ 8위까지의 국가를 내림차순으로 출력
SELECT code, name, population
FROM country
ORDER BY population DESC
LIMIT 5, 3;	 #상위 5개를 스킵, 그 다음 3개 출력

# DISTINCT : 중복을 제거해주는 예약어
-- 인구가 300만 이상인 도시를 가지고 있는 국가의 국가 코드를 출력
SELECT DISTINCT countrycode
FROM city
WHERE population >= 300 * 10000;


# Quiz 1. 한국 (국가코드 : 'KOR') 도시 중 인구가 100만이 넘는 도시를 조회하여 인구수 순으로 내림차순으로 출력하세요.
# 출력 컬럼 : 도시이름(name), 도시 인구수(population)
SELECT name, population
FROM city
WHERE (countrycode = 'KOR') and (population >= 100 * 10000)
ORDER BY population DESC;

#Quiz 2. 도시 인구가 800만 ~ 1000만 사이인 도시의 데이터를 국가코드 순으로 오름차순 하세요.
# 출력 컬럼 : 국가코드(countrycode), 도시이름(name), 도시인구수(population)
SELECT countrycode, name, population
FROM city
WHERE population BETWEEN 800 * 10000 AND 1000 * 10000
ORDER BY countrycode ASC;

#Quiz 3. 1940 ~ 1950년도 사이에 독립한 국가들 중 GNP가 10만이 넘는 국가를 GNP의 내림차순으로 출력하세요.
# 출력 컬럼 : 국가코드(code), 국가이름(name), 대륙(continent), GNP(gnp)
SELECT code, name, continent, gnp
FROM country
WHERE (indepyear BETWEEN 1940 AND 1950) AND (gnp >= 10 * 10000)
ORDER BY gnp DESC;

#Quiz 4. 스페인어(Spanish), 영어(English), 한국어(Korean) 중에 95% 이상 사용하는 국가코드, 언어, 비율을 출력하세요.
# 출력 컬럼 : 국가코드(countrycode), 언어(language), 비율(percnetage)
SELECT countrycode, language, percentage
FROM countrylanguage
WHERE language in ('Spanish', 'English', 'Korean') AND (percentage >= 95)
ORDER BY percentage DESC;

# Quiz 5. 국가 코드가 “K”로 시작하는 국가 중에 기대수명(lifeexpectancy)이 70세 이상인 국가를 기대수명의 내림차순 순으로 출력하세요.
# 출력 컬럼 : 국가코드(code), 국가이름(name), 대륙(continent), 기대수명(lifeexpectancy)
SELECT code, name, continent, lifeexpectancy
FROM country
WHERE (code LIKE 'K%') AND (lifeexpectancy >= 70)
ORDER BY lifeexpectancy DESC;

# Sakila Database
USE sakila;

# Quiz 6. film_text 테이블에서 title이 ICE가 들어가고 description에 Drama가 들어간 데이터를 출력하세요.
# 출력 컬럼 : 필름아이디(film_id), 제목(title), 설명(description)
SELECT film_id, title, description
FROM film_text
WHERE (title LIKE '%ICE%') AND (description LIKE '%Drama%');

# Quiz 7. actor 테이블에서 이름(first_name)의 가장 앞글자가 “A”, 성(last_name)의 
# 		  가장 마지막 글자가 “N”으로 끝나는 배우의 데이터를 출력하세요.
# 출력 컬럼 : 배우아이디(actor_id), 이름(first_name), 성(last_name)
SELECT actor_id, first_name, last_name
FROM actor
WHERE (first_name LIKE 'A%') AND (last_name LIKE '%N');

# Quiz 8. film 테이블에서 rating이 “R” 등급인 film 데이터를 상영시간(length)이 
#		  가장 긴 상위 10개의 film을 상영시간의 내림차순으로 출력하세요.
# 출력 컬럼 : 필름아이디(film_id), 필름제목(title), 필름내용(description), 대여기간(rental_duration)
#		  , 렌탈비율(rental_rate), 상영시간(length), 등급(rating)
SELECT film_id, title, description, rental_duration, rental_rate, length, rating
FROM film
WHERE (rating = 'R')
ORDER BY length DESC
LIMIT 10;

# Quiz 9. 상영시간(length)이 60분 ~ 120분인 필름 데이터에서 영화설명(description)에 
#         robot이 들어있는 영화를 상영시간(length)이 짧은 순으로 오름차순하여 정렬하고, 11위에서 13위까지의 영화를 출력하세요.
# 출력 컬럼 : 필름아이디(film_id), 필름제목(title), 필름내용(description), 상영시간(length)
SELECT film_id, title, description, length
FROM film
WHERE (length BETWEEN 60 AND 120) AND (description LIKE '%robot%')
ORDER BY length
LIMIT 10, 3;

# Quiz 10. film_list view에서 카테고리(category)가 sci-fi, animation, drama가 아니고 
#          배우(actors)가 “ed chase”, “kevin bloom”이 포함된 영화리스트에서 상영시간이 긴 순서대로 5개의 영화 리스트를 출력하세요.
# 출력 컬럼 : 제목(title), 설명(description), 카테고리(category), 상영시간(length), 배우(actors)
SELECT title, description, category, length, actors
FROM film_list view
WHERE (category NOT IN ('sci-fi', 'Animation', 'drama')) AND (actors LIKE '%ed chase%' OR actors LIKE '%kevin bloom%')
ORDER BY length DESC
LIMIT 5;