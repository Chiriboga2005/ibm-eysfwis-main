CREATE TABLE telefono (
    idtelefono INT NOT NULL AUTO_INCREMENT,
    idpersona INT NOT NULL,
    numero VARCHAR(20) NOT NULL,
    tipo VARCHAR(50) NOT NULL DEFAULT 'Celular',
    PRIMARY KEY (idtelefono),
    KEY idx_telefono_persona (idpersona),
    CONSTRAINT fk_telefono_persona
        FOREIGN KEY (idpersona)
        REFERENCES persona (idpersona)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
