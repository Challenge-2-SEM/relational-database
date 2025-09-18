
CREATE TABLE Clientes (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100)
);
INSERT INTO Clientes (ID, Nome, Email) VALUES (1, 'Henrique Henrique', 'henrique.henrique@example.com');
SELECT COUNT(*)
FROM Clientes
WHERE ID = 1;
SELECT *
FROM Clientes
WHERE ID = 1;
--------------------------------
CREATE TABLE Profissionais_Saude (
    id_profissional INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_profissional ENUM('Médico', 'Enfermeiro', 'Psicólogo', 'Fisioterapeuta', 'Dentista', 'Outros') NOT NULL,
    especialidade VARCHAR(100),
    crm_ou_registro VARCHAR(50) UNIQUE,  
    data_nascimento DATE,
    sexo ENUM('M', 'F', 'Outro'),
    telefone VARCHAR(15),
    email VARCHAR(100),
    endereco TEXT,
    data_ingresso DATE,  
    tipo_contrato ENUM('CLT', 'PJ', 'Autônomo', 'Estágio'),
    horario_trabalho VARCHAR(100),  
    ativo BOOLEAN DEFAULT TRUE,  
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
---------------------------------------------------------------------------
CREATE TABLE NotificacaoConsulta (
    ID INT PRIMARY KEY IDENTITY(1,1),
    TipoNotificacao VARCHAR(50),
    Mensagem NVARCHAR(MAX),
    DataCriacao DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Pendente',
    IDConsulta INT
);
-----------------------------------------------------------------------------------
CREATE TABLE ConfirmacaoPresenca (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_pessoa VARCHAR(100) NOT NULL,
    data_evento DATE,
    confirmada BOOLEAN DEFAULT FALSE
INSERT INTO ConfirmacaoPresenca (nome_pessoa, data_evento)
VALUES ('Nome do Convidado', '2025-12-31');
UPDATE ConfirmacaoPresenca
SET confirmada = TRUE
WHERE id = 1; 
SELECT nome_pessoa, data_evento
FROM ConfirmacaoPresenca
WHERE confirmada = TRUE;
);
--------------------------------------------------------------------------------
CREATE TABLE consulta AS
SELECT coluna1, coluna2
FROM tabela_original
WHERE alguma_condicao;
---------------------------------------------------------------------------------
CREATE TABLE Agendamentos (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT, 
    id_cliente INT,                               
    id_funcionario INT,                           
    data_hora_agendamento DATETIME NOT NULL,      
    status VARCHAR(50) NOT NULL,                   
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente), 
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario) 
);
-------------------------------------------------------------------------------
CREATE TABLE HistoricoComparecimento (
    id_registro INT PRIMARY KEY AUTO_INCREMENT, 
    id_paciente INT,                         
    data_comparecimento DATETIME,            
    id_consulta INT,                         
    observacoes VARCHAR(255) NULL            
);
--------------------------------------------------------------------------------
CREATE TABLE pacientes (
    paciente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20)
);
--------------------------------------------------------------------------------
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,  
    nome VARCHAR(200) NOT NULL,        
    email VARCHAR(200) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,       
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP 
);
-------------------------------------------------------------------------------




