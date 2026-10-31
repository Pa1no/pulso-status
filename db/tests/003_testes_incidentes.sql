-- testes de falha

-- resultado válido

INSERT INTO incidentes (iniciado_em, monitor_id)
VALUES ('2026-10-30 15:00:00-03', 9);

-- monitor_id inexistente

INSERT INTO incidentes (iniciado_em, monitor_id)
VALUES ('2026-10-30 15:00:00-03', 99999);

-- resolvido_em anterior ao iniciado_em (erro de datas)

INSERT INTO incidentes (iniciado_em, resolvido_em, monitor_id)
VALUES ('2026-10-30 15:00:00-03', '2026-10-20 15:00:00-03', 9);

-- segundo incidente aberto para o mesmo monitor

INSERT INTO incidentes (iniciado_em, monitor_id)
VALUES ('2026-10-31 15:00:00-03', 9);

-- UPDATE fechando incidente para abrir outro

UPDATE incidentes
SET resolvido_em = NOW()
WHERE monitor_id = 9;

-- DELETE dos dados

DELETE FROM incidentes
WHERE monitor_id IN (
    SELECT id FROM monitores WHERE nome ILIKE 'teste%'
);

DELETE FROM resultados
WHERE monitor_id IN (
    SELECT id FROM monitores WHERE nome ILIKE 'teste%'
);

DELETE FROM monitores
WHERE nome ILIKE 'teste%';