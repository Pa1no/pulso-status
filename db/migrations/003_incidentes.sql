CREATE TABLE incidentes (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	iniciado_em TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
	resolvido_em TIMESTAMPTZ,
	monitor_id INT           NOT NULL,

	CONSTRAINT fk_incidentes_monitor
		FOREIGN KEY (monitor_id)
		REFERENCES monitores(id)
		ON DELETE RESTRICT,

	CONSTRAINT chk_incidentes_datas CHECK (resolvido_em IS NULL OR resolvido_em >= iniciado_em)
);

CREATE UNIQUE INDEX idx_incidentes_monitor_aberto
	ON incidentes (monitor_id) WHERE resolvido_em IS NULL;

CREATE INDEX idx_incidentes_monitor_iniciado
	ON incidentes (monitor_id, iniciado_em DESC);