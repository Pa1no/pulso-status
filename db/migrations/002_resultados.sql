CREATE TABLE resultados (
	id BIGINT                       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	verificado_em TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
	status TEXT                     NOT NULL,
	codigo_http INT,
	tempo_resposta_ms INT,
	monitor_id INT                  NOT NULL,

	CONSTRAINT fk_monitor 
		FOREIGN KEY (monitor_id) 
		REFERENCES monitores(id)
		ON DELETE RESTRICT,

	CONSTRAINT chk_status_valido CHECK (status IN ('sucesso', 'lento', 'falha'))
);

CREATE INDEX idx_resultados_monitor_verificado
	ON resultados (monitor_id, verificado_em);