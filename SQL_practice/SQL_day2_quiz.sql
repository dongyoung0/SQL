# Mysql Quiz 2 - group by & having 

use world;
#Quiz 1. 국가 코드별 도시의 갯수를 출력하세요. (상위 5개를 출력)
SELECT CountryCode, count(countrycode) as count
FROM city
GROUP BY CountryCode
ORDER BY count DESC
LIMIT 5;

# Quiz 2. 대륙별 몇개의 국가가 있는지 대륙별 국가의 갯수로 내림차순하여 출력하세요.
SELECT continent, count(continent) AS count
FROM country
GROUP BY continent
ORDER BY count DESC;


# Quiz 3. 대륙별 인구가 1000만명 이상인 국가의 수와 GNP의 평균을 소수둘째자리에서 반올림하여 첫째자리까지 출력하세요.
SELECT Continent, COUNT(continent) AS count, ROUND(avg(gnp),1) AS avg_gnp
FROM country
WHERE population > 1000 * 10000
GROUP BY Continent
ORDER BY avg_gnp DESC;


# Quiz 4. city 테이블에서 국가코드(CountryCode)별로 총 인구가 몇명인지 조회하고 총 인구순으로 내림차순하세요. 
# (총 인구가 5천만 이상인 도시만출력)
SELECT CountryCode, SUM(Population) AS Population
FROM city
GROUP BY CountryCode
HAVING Population >= 5000*10000
ORDER BY Population DESC;

# Quiz 5. countrylanguage 테이블에서 언어별 사용하는 국가수를 조회하고 많이 사용하는 언어를 6위에서 10위까지 조회하세요.
SELECT Language, COUNT(Language) AS count
FROM countrylanguage
GROUP BY Language
ORDER BY count DESC
Limit 5, 5;

# Quiz 6. countrylanguage 테이블에서 언어별 20개 국가이상에서 사용되는 언어를 조회하고 언어별 사용되는 국가수에 따라 내림차순하세요.
SELECT Language, COUNT(Language) AS count
FROM countrylanguage
GROUP BY Language
HAVING count >= 20
ORDER BY count DESC;

# Quiz 7. country 테이블에서 대륙별 전체 표면적 크기를 구하고 표면적 크기순으로 내림차순하세요.
SELECT Continent, SUM(SurfaceArea) As SurfaceArea
FROM country
GROUP BY Continent
ORDER BY SurfaceArea DESC;

# Quiz 8. World 데이터베이스의 countrylanguage에서 언어의 사용비율이 90%대(90 ~ 99.9)의 사용율을 갖는 언어의 갯수를 출력하세요. 
SELECT COUNT(language) AS count, TRUNCATE(Percentage, -1) AS Percentage
FROM countrylanguage
GROUP BY TRUNCATE(Percentage, -1)
HAVING Percentage = 90;

SELECT COUNT(language) AS count, TRUNCATE(Percentage, -1) AS Per10
FROM countrylanguage
GROUP BY Per10
HAVING Per10 = 90;

# Quiz 9. 1800년대에 독립한 국가의 수와 1900년대에 독립한 국가의 수를 출력하세요.
SELECT TRUNCATE(IndepYear, -2) AS indepyear_ages, COUNT(*) AS count
FROM country
GROUP BY indepyear_ages
HAVING indepyear_ages = 1800 OR indepyear_ages = 1900
ORDER BY indepyear_ages DESC;

use sakila;
# Quiz 10. sakila의 payment 테이블에서 월별 총 수입을 출력하세요.
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS monthly, SUM(amount) AS amount
FROM payment
GROUP BY monthly;


# Quiz 11. actor 테이블에서 가장 많이 사용된 first_name을 아래와 같이 출력하세요. 
# 가장 많이 사용된 first_name의 횟수를 먼저 구하고, 횟수를 Query에 넣어서 결과를 출력하세요.
SET @num_first = 0;
SELECT COUNT(first_name) AS count 
INTO @num_first
FROM actor
GROUP BY first_name
ORDER BY count DESC
LIMIT 1;

SELECT first_name
FROM actor
GROUP BY first_name
HAVING COUNT(first_name) = @num_first;

# Quiz 12. film_list 뷰에서 카테고리별 가장 많은 매출을 올린 카테고리 3개를 매출순으로 정렬하여 아래와 같이 출력하세요.
SELECT category
FROM film_list
GROUP BY category
ORDER BY sum(price) DESC
Limit 3;

