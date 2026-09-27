-- =========================================================
-- ATIVIDADE - PROJETO DE BANCO DE DADOS
-- Cadastro de Atividades Esportivas
-- Oracle / PL-SQL
-- =========================================================

-- =========================================================
-- 1. CRIACAO DA TABELA
-- =========================================================

CREATE TABLE ATIVIDADES_ESPORTIVAS
(
    "ATIVIDADE_ID" NUMBER GENERATED ALWAYS AS IDENTITY,
    "NOME" VARCHAR2(100) NOT NULL,
    "MODALIDADE" VARCHAR2(60) NOT NULL,
    "DATA_ATIVIDADE" DATE NOT NULL,
    "LOCAL" VARCHAR2(120) NOT NULL,
    "VAGAS" NUMBER NOT NULL,
    "RESPONSAVEL" VARCHAR2(100) NOT NULL,
    "ATIVO" CHAR(1) DEFAULT 'S' NOT NULL,
    "DATA_CADASTRO" DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT "PK_ATIVIDADES_ESPORTIVAS"
        PRIMARY KEY ("ATIVIDADE_ID"),

    CONSTRAINT "CK_ATIVIDADES_ATIVO"
        CHECK ("ATIVO" IN ('S', 'N')),

    CONSTRAINT "CK_ATIVIDADES_VAGAS"
        CHECK ("VAGAS" > 0)
);

SELECT * FROM ATIVIDADES_ESPORTIVAS;


-- =========================================================
-- 2. PROCEDURE PARA VALIDAR E CADASTRAR OS DADOS
-- =========================================================

CREATE OR REPLACE PROCEDURE cadastrar_atividade(
    p_nome           IN VARCHAR2,
    p_modalidade     IN VARCHAR2,
    p_data_atividade IN DATE,
    p_local          IN VARCHAR2,
    p_vagas          IN NUMBER,
    p_responsavel    IN VARCHAR2
)
IS
    v_atividade_id ATIVIDADES_ESPORTIVAS.ATIVIDADE_ID%TYPE;
BEGIN

    IF p_nome IS NULL OR LENGTH(TRIM(p_nome)) < 3 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'O nome da atividade deve possuir pelo menos 3 caracteres.'
        );
    END IF;

    IF p_modalidade IS NULL OR LENGTH(TRIM(p_modalidade)) < 3 THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Informe uma modalidade valida.'
        );
    END IF;

    IF p_data_atividade IS NULL THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Informe a data da atividade.'
        );
    END IF;

    IF TRUNC(p_data_atividade) < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'A data da atividade nao pode ser anterior a data atual.'
        );
    END IF;

    IF p_local IS NULL OR LENGTH(TRIM(p_local)) < 3 THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'Informe um local valido.'
        );
    END IF;

    IF p_vagas IS NULL OR p_vagas <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'A quantidade de vagas deve ser maior que zero.'
        );
    END IF;

    IF p_responsavel IS NULL OR LENGTH(TRIM(p_responsavel)) < 3 THEN
        RAISE_APPLICATION_ERROR(
            -20007,
            'Informe o nome do responsavel.'
        );
    END IF;

    INSERT INTO ATIVIDADES_ESPORTIVAS
    (
        NOME,
        MODALIDADE,
        DATA_ATIVIDADE,
        LOCAL,
        VAGAS,
        RESPONSAVEL
    )
    VALUES
    (
        TRIM(p_nome),
        TRIM(p_modalidade),
        p_data_atividade,
        TRIM(p_local),
        p_vagas,
        TRIM(p_responsavel)
    )
    RETURNING ATIVIDADE_ID INTO v_atividade_id;

    DBMS_OUTPUT.PUT_LINE(
        'Atividade cadastrada. Codigo: ' || v_atividade_id
    );

END cadastrar_atividade;
/


-- =========================================================
-- 3. TESTE DA PROCEDURE
-- =========================================================

BEGIN
    CADASTRAR_ATIVIDADE(
        p_nome           => 'Treino de Futebol',
        p_modalidade     => 'Futebol',
        p_data_atividade => SYSDATE + 7,
        p_local          => 'Quadra Poliesportiva',
        p_vagas          => 20,
        p_responsavel    => 'Professor Andre'
    );
END;
/

SELECT * FROM ATIVIDADES_ESPORTIVAS;
