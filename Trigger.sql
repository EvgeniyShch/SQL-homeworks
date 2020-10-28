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

-- Триггер 2 - делает проверку из запроса выше и не дает создать лишний профайл для аккаунта (исходя из лимита подписки)

DROP TRIGGER IF EXISTS check_accounts_count;

delimiter //

create trigger check_accounts_count 
before insert 
on profiles -- отслеживаем попытку добавить новый профиль
for each row
begin 
	
	declare accounts_count int; -- объявляем переменную для кол-ва аккаунтов
	declare accounts_limit int;-- объявляем переменную для кол-ва аккаунтов
	
	-- получаем кол-во доступных аккаунтов
	select 
	case 
		when subscription_id = '1' then 8
		when subscription_id = '2' then 4
		when subscription_id = '3' then 2
	end
	into accounts_limit
	from users
	where account_id = new.account;

	-- получаем кол-во существующих аккаунтов
	select count(*) into accounts_count from profiles where account = new.account;
	-- проверяем, чтобы доступных аккаунтом было меньше, чем существующих, 
	-- если это не так, выдаём ошибку, данные не добавляются
	if accounts_limit <= accounts_count then 
		signal sqlstate '45000' set message_text = 'Количество учётных записей по тарифному плану превышено!';
	end if;
end//

delimiter ;