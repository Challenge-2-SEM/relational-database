/*
SPRINT 3
RM563620 - Henrique Martins - 1TDSPF
RM563088 - Henrique Texeira - 1TDSPF
RM562086 - Henrique Gonçalves Pacheco Costa - 1TDSPK
*/

-- ===========================================================
-- Tabela para usuários do sistema (Pacientes e Profissionais)
-- ===========================================================
CREATE TABLE T_HC_USUARIO (
    id_usuario NUMBER(10) GENERATED AS IDENTITY,
    nome VARCHAR2(100) NOT NULL,
    cpf VARCHAR2(14) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    telefone VARCHAR2(20),
    data_nascimento DATE NOT NULL,
    tipo_usuario VARCHAR2(20) NOT NULL,
    data_cadastro DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT T_HC_USUARIO_PK PRIMARY KEY (id_usuario), 
    CONSTRAINT T_HC_USUARIO_CPF_UK UNIQUE (cpf),
    CONSTRAINT T_HC_USUARIO_EMAIL_UK UNIQUE (email),
    CONSTRAINT T_HC_USUARIO_TIPO_CK CHECK (tipo_usuario IN ('PACIENTE', 'PROFISSIONAL')), 
    CONSTRAINT T_HC_USUARIO_CPF_FORMATO_CK CHECK (REGEXP_LIKE(cpf, '^\d{3}\.\d{3}\.\d{3}-\d{2}$')), 
    CONSTRAINT T_HC_USUARIO_EMAIL_FORMATO_CK CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    CONSTRAINT T_HC_USUARIO_DATA_NASC_CK CHECK (data_nascimento < TO_DATE('01-10-2025', 'DD-MM-YYYY')) 
);

