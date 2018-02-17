create database godbex;
create user godbex with password 's3kr1tW0r9';
grant all privileges on database godbex to godbex;

-- connect to db with new user

create table invoice (
    invoice_number  int not null primary key,
    invoice_date    date not null,
    customer_name   varchar not null,
    notes           varchar
);

create table line_item (
    line_item_id    serial not null primary key,
    invoice_number  int not null references invoice(invoice_number),
    product_name    varchar not null,
    item_count      int not null check (item_count > 0) default 1,
    cost_per_item   numeric(10,2) not null
);


insert into invoice values
(1, '2018-02-10', 'Fred Flintstone', null),
(2, '2018-02-11', 'Barney Rubble', 'expidite!!!'),
(3, '2018-02-12', 'Mork', null);

insert into line_item (invoice_number, product_name, item_count, cost_per_item) values
(1, 'Deluxe Granite Cube', 10, 2.50),
(1, 'Shiny Marble Slab', 1, 19.90),
(1, 'Pele Lava Rocks', 20, 3.75),
(1, 'Basalt Tower', 1, 122.50),
(2, 'Deluxe Granite Cube', 5, 2.50),
(2, 'Shiny Marble Slab', 2, 19.90),
(2, 'Pele Lava Rocks', 5, 3.75),
(3, 'Basalt Tower', 5, 122.50),
(3, 'Deluxe Granite Cube', 100, 2.50);

select invoice.*, line_item.* from invoice inner join line_item on invoice.invoice_number = line_item.invoice_number;

--  invoice_number | invoice_date |  customer_name  |    notes    | line_item_id | invoice_number |    product_name     | item_count | cost_per_item
-- ----------------+--------------+-----------------+-------------+--------------+----------------+---------------------+------------+---------------
--               1 | 2018-02-10   | Fred Flintstone |             |            1 |              1 | Deluxe Granite Cube |         10 |          2.50
--               1 | 2018-02-10   | Fred Flintstone |             |            2 |              1 | Shiny Marble Slab   |          1 |         19.90
--               1 | 2018-02-10   | Fred Flintstone |             |            3 |              1 | Pele Lava Rocks     |         20 |          3.75
--               1 | 2018-02-10   | Fred Flintstone |             |            4 |              1 | Basalt Tower        |          1 |        122.50
--               2 | 2018-02-11   | Barney Rubble   | expidite!!! |            5 |              2 | Deluxe Granite Cube |          5 |          2.50
--               2 | 2018-02-11   | Barney Rubble   | expidite!!! |            6 |              2 | Shiny Marble Slab   |          2 |         19.90
--               2 | 2018-02-11   | Barney Rubble   | expidite!!! |            7 |              2 | Pele Lava Rocks     |          5 |          3.75
--               3 | 2018-02-12   | Mork            |             |            8 |              3 | Basalt Tower        |          5 |        122.50
--               3 | 2018-02-12   | Mork            |             |            9 |              3 | Deluxe Granite Cube |        100 |          2.50
-- (9 rows)
