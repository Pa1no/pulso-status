CREATE TABLE monitores (
	id INT                 GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome VARCHAR(256)      NOT NULL,
	url  VARCHAR(2048)     NOT NULL UNIQUE,
	intervalo_segundos INT NOT NULL DEFAULT 60,
	ativo BOOLEAN          NOT NULL DEFAULT TRUE,
	criado_em TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

	CONSTRAINT chk_intervalo_minimo CHECK (intervalo_segundos >= 30)
);