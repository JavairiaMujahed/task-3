SELECT * FROM TITANIC LIMIT 5;
SELECT DISTINCT SEX FROM TITANIC;
SELECT * FROM TITANIC WHERE sex='male';
SELECT * FROM TITANIC WHERE age<10 AND survived=0 AND pclass=1;
SELECT sex,age FROM TITANIC WHERE sex='female' OR age<5;
SELECT DISTINCT sex FROM TITANIC WHERE NOT sex='female';
SELECT sex,age FROM TITANIC WHERE sex<>'female';
SELECT DISTINCT sex AS unique_sex FROM TITANIC;
SELECT * FROM TITANIC WHERE cabin IS NULL;
SELECT * FROM TITANIC WHERE cabin IS NOT NULL;
SELECT survived,embarked,sibsp FROM TITANIC
WHERE embarked IN ('S','C') AND
sibsp IN (0,1,3);
SELECT survived,embarked,sibsp FROM TITANIC
WHERE (sibsp BETWEEN 2 AND 4) AND
(embarked BETWEEN 'A' AND 'Q');
SELECT COUNT(age) AS "age_count",
SUM(age) AS "age_sum",
AVG(age) AS "age_mean",
MIN(age) AS "age_min",
MAX(age) AS "age_max",
VARIANCE(age) AS "age_variance",
STDDEV(age) AS "age_stddev"
FROM TITANIC;
SELECT age,survived FROM TITANIC
WHERE age IS NOT NULL
ORDER BY age DESC;
SELECT sex, COUNT(sex) FROM TITANIC
GROUP BY(sex)
ORDER BY count DESC;
SELECT sibsp, COUNT(*) FROM TITANIC
GROUP BY sibsp
HAVING COUNT(*)>10
ORDER BY count DESC;
/* QUERIES TO ANALYZE THE TITANIC DATASET*/
/*Q1-What percentage of males and females survived?*/
SELECT sex,
ROUND((COUNT(sex)/AVG(c.count))*100,1)AS survived_percentage FROM TITANIC
LEFT JOIN
(SELECT sex,COUNT(sex) FROM TITANIC GROUP BY sex) AS c USING(sex)
WHERE survived=1
GROUP BY survived,sex
ORDER BY survived_percentage DESC
/*Q2-What percentage of passengers survived per class?*/
SELECT pclass
ROUND((COUNT(*)/AVG(c.count))*100,1) AS percent_survived
FROM TITANIC
LEFT JOIN(SELECT pclass,COUNT(pclass) FROM TITANIC GROUP BY pclass) AS c
USING(pclass)
WHERE survived=1
GROUP BY survived, pclass
HAVING survived=1 
ORDER BY pclass
/*Q3-Count the number of passengers by their title?*/
WITH total AS(SELECT COUNT(*) FROM TITANIC)
SELECT REPLACE(SUBSTRING(name,',[a-zA-Z]*'),',','')AS title,
COUNT(*) AS frequency,
CONCAT(ROUND((COUNT(*)/AVG(total.count))*100,2),'%') AS relative_frequency
FROM titanic,total
GROUP BY title
ORDER BY frequency DESC
/*Q4-What is the average fare, number of passengers and total fare earned per class?*/
SELECT pclass,
ROUND(AVG(fare)::DECIMAL,2) AS average_fare,
TRUNC(AVG(c.count)) AS passenger_count,
ROUND(SUM(fare)::DECIMAL,2) AS total_fare
FROM TITANIC
LEFT JOIN(SELECT pclass, COUNT(pclass) FROM TITANIC GROUP BY pclass) AS c
USING(pclass)
GROUP BY pclass
ORDER BY pclass;
/*Q5-Did having a sibling/spouse aboard help the passengers survive?*/
SELECT sibsp,
ROUND((COUNT(*)/AVG(c.count))*100,1)AS percent_survived
FROM TITANIC
LEFT JOIN(SELECT sibsp, COUNT(sibsp)FROM TITANIC GROUP BY sibsp) AS c
USING(sibsp)
GROUP BY sibsp,survived
HAVING survived=1
ORDER BY percent_survived DESC
/*Q6-What is the count of passengers per cabin code (first character in the cabin string)?*/
SELECT LEFT(cabin,1) AS cabin_code,
COUNT(*)
FROM TITANIC
WHERE cabin IS NOT NULL
GROUP BY cabin_code
ORDER BY count DESC