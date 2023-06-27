-- Задание №1

--1) Составьте запрос, который выведет имя вида с наименьшим id. Результат будет соответствовать букве «М».

SELECT  species_id, species_name FROM species ORDER BY  species_id, species_name limit 1;

--2) Составьте запрос, который выведет имя вида с количеством представителей более 1800. Результат будет соответствовать букве «Б».

SELECT species_name, species_amount FROM species Where species_amount > 1800; 

--3) Составьте запрос, который выведет имя вида, начинающегося на «П» и относящегося к типу с type_id = 5. 
--Результат будет соответствовать букве «О».

SELECT species_name, type_id FROM species Where species_name LIKE 'П%' or type_id  = 5 LIMIT 1;

--Составьте запрос, который выведет имя вида, заканчивающегося на «са» или количество представителей которого равно 5. 
--Результат будет соответствовать букве В.

SELECT species_name, species_amount FROM species Where species_name LIKE 'са%' OR species_amount  = 5;

--Задание 2

--1)Составьте запрос, который выведет имя вида, появившегося на учете в 2023 году.
--Результат будет соответствовать букве «Ы».

SELECT  DISTINCT to_char(date_start,'2023-04-10'), species_name
FROM species WHERE date_start = '2023-04-10';


--2)Составьте запрос, который выведет названия отсутствующего (status = absent) вида, расположенного вместе с place_id = 3.
--Результат будет соответствовать букве «С».

--1 вариант овтета

SELECT s.species_name
FROM species AS s
JOIN species_in_places AS sp
ON s.species_id = sp.species_id
WHERE s.species_status = 'absent' and place_id = 3;

--2 вариант ответа

SELECT s.species_name
FROM species AS s
LEFT JOIN species_in_places AS  sp ON s.species_id = sp.species_id AND sp.place_id = 3
WHERE s.species_status = 'absent';

--3)Составьте запрос, который выведет название вида, расположенного в доме и появившегося в мае, а также
---и количество представителей вида. Название вида будет соответствовать букве «П».


SELECT s.species_name
FROM species AS s
JOIN species_in_places AS sp
ON s.species_id = sp.species_id
WHERE s.date_start = '2010-05-30'; 


--4) Составьте запрос, который выведет название вида, состоящего из двух слов (содержит пробел).
---Результат будет соответствовать знаку !.

SELECT species_name FROM species
WHERE species_name LIKE '% %' AND species_name NOT LIKE '% % %';

--Задание 3

--1)Составьте запрос, который выведет имя вида, появившегося с малышом в один день. Результат будет соответствовать букве «Ч».

SELECT species_name, COUNT (*) FROM species WHERE date_start = '2022-10-04'  GROUP BY species_name; 

--2)Составьте запрос, который выведет название вида, расположенного в здании с наибольшей площадью.
--Результат будет соответствовать букве «Ж».


SELECT MAX (species_name)
FROM species
WHERE species_name LIKE '%%%%%%%%%%% %%%%%%%';


--3) Составьте запрос/запросы, которые найдут название вида, относящегося к 5-й по численности группе и проживающего дома. 
--Результат будет соответствовать букве «Ш».

SELECT * FROM species_type; --добовление типов 
SELECT * FROM species_in_places; --добавление расположения видов по местам
SELECT * FROM species; --добавление видов 
SELECT * FROM places; --добовление мест 


SELECT s.species_name
FROM species s
JOIN species_type st ON s.type_id = st.type_id
JOIN species_in_places sp ON s.species_id = sp.species_id
JOIN places p ON sp.place_id = p.place_id
WHERE p.place_name = 'дом'
AND st.type_name = (
  SELECT type_name
  FROM (
    SELECT st.type_name, RANK() OVER (ORDER BY SUM(s.species_amount) DESC) AS rank
    FROM species s
    JOIN species_type st ON s.type_id = st.type_id
    JOIN species_in_places sp ON s.species_id = sp.species_id
    JOIN places p ON sp.place_id = p.place_id
    WHERE p.place_name = 'дом'
    GROUP BY st.type_name
  ) AS ranks
  WHERE ranks.rank = 3
)
ORDER BY s.species_name;
     
--4)Составьте запрос, который выведет сказочный вид (статус fairy), не расположенный ни в одном месте. 
--Результат будет соответствовать букве «Т».

SELECT species_name FROM species
LEFT JOIN species_in_places sp ON species.species_id = sp.species_id
WHERE species_status = 'fairy' AND sp.place_id IS NULL;