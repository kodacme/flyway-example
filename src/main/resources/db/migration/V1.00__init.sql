drop table if exists fruits cascade;
create table fruits (
  id varchar(6),
  name varchar(30),
  kind varchar(10),
  primary key (id)
);