-- ================================================================
-- Informações específicas dos pacientes
-- ================================================================
CREATE TABLE T_HC_PACIENTE (
    id_paciente NUMBER(10) GENERATED AS IDENTITY,
    id_usuario NUMBER(10) NOT NULL,
    numero_carteirinha VARCHAR2(50) NOT NULL,
    tipo_sanguineo VARCHAR2(5),
    alergias VARCHAR2(500),
    historico_medico CLOB,
    peso NUMBER(5,2),
    altura NUMBER(3,2),
    CONSTRAINT T_HC_PACIENTE_PK PRIMARY KEY (id_paciente),
    CONSTRAINT T_HC_PACIENTE_CARTEIRINHA_UK UNIQUE (numero_carteirinha),
    CONSTRAINT T_HC_PACIENTE_USUARIO_FK FOREIGN KEY (id_usuario) REFERENCES T_HC_USUARIO(id_usuario) ON DELETE CASCADE, 
    CONSTRAINT T_HC_PACIENTE_TIPO_SANG_CK CHECK (tipo_sanguineo IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')), 
    CONSTRAINT T_HC_PACIENTE_PESO_CK CHECK (peso > 0 AND peso <= 500),
    CONSTRAINT T_HC_PACIENTE_ALTURA_CK CHECK (altura > 0 AND altura <= 3.0) 
);

-- ==================================================
-- Informações específicas dos profissionais de saúde
-- ==================================================
CREATE TABLE T_HC_PROFISSIONAL_SAUDE (
    id_profissional NUMBER(10) GENERATED AS IDENTITY,
    id_usuario NUMBER(10) NOT NULL,
    crm VARCHAR2(20) NOT NULL,
    especialidade VARCHAR2(100) NOT NULL,
    departamento VARCHAR2(100),
    horario_atendimento VARCHAR2(200),
    ativo CHAR(1) DEFAULT 'S' NOT NULL,
    CONSTRAINT T_HC_PROFISSIONAL_SAUDE_PK PRIMARY KEY (id_profissional),
    CONSTRAINT T_HC_PROFISSIONAL_SAUDE_CRM_UK UNIQUE (crm), 
    CONSTRAINT T_HC_PROFISSIONAL_SAUDE_USUARIO_FK FOREIGN KEY (id_usuario) REFERENCES T_HC_USUARIO(id_usuario) ON DELETE CASCADE, 
    CONSTRAINT T_HC_PROFISSIONAL_SAUDE_CRM_FORMATO_CK CHECK (REGEXP_LIKE(crm, '^CRM/[A-Z]{2}\s\d{4,6}$')), 
    CONSTRAINT T_HC_PROFISSIONAL_SAUDE_ATIVO_CK CHECK (ativo IN ('S', 'N'))
);

-- ==========================
-- Agendamentos de consultas
-- ==========================
CREATE TABLE T_HC_AGENDAMENTO (
    id_agendamento NUMBER(10) GENERATED AS IDENTITY,
    id_paciente NUMBER(10) NOT NULL,
    id_profissional NUMBER(10) NOT NULL,
    data_agendamento DATE NOT NULL,
    hora_agendamento VARCHAR2(5) NOT NULL,
    tipo_consulta VARCHAR2(50) NOT NULL,
    status VARCHAR2(20) DEFAULT 'AGENDADO' NOT NULL,
    observacoes VARCHAR2(500),
    data_criacao DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT T_HC_AGENDAMENTO_PK PRIMARY KEY (id_agendamento), 
    CONSTRAINT T_HC_AGENDAMENTO_PACIENTE_FK FOREIGN KEY (id_paciente) REFERENCES T_HC_PACIENTE(id_paciente), 
    CONSTRAINT T_HC_AGENDAMENTO_PROFISSIONAL_FK FOREIGN KEY (id_profissional) REFERENCES T_HC_PROFISSIONAL_SAUDE(id_profissional), 
    CONSTRAINT T_HC_AGENDAMENTO_STATUS_CK CHECK (status IN ('AGENDADO', 'CONFIRMADO', 'CANCELADO', 'REALIZADO')), 
    CONSTRAINT T_HC_AGENDAMENTO_HORA_FORMATO_CK CHECK (REGEXP_LIKE(hora_agendamento, '^\d{2}:\d{2}$')), 
    CONSTRAINT T_HC_AGENDAMENTO_TIPO_CONSULTA_CK CHECK (tipo_consulta IN ('CONSULTA', 'RETORNO', 'EXAME', 'EMERGENCIA')) 
);

-- ==================================
-- Registro das consultas realizadas
-- ==================================
CREATE TABLE T_HC_CONSULTA (
    id_consulta NUMBER(10) GENERATED AS IDENTITY,
    id_agendamento NUMBER(10) NOT NULL,
    data_consulta DATE DEFAULT SYSDATE NOT NULL,
    diagnostico CLOB,
    prescricao CLOB,
    observacoes_medicas CLOB,
    exames_solicitados VARCHAR2(500),
    duracao_minutos NUMBER(3),
    CONSTRAINT T_HC_CONSULTA_PK PRIMARY KEY (id_consulta), 
    CONSTRAINT T_HC_CONSULTA_AGENDAMENTO_UK UNIQUE (id_agendamento),
    CONSTRAINT T_HC_CONSULTA_AGENDAMENTO_FK FOREIGN KEY (id_agendamento) REFERENCES T_HC_AGENDAMENTO(id_agendamento),
    CONSTRAINT T_HC_CONSULTA_DURACAO_CK CHECK (duracao_minutos > 0 AND duracao_minutos <= 480) 
);

-- ==================================
-- Notificações enviadas aos usuários
-- ==================================
CREATE TABLE T_HC_NOTIFICACAO (
    id_notificacao NUMBER(10) GENERATED AS IDENTITY,
    id_usuario NUMBER(10) NOT NULL,
    titulo VARCHAR2(200) NOT NULL,
    mensagem VARCHAR2(1000) NOT NULL,
    data_envio DATE DEFAULT SYSDATE NOT NULL,
    lida CHAR(1) DEFAULT 'N' NOT NULL,
    tipo_notificacao VARCHAR2(50) NOT NULL,
    prioridade VARCHAR2(10) DEFAULT 'NORMAL' NOT NULL,
    CONSTRAINT T_HC_NOTIFICACAO_PK PRIMARY KEY (id_notificacao),
    CONSTRAINT T_HC_NOTIFICACAO_USUARIO_FK FOREIGN KEY (id_usuario) REFERENCES T_HC_USUARIO(id_usuario), 
    CONSTRAINT T_HC_NOTIFICACAO_LIDA_CK CHECK (lida IN ('S', 'N')), 
    CONSTRAINT T_HC_NOTIFICACAO_TIPO_CK CHECK (tipo_notificacao IN ('LEMBRETE', 'CONFIRMACAO', 'CANCELAMENTO', 'ALERTA', 'INFORMACAO')), 
    CONSTRAINT T_HC_NOTIFICACAO_PRIORIDADE_CK CHECK (prioridade IN ('BAIXA', 'NORMAL', 'ALTA', 'URGENTE')) 
);

-- ==========================================
-- Histórico de comparecimento dos pacientes
-- ==========================================
CREATE TABLE T_HC_HISTORICO_COMPARECIMENTO (
    id_historico NUMBER(10) GENERATED AS IDENTITY,
    id_paciente NUMBER(10) NOT NULL,
    id_agendamento NUMBER(10) NOT NULL,
    data_comparecimento DATE,
    compareceu CHAR(1) DEFAULT 'N' NOT NULL,
    motivo_falta VARCHAR2(500),
    justificativa_aceita CHAR(1) DEFAULT 'N',
    CONSTRAINT T_HC_HISTORICO_PK PRIMARY KEY (id_historico), 
    CONSTRAINT T_HC_HISTORICO_PACIENTE_FK FOREIGN KEY (id_paciente) REFERENCES T_HC_PACIENTE(id_paciente), 
    CONSTRAINT T_HC_HISTORICO_AGENDAMENTO_FK FOREIGN KEY (id_agendamento) REFERENCES T_HC_AGENDAMENTO(id_agendamento), 
    CONSTRAINT T_HC_HISTORICO_COMPARECEU_CK CHECK (compareceu IN ('S', 'N')), 
    CONSTRAINT T_HC_HISTORICO_JUSTIFICATIVA_CK CHECK (justificativa_aceita IN ('S', 'N'))
);

-- =====================================
-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS
-- =====================================
CREATE INDEX T_HC_PROF_SAUDE_ESPEC_IDX ON T_HC_PROFISSIONAL_SAUDE(especialidade);
CREATE INDEX T_HC_AGENDAMENTO_DATA_IDX ON T_HC_AGENDAMENTO(data_agendamento);
CREATE INDEX T_HC_AGENDAMENTO_STATUS_IDX ON T_HC_AGENDAMENTO(status);
CREATE INDEX T_HC_NOTIFICACAO_LIDA_IDX ON T_HC_NOTIFICACAO(lida);

-- =======================
-- COMENTÁRIOS NAS TABELAS
-- =======================
COMMENT ON TABLE T_HC_USUARIO IS 'Tabela base de usuários do sistema';
COMMENT ON TABLE T_HC_PACIENTE IS 'Informações específicas dos pacientes';
COMMENT ON TABLE T_HC_PROFISSIONAL_SAUDE IS 'Informações dos profissionais de saúde';
COMMENT ON TABLE T_HC_AGENDAMENTO IS 'Agendamentos de consultas e procedimentos';
COMMENT ON TABLE T_HC_CONSULTA IS 'Registro das consultas realizadas';
COMMENT ON TABLE T_HC_NOTIFICACAO IS 'Notificações enviadas aos usuários';
COMMENT ON TABLE T_HC_HISTORICO_COMPARECIMENTO IS 'Histórico de comparecimento dos pacientes';

