-- NIVELL 1
-- Exercici 1
-- A
create table credit_card(
id varchar(15) primary key,
iban varchar(255) default null,
pan varchar(255) default null,
pin varchar(255) default null,
cvv varchar(255) default null,
expiring_date varchar(255));

-- Introducció de les dades de "dades_introduir_credit"

alter table transaction
    add foreign key transaction(credit_card_id)
    references credit_card(id);
    
-- Excercici 2
update credit_card set iban = "R323456312213576817699999" where id = "CcU-2938";

-- Exercici 3
insert into credit_card (id) values ("CcU-9999");
insert into company (id) values ("b-9999");
insert into transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined ) values ( "108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999, 829.999, -117.999, null, 111.11, 0);

--  Comprobació que s'han afegit les diferents insercions on es correspon i que no donen error.
select credit_card_id, company_id, company.id as "Comprobació ID companyia", credit_card.id as "Comprobació ID tarjeta"
from transaction
join credit_card
on credit_card_id = credit_card.id
join company
on company_id = company.id
where transaction.id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";

-- Exercici 4
select* from credit_card;
alter table credit_card
drop column pan;
select* from credit_card;

-- NIVELL 2
-- Excercici 1
delete from transaction where id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";
select *
from transaction
where id ="02C6201E-D90A-1859-B4EE-88D2986D3B02";

-- Exercici 2
create view VistaMarketing as
select company_name, phone, country, round(avg(amount),2) as Mitjana
from transaction
join company
on company_id = company.id
where declined = 0
group by company_name, phone, country
order by Mitjana desc;
select*from vistamarketing;

-- Excercici 3
select company_name
from vistamarketing
where country = "Germany";

-- NIVELL 3
-- Exercici 1


-- Taula creada a partir de l'estructura de dades de user
CREATE INDEX idx_user_id ON transaction(user_id);
 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255),
        FOREIGN KEY(id) REFERENCES transaction(user_id)        
    );
    
-- S'introdueixen les dades.    
/*Cal esmentar que s'ha d'introduir una dada extra, que serà el user 
de la transacció afegida amb anterioritat.*/

alter table data_user drop foreign key data_user_ibfk_1;
insert into user (id) values (9999);
alter table transaction add foreign key transaction (user_id) references data_user(id);

-- Ara modificaré les taules per adaptar-les a l'esquema
-- Modificacions per user que passa a ser data_user
rename table user to data_user;
alter table data_user change email personal_email varchar(150);
show columns from data_user; 

-- Modificacions per company
alter table company drop column website;
show columns from company;

-- Modificacions a credit_card, en aquest cas dels tipus de dades
alter table credit_card modify column id varchar(20);
alter table credit_card modify column iban varchar(50);
alter table credit_card modify column pin varchar(4);
alter table credit_card modify column cvv int;
alter table credit_card modify column expiring_date varchar(20);
alter table credit_card add column fecha_actual date;
show columns from credit_card;

select distinct id from data_user;

-- Exercici 2
create view InformeTecnico as
select transaction.id as "ID de la transacció", name as "Nom", surname as "Cognom", iban as "IBAN", company_name as "Companyia", amount as "Despesa", declined as "Operació rebutjada"
from transaction
join company
on company_id = company.id
join credit_card
on credit_card_id = credit_card.id
join data_user
on user_id = data_user.id
order by declined asc;

