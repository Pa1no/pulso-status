-- teste de rejeição

INSERT INTO monitores (nome, url)
VALUES ('teste', 'https://google.com');

-- resultado do teste

SELECT nome, url, intervalo_segundos, ativo, criado_em FROM monitores
WHERE nome = 'teste';

SELECT id, nome, url, intervalo_segundos FROM monitores;

-- intervalo menos de 30 (falha)

INSERT INTO monitores (nome, url, intervalo_segundos)
VALUES ('teste google', 'https://sitenovo.com', 5);

-- mesma url de antes (falha)

INSERT INTO monitores (nome, url)
VALUES ('teste duplicado', 'https://google.com');

-- sem nome (falha)

INSERT INTO monitores (url)
VALUES ('https://outrosite.com');

-- deletar monitor de teste

SELECT * FROM monitores WHERE nome ILIKE 'teste%';
DELETE FROM monitores
WHERE nome ILIKE 'teste%';