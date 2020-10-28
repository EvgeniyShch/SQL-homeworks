-- Триггер 1 - проверяет вставку дат в поле updated_at таблицы users

DROP TRIGGER IF EXISTS users_dates_check;
delimiter //

CREATE TRIGGER users_dates_check BEFORE insert ON users 
FOR EACH ROW
begin 
	if new.updated_at <= new.created_at then 
		set new.updated_at = current_date();
	end if;
end //

delimiter ;


-- Запрос показывает топ юзеров по платежам

select u.account_email, sum(pay.amount) as payment_sum, round(avg(pay.amount),2)  as average_payment
from users u
join payment pay
on u.account_id = pay.account_id
group by u.account_email
having count(pay.amount) > 15
order by payment_sum desc
;


-- Представление 1 - показывает TOP10 фильмов на сервере по оценкам пользователей

DROP VIEW IF EXISTS `show_top_10_movies`;

CREATE VIEW `show_top_10_movies` AS (
select f.film_name, round(avg(r.user_rating),1) as rating
from ratings r
join films f 
on r.film_id = f.film_id
group by f.film_name 
order by rating desc
limit 10)
;

select * from `show_top_10_movies`;


-- Представление 2 -показывает статистику по платежам по годам и месяцам

DROP VIEW IF EXISTS `show_sales_by_years_by_months`;

CREATE VIEW `show_sales_by_years_by_months` AS (
select date_format(p.payment_date , "%Y") as payment_year, 
sum(round(p.amount,0)) as Total,
sum(if(EXTRACT(MONTH FROM p.payment_date)=1, round(p.amount,0), 0)) as January,
sum(if(EXTRACT(MONTH FROM p.payment_date)=2, round(p.amount,0), 0)) as February,
sum(if(EXTRACT(MONTH FROM p.payment_date)=3, round(p.amount,0), 0)) as March,
sum(if(EXTRACT(MONTH FROM p.payment_date)=4, round(p.amount,0), 0)) as April,
sum(if(EXTRACT(MONTH FROM p.payment_date)=5, round(p.amount,0), 0)) as May,
sum(if(EXTRACT(MONTH FROM p.payment_date)=6, round(p.amount,0), 0)) as June,
sum(if(EXTRACT(MONTH FROM p.payment_date)=7, round(p.amount,0), 0)) as July,
sum(if(EXTRACT(MONTH FROM p.payment_date)=8, round(p.amount,0), 0)) as August,
sum(if(EXTRACT(MONTH FROM p.payment_date)=9, round(p.amount,0), 0)) as September,
sum(if(EXTRACT(MONTH FROM p.payment_date)=10, round(p.amount,0), 0)) as October,
sum(if(EXTRACT(MONTH FROM p.payment_date)=11, round(p.amount,0), 0)) as November,
sum(if(EXTRACT(MONTH FROM p.payment_date)=12, round(p.amount,0), 0)) as December
from payment p
group by payment_year
order by payment_year desc)
;

select * from `show_sales_by_years_by_months`;

-- Процедура 1 - показывает все фильмы для детей (с возрастным ограничением введенным пользователем) и отсортировывает их по рейтингу

DROP PROCEDURE IF EXISTS movies_for_kids;
delimiter //
CREATE PROCEDURE movies_for_kids (IN age INT)
BEGIN
  SELECT 
 		f.film_name, c.restriction_by_age as kids_age,  round(avg(r.user_rating),1) as rating
		from films f
		join category c 
		on f.category_id = c.category_id
		join ratings r
		on f.film_id = r.film_id
		where c.restriction_by_age <= age
		group by f.film_name 
		order by kids_age desc, rating desc 
		;
END//
delimiter ;

call movies_for_kids(18); 
call movies_for_kids(16);
call movies_for_kids(10);



-- Процедура 2 - показывает все последние посещения сайта & IP у введенного пользователя

DROP PROCEDURE IF EXISTS show_last_login_history;
delimiter //
CREATE PROCEDURE show_last_login_history (IN username VARCHAR(30))
BEGIN
  SELECT 
		p.profile_nickname, f.film_name, vh.ip_adress, vh.last_used_at
		from viewing_history vh
		join profiles p 
		on vh.profile_id = p.profile_id
		join films f
		on vh.film_id = f.film_id 
		where p.profile_nickname = username
		order by vh.last_used_at desc
		;
END//
delimiter ;

call show_last_login_history('mabel02'); 
call show_last_login_history('lenna95');
call show_last_login_history('zakary77');
call show_last_login_history('bert90');
call show_last_login_history('white.dock');


-- Процедура 3 - показывает все самые просматриваемые фильмы в заданный период времени (года)

DROP PROCEDURE IF EXISTS show_most_popular_movies;
delimiter //
CREATE PROCEDURE show_most_popular_movies (IN start_year INT, end_year INT )
BEGIN
  SELECT 
		f.film_name, count(f.film_name) as views
		from viewing_history vh
		join films f
		on vh.film_id = f.film_id
		where date_format(vh.last_used_at, "%Y") between start_year and end_year
		group by f.film_name
		order by count(f.film_name) desc
		limit 20
		;
END//
delimiter ;

call show_most_popular_movies(2000, 2020); 
call show_most_popular_movies(1980, 2020); 
call show_most_popular_movies(1995, 1999); 
call show_most_popular_movies(2015, 2020); 
call show_most_popular_movies(1980, 1988); 

-- Процедура 4 - показывает все фильмы с доступной озвучкой ИЛИ субтитрами на выбранном пользователем языке и отсортировать их по рейтингу

DROP PROCEDURE IF EXISTS show_movies_with_requested_language;
delimiter //
CREATE PROCEDURE show_movies_with_requested_language (IN requested_language varchar(20) )
BEGIN
  SELECT 
		distinct f.film_name, laof.language_name as audio, lsof.subtitle_name as subtitles, round(avg(r.user_rating),1) as rating
		from films f
		join language_audio_of_film laof 
		on f.film_id = laof.film_id
		join language_subtitle_of_film lsof 
		on f.film_id = lsof.film_id
		join ratings r
		on f.film_id = r.film_id
		where laof.language_name = requested_language or lsof.subtitle_name = requested_language
		group by f.film_name 
		order by rating desc
		;
END//
delimiter ;

call show_movies_with_requested_language('English');
call show_movies_with_requested_language('Russian');
call show_movies_with_requested_language('Espanol');
call show_movies_with_requested_language('Franchais');
call show_movies_with_requested_language('Polski');
call show_movies_with_requested_language('Deutsch');



-- Показывает какой лимит профайлов у каждого аккаунта (исходя из подписки) и сколько заведено профайлов у каждого аккаунта

select u.account_email, dos.subscription_type, 
case 
	when dos.subcsription_id = '1' then 8
	when dos.subcsription_id = '2' then 4
	when dos.subcsription_id = '3' then 2
	end
as subscription_profile_limit,
count(p.profile_nickname) as profiles_count
from profiles p
join users u 
on p.account = u.account_id
join details_of_subcsription dos 
on u.subscription_id = dos.subcsription_id 
group by u.account_email
order by u.account_email
;

