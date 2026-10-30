-- teste de falhas

-- resultado válido

INSERT INTO resultados (status, codigo_http, tempo_resposta_ms, monitor_id)
	VALUES ('sucesso', 12345, 120, 9);

-- resultado inválido ('bananas' em status)

INSERT INTO resultados (status, codigo_http, tempo_resposta_ms, monitor_id)
	VALUES ('bananas', 12345, 120, 9);

-- resultado inválido (monitor_id inexistente)

INSERT INTO resultados (status, codigo_http, tempo_resposta_ms, monitor_id)
	VALUES ('falha', 12345, 120, 99999);

-- delete do monitor enquanto há resultados dele (erro)

SELECT *
FROM resultados
WHERE monitor_id = 9;

DELETE FROM monitores
WHERE id = 9;