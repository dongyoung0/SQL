use world;

SELECT country.code, country.name, country.population
	 , sum(city.population) as city_population
     , count(city.name) as city_count
FROM country
JOIN city
ON country.code = city.countrycode
GROUP BY country.code, country.name, country.population;

# Mysql Quiz 3 - join & sub-query 

# 1. 멕시코(Mexico)보다 인구가 많은 나라이름과 인구수를 조회하시고 인구수순으로 내림차순하세요. 
SELECT Name, Population
FROM country 
WHERE population > ( SELECT population FROM country WHERE name = 'Mexico')
ORDER BY population DESC;

# 2. 국가별 몇개의 도시가 있는지 조회하고 도시수순으로 10위까지 내림차순하세요.
SELECT country.Name, COUNT(city.Name) AS count
FROM city
JOIN country
ON city.countrycode = country.code
GROUP BY city.CountryCode
ORDER BY count DESC
LIMIT 10;


# 3. 언어별 사용인구를 출력하고 언어사용 인구순으로 10위까지 내림차순하세요.
SELECT countrylanguage.Language, sum(country.population) as count
FROM countrylanguage
JOIN country
ON countrylanguage.countrycode = country.code
WHERE countrylanguage.isofficial = 'T'
GROUP BY countrylanguage.language
ORDER BY count DESC
LIMIT 10;


# 4. 나라전체인구의 10%이상인 도시에서 도시인구가 500만이 넘는 도시를 아래와 같이 조회하세요.
SELECT city.Name, city.CountryCode, country.name, ROUND(city.population / country.population * 100, 2) as percentage
FROM country
JOIN city
ON country.code = city.countrycode AND city.population>500*10000
HAVING percentage >= 10
ORDER BY percentage DESC;

# 5. 면적이 10000km^2 이상인 국가의 인구밀도(1km^2 당인구수)를 구하고 인구밀도(density)가 
# 200이상인 국가들의 사용하고 있는 언어가 2가지인 나라를 조회하세요.
# 출력 : 국가이름, 인구밀도, 언어수출력
CREATE VIEW language2 AS
SELECT countrycode, count(language) as language_count, group_concat(language) as language_list
FROM countrylanguage
GROUP BY CountryCode
HAVING language_count = 2;

SELECT country.name, ROUND(country.population/country.surfacearea) as density, language_count, language_list 
FROM language2
JOIN country
ON country.code = language2.countrycode AND country.surfacearea >= 10000
HAVING density >= 200 
ORDER BY name;


# 6. 사용하는 언어가 3가지 이하인 국가 중 도시인구가 300만 이상인 도시를 아래와 같이 조회하세요.
# * GROUP_CONCAT(LANGUAGE) 을 사용하면 group by 할때문자열을합쳐서볼수있습니다.
# *VIEW를이용해서 query를깔끔하게수정하세요.

CREATE VIEW language3 AS 
SELECT CountryCode, count(language) as language_count, group_concat(language) as languages
	FROM countrylanguage
	GROUP BY CountryCode
	HAVING language_count <= 3;

SELECT city.CountryCode, city.name as city_name
	 , city.population, country.name
     , language_count, languages
FROM language3
JOIN city
ON city.CountryCode = language3.countrycode
JOIN country
ON city.countrycode = country.code
HAVING city.population>300*10000
ORDER BY city.population DESC;


# 7. 한국와미국의인구와 GNP를세로로아래와같이나타내세요.
# (쿼리문에국가코드명을문자열로사용해도됩니다.) 
use world;
CREATE TABLE kor_usa(
	category VARCHAR(30) NOT NULL,
    KOR INT NOT NULL,
    USA INT NOT NULL
    );
INSERT INTO kor_usa()
VALUES ('population', (SELECT population FROM country WHERE code = 'KOR'), (SELECT population FROM country WHERE code = 'USA')),
 ('gnp', (SELECT gnp FROM country WHERE code = 'KOR'), (SELECT gnp FROM country WHERE code = 'USA'));
SELECT * FROM kor_usa;

# 8. sakila 데이터베이스의 payment 테이블에서 수입(amount)의 총합을 아래와 같이 출력하세요.

CREATE VIEW payment_ym AS
SELECT date_format(payment_date, '%Y-%m') AS ym, sum(amount) as amount_ym, count(amount) as rent
FROM payment
GROUP BY ym;
SELECT * FROM payment_ym;
CREATE TABLE ym_payment(
	category VARCHAR(30) NOT NULL, 
    `2005-05` FLOAT NOT NULL, `2005-06` FLOAT NOT NULL, `2005-07` FLOAT NOT NULL, `2005-08` FLOAT NOT NULL, `2006-02` FLOAT NOT NULL
);
INSERT INTO ym_payment()
VALUES ('amount', (SELECT amount_ym FROM payment_ym WHERE ym = '2005-05'), (SELECT amount_ym FROM payment_ym WHERE ym = '2005-06')
	 , (SELECT amount_ym FROM payment_ym WHERE ym = '2005-07'), (SELECT amount_ym FROM payment_ym WHERE ym = '2005-08')
	 , (SELECT amount_ym FROM payment_ym WHERE ym = '2006-02')
);
SELECT * FROM ym_payment;

# 9. 위의결과에서 payment 테이블에서 월별 렌트 횟수 데이터를 추가하여 아래와 같이 출력하세요.
INSERT INTO ym_payment()
VALUES ('rent', (SELECT rent FROM payment_ym WHERE ym = '2005-05'), (SELECT rent FROM payment_ym WHERE ym = '2005-06')
	 , (SELECT rent FROM payment_ym WHERE ym = '2005-07'), (SELECT rent FROM payment_ym WHERE ym = '2005-08')
	 , (SELECT rent FROM payment_ym WHERE ym = '2006-02')
);
SELECT * FROM ym_payment;