CREATE TABLE Towns ( id SERIAL UNIQUE NOT NULL, code VARCHAR(10) NOT NULL,  article TEXT, name TEXT NOT NULL,  department VARCHAR(4),  UNIQUE (code));

insert into towns ( code, article, name, department ) select left(md5(i::text), 10), md5(random()::text), md5(random()::text),left(md5(random()::text), 4) from generate_series(1, 1000000) s(i)