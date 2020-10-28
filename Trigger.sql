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

-- Триггер 2
-- Сделать триггер, который делает проверку из запроса выше и не дает создать лишний профайл для аккаунта (исходя из лимита подписки)

DROP TRIGGER IF EXISTS new_profiles_limit;
delimiter //

CREATE TRIGGER new_profiles_limit BEFORE INSERT ON profiles 
FOR EACH ROW
begin 
DECLARE profiles_count INT, profiles_limit INT; -- объявляем 2 переменных для проверки

-- записываем количество профайлов у введенного юзера в переменную profiles_count
select count(p.profile_nickname) into profiles_count
from profiles p
join users u
on p.account = u.account_id
where p.profile_nickname = new.profile_nickname
;

-- записываем доступный лимит профайлов у введенного юзера в переменную profiles_limit
select
case 
	when dos.subcsription_id = '1' then 8
	when dos.subcsription_id = '2' then 4
	when dos.subcsription_id = '3' then 2
	end
into profiles_limit
from profiles p
join users u 
on p.account = u.account_id
join details_of_subcsription dos 
on u.subscription_id = dos.subcsription_id
where p.profile_nickname = new.profile_nickname
;

-- Добавляем проверку лимита добавления через IF
    IF profiles_count >= profiles_limit then   
    
-- Тут нужно добавить команду НЕ добавления новой строки    
        UPDATE 
        SET 
       ;
    else
-- Тут нужно добавить команду добавления новой строки  
        INSERT INTO 
        VALUES(new.);


INSERT INTO `profiles` 
SET 
-- тут непонятно что написать
;
end //

delimiter ;
