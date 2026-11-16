/*
Grupo 3: Engenharia de Software 

Turma: C.  Periodo: 2º Sem. Turno: Noturno. 

Caio Fernando Silva: 11261101927; 

Christian Matheus Costa Alves: 11261102933; 

João Pedro Alves Pereira: 11261102895; 

Leonardo Bertaglia dos Santos: 11261102301; 

Leonardo Viana de Oliveira: 11261102539; 

Ricardo Câmara Costa Neto: 11261102104; 

Rafael da Silva Neves: 11262501496. 
*/

CREATE DATABASE mapa_carreiras;

USE mapa_carreiras;

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(300) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(200) NOT NULL,
    cpf DECIMAL(11) NOT NULL UNIQUE,
    dt_nasc DATE,
    endereco VARCHAR(300),
    telefone VARCHAR(20),
    dt_cadastro DATE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE administrador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    privilegio INT CHECK (privilegio IN (1, 2, 3)),
    id_usuario INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_administrador_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_administrador_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE aluno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_aluno_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_aluno_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE professor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(10) CHECK (status IN ('pendente', 'aprovado', 'reprovado')),
    id_usuario INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_professor_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_professor_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE especializacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE formacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dt_form DATE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    carga_horaria INT,
    area VARCHAR(150),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE sala_de_aula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    conteudo TEXT,
    id_curso INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_sala_de_aula_curso FOREIGN KEY (id_curso) REFERENCES curso(id)
);

CREATE TABLE atividade (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    dt_inicio DATETIME,
    dt_fim DATETIME,
    nota DECIMAL(5,2),
    nota_maxima DECIMAL(5,2),
    id_sala_de_aula INT NOT NULL,
    id_aluno INT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_atividade_sala_de_aula FOREIGN KEY (id_sala_de_aula) REFERENCES sala_de_aula(id),
    CONSTRAINT fk_atividade_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id)
);

CREATE TABLE certificado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    dt_emissao DATE,
    carga_horaria INT,
    id_aluno INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_certificado_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id)
);

CREATE TABLE publicacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    conteudo TEXT NOT NULL,
    dt_publicacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_publicacao_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE mensagem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    texto TEXT NOT NULL,
    dt_hora_envio DATETIME,
    id_usuario_remetente INT NOT NULL,
    id_usuario_destinatario INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_mensagem_remetente FOREIGN KEY (id_usuario_remetente) REFERENCES usuario(id),
    CONSTRAINT fk_mensagem_destinatario FOREIGN KEY (id_usuario_destinatario) REFERENCES usuario(id)
);

CREATE TABLE vaga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    requisitos TEXT,
    status VARCHAR(50),
    dt_emissao DATE,
    dt_publicacao DATETIME,
    id_professor INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_vaga_professor FOREIGN KEY (id_professor) REFERENCES professor(id)
);

CREATE TABLE jogo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100),
    pontuacao_maxima INT,
    id_curso INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_jogo_curso FOREIGN KEY (id_curso) REFERENCES curso(id)
);

CREATE TABLE prof_espec (
    id_professor INT NOT NULL,
    id_especializacao INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_professor, id_especializacao),
    CONSTRAINT fk_prof_espec_professor FOREIGN KEY (id_professor) REFERENCES professor(id),
    CONSTRAINT fk_prof_espec_especializacao FOREIGN KEY (id_especializacao) REFERENCES especializacao(id)
);

CREATE TABLE professor_formacao (
    id_professor INT NOT NULL,
    id_formacao INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_professor, id_formacao),
    CONSTRAINT fk_professor_formacao_professor FOREIGN KEY (id_professor) REFERENCES professor(id),
    CONSTRAINT fk_professor_formacao_formacao FOREIGN KEY (id_formacao) REFERENCES formacao(id)
);

CREATE TABLE curso_professor (
    id_professor INT NOT NULL,
    id_curso INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_professor, id_curso),
    CONSTRAINT fk_curso_professor_professor FOREIGN KEY (id_professor) REFERENCES professor(id),
    CONSTRAINT fk_curso_professor_curso FOREIGN KEY (id_curso) REFERENCES curso(id)
);

CREATE TABLE aluno_vaga (
    id_aluno INT NOT NULL,
    id_vaga INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_aluno, id_vaga),
    CONSTRAINT fk_aluno_vaga_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id),
    CONSTRAINT fk_aluno_vaga_vaga FOREIGN KEY (id_vaga) REFERENCES vaga(id)
);

CREATE TABLE aluno_jogo (
    id_aluno INT NOT NULL,
    id_jogo INT NOT NULL,
    pontuacao INT DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_aluno, id_jogo),
    CONSTRAINT fk_aluno_jogo_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id),
    CONSTRAINT fk_aluno_jogo_jogo FOREIGN KEY (id_jogo) REFERENCES jogo(id)
);

CREATE TABLE aluno_sala (
    id_aluno INT NOT NULL,
    id_sala_de_aula INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_aluno, id_sala_de_aula),
    CONSTRAINT fk_aluno_sala_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id),
    CONSTRAINT fk_aluno_sala_sala_de_aula FOREIGN KEY (id_sala_de_aula) REFERENCES sala_de_aula(id)
);

CREATE TABLE publi_comenta (
    id_usuario INT NOT NULL,
    id_publicacao INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_usuario, id_publicacao),
    CONSTRAINT fk_publi_comenta_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    CONSTRAINT fk_publi_comenta_publicacao FOREIGN KEY (id_publicacao) REFERENCES publicacao(id)
);


/* =====================================================================
   INSERTS

   Padrão das notas de aula (seção 8.7 - Insert com Query):
   as chaves estrangeiras são preenchidas com uma subconsulta dentro do
   VALUES, buscando o id pelo dado legível (email, título, nome...).
   Rode uma única vez, com as tabelas vazias.
   ===================================================================== */

START TRANSACTION;

-- ---------------------------------------------------------------------
-- 1) Tabelas sem chave estrangeira
-- ---------------------------------------------------------------------

INSERT INTO usuario (nome, email, senha, cpf, dt_nasc, endereco, telefone, dt_cadastro) VALUES
('Ana Beatriz Souza',         'ana.souza@exemplo.com',             'senha123', '01234567890', '2002-03-14', 'Rua das Acácias, 120 - São Paulo/SP',          '(11) 91234-5601', '2026-02-02'),
('Lucas Henrique Oliveira',   'lucas.oliveira@exemplo.com',        'senha123', '23456789012', '2001-07-22', 'Av. Brasil, 450 - Campinas/SP',                '(19) 98123-4502', '2026-02-02'),
('Mariana Costa Pereira',     'mariana.pereira@exemplo.com',       'senha123', '34567890123', '2003-11-05', 'Rua Sete de Setembro, 88 - Santos/SP',         '(13) 99876-5403', '2026-02-03'),
('Gabriel Santos Almeida',    'gabriel.almeida@exemplo.com',       'senha123', '45678901234', '2000-01-30', 'Rua XV de Novembro, 301 - Curitiba/PR',        '(41) 99765-4304', '2026-02-05'),
('Isabela Rodrigues Martins', 'isabela.martins@exemplo.com',       'senha123', '56789012345', '2004-05-18', 'Av. Paulista, 1500 - São Paulo/SP',            '(11) 97654-3205', '2026-02-05'),
('Pedro Augusto Barbosa',     'pedro.barbosa@exemplo.com',         'senha123', '67890123456', '1999-09-09', 'Rua Minas Gerais, 77 - Belo Horizonte/MG',     '(31) 98543-2106', '2026-02-09'),
('Larissa Fernandes Nunes',   'larissa.nunes@exemplo.com',         'senha123', '78901234567', '2002-12-01', 'Rua do Comércio, 19 - Recife/PE',              '(81) 99432-1007', '2026-02-10'),
('Rafael Carvalho Ribeiro',   'rafael.ribeiro@exemplo.com',        'senha123', '89012345678', '2001-04-27', 'Rua das Palmeiras, 640 - Sorocaba/SP',         '(15) 98321-0908', '2026-02-12'),
('Camila Araújo Dias',        'camila.dias@exemplo.com',           'senha123', '90123456789', '2005-08-16', 'Av. Atlântica, 210 - Rio de Janeiro/RJ',       '(21) 97210-9809', '2026-02-16'),
('Thiago Moreira Cardoso',    'thiago.cardoso@exemplo.com',        'senha123', '02345678901', '2000-10-03', 'Rua Goiás, 55 - Goiânia/GO',                   '(62) 99109-8710', '2026-02-16'),
('Marcos Vinícius Ferreira',  'marcos.ferreira@prof.exemplo.com',  'senha123', '13579246801', '1982-06-12', 'Rua Augusta, 900 - São Paulo/SP',              '(11) 95555-1101', '2025-11-10'),
('Fernanda Lima Rocha',       'fernanda.rocha@prof.exemplo.com',   'senha123', '24680135792', '1985-02-25', 'Rua Bahia, 340 - Salvador/BA',                 '(71) 95555-1202', '2025-11-10'),
('Patrícia Gomes Duarte',     'patricia.duarte@prof.exemplo.com',  'senha123', '35791368024', '1988-09-14', 'Rua das Laranjeiras, 15 - Florianópolis/SC',   '(48) 95555-1303', '2025-11-12'),
('Ricardo Alves Teixeira',    'ricardo.teixeira@prof.exemplo.com', 'senha123', '46802479135', '1979-12-03', 'Av. Independência, 720 - Porto Alegre/RS',     '(51) 95555-1404', '2025-11-12'),
('Juliana Castro Mendes',     'juliana.mendes@prof.exemplo.com',   'senha123', '57913580246', '1990-04-08', 'Rua Pernambuco, 98 - Fortaleza/CE',            '(85) 95555-1505', '2026-10-15'),
('Beatriz Monteiro Lopes',    'beatriz.lopes@admin.exemplo.com',   'senha123', '68024691357', '1984-07-19', 'Rua da Consolação, 2000 - São Paulo/SP',       '(11) 94444-1606', '2025-10-01'),
('Eduardo Pinheiro Silva',    'eduardo.silva@admin.exemplo.com',   'senha123', '79135702468', '1987-03-23', 'Av. Rio Branco, 500 - Rio de Janeiro/RJ',      '(21) 94444-1707', '2025-10-01'),
('Jéssica Lima Silveira',     'jessica.silveira@exemplo.com',      'senha123', '98765432109', '2004-02-11', 'Rua das Flores, 300 - Campinas/SP',            '(19) 97788-9900', '2026-03-01'),
('Lucas Gabriel Martins',     'lucas.martins@exemplo.com',         'senha123', '12345678901', '2003-07-15', 'Av. Paulista, 1000 - São Paulo/SP',            '(11) 98877-6655', '2026-03-02'),
('Beatriz Souza Costa',       'beatriz.costa@exemplo.com',         'senha123', '32165498702', '2001-11-20', 'Rua da Bahia, 500 - Belo Horizonte/MG',        '(31) 97766-5544', '2026-03-02');

INSERT INTO especializacao (nome) VALUES
('Desenvolvimento de Software'),
('Banco de Dados e Análise de Dados'),
('Design e Experiência do Usuário'),
('Gestão de Carreira e Comunicação');

INSERT INTO formacao (dt_form) VALUES
('2008-12-15'),
('2012-07-10'),
('2015-12-18'),
('2010-06-25'),
('2018-07-20'),
('2020-12-10');

INSERT INTO curso (titulo, descricao, carga_horaria, area) VALUES
('Introdução à Programação com Java', 'Lógica de programação, sintaxe do Java e orientação a objetos.', 60, 'Tecnologia'),
('Banco de Dados com PostgreSQL', 'Modelagem relacional, SQL e boas práticas com PostgreSQL.', 40, 'Tecnologia'),
('Desenvolvimento Web com Node.js', 'Criação de APIs REST com Node.js, Express e TypeScript.', 80, 'Tecnologia'),
('Design de Interfaces e UX', 'Princípios de usabilidade, pesquisa com usuários e prototipação.', 40, 'Design'),
('Gestão de Projetos Ágeis', 'Scrum, Kanban e rituais ágeis aplicados a equipes pequenas.', 30, 'Gestão'),
('Marketing Digital', 'Conteúdo, redes sociais, SEO e análise de métricas.', 45, 'Marketing'),
('Inglês para Entrevistas e Carreira', 'Vocabulário, simulações de entrevista e escrita de e-mails profissionais.', 50, 'Idiomas'),
('Análise de Dados com Python', 'Limpeza, exploração e visualização de dados com Pandas.', 60, 'Dados');

-- ---------------------------------------------------------------------
-- 2) Tipos de usuário (administrador, aluno, professor)
-- ---------------------------------------------------------------------

INSERT INTO administrador (privilegio, id_usuario) VALUES
(3, (SELECT id FROM usuario WHERE email = 'beatriz.lopes@admin.exemplo.com')),
(2, (SELECT id FROM usuario WHERE email = 'eduardo.silva@admin.exemplo.com'));

INSERT INTO aluno (id_usuario) VALUES
((SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'mariana.pereira@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'gabriel.almeida@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'isabela.martins@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'pedro.barbosa@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'larissa.nunes@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'rafael.ribeiro@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'camila.dias@exemplo.com')),
((SELECT id FROM usuario WHERE email = 'thiago.cardoso@exemplo.com'));

INSERT INTO professor (status, id_usuario) VALUES
('aprovado', (SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com')),
('aprovado', (SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com')),
('aprovado', (SELECT id FROM usuario WHERE email = 'patricia.duarte@prof.exemplo.com')),
('aprovado', (SELECT id FROM usuario WHERE email = 'ricardo.teixeira@prof.exemplo.com')),
('pendente', (SELECT id FROM usuario WHERE email = 'juliana.mendes@prof.exemplo.com'));

-- ---------------------------------------------------------------------
-- 3) Tabelas que dependem de curso
-- ---------------------------------------------------------------------

INSERT INTO sala_de_aula (titulo, conteudo, id_curso) VALUES
('Fundamentos de Java', 'Variáveis, tipos, condicionais e laços de repetição.', (SELECT id FROM curso WHERE titulo = 'Introdução à Programação com Java')),
('Orientação a Objetos em Java', 'Classes, objetos, herança, polimorfismo e interfaces.', (SELECT id FROM curso WHERE titulo = 'Introdução à Programação com Java')),
('Modelagem e SQL Básico', 'MER, modelo relacional, CREATE TABLE, INSERT e SELECT.', (SELECT id FROM curso WHERE titulo = 'Banco de Dados com PostgreSQL')),
('Consultas Avançadas no PostgreSQL', 'JOINs, subconsultas, agregações e views.', (SELECT id FROM curso WHERE titulo = 'Banco de Dados com PostgreSQL')),
('APIs REST com Node.js e Express', 'Rotas, middlewares, controllers e persistência de dados.', (SELECT id FROM curso WHERE titulo = 'Desenvolvimento Web com Node.js')),
('TypeScript no Back-end', 'Tipagem estática, interfaces e organização de projetos.', (SELECT id FROM curso WHERE titulo = 'Desenvolvimento Web com Node.js')),
('Princípios de UX', 'Heurísticas de usabilidade e jornada do usuário.', (SELECT id FROM curso WHERE titulo = 'Design de Interfaces e UX')),
('Prototipação no Figma', 'Wireframes, componentes e protótipos navegáveis.', (SELECT id FROM curso WHERE titulo = 'Design de Interfaces e UX')),
('Scrum na Prática', 'Papéis, eventos e artefatos do Scrum.', (SELECT id FROM curso WHERE titulo = 'Gestão de Projetos Ágeis')),
('Marketing de Conteúdo e Redes Sociais', 'Planejamento editorial e métricas de engajamento.', (SELECT id FROM curso WHERE titulo = 'Marketing Digital')),
('Inglês para Entrevistas de Emprego', 'Perguntas comuns, respostas modelo e simulações.', (SELECT id FROM curso WHERE titulo = 'Inglês para Entrevistas e Carreira')),
('Análise Exploratória com Pandas', 'Leitura de dados, limpeza e estatísticas descritivas.', (SELECT id FROM curso WHERE titulo = 'Análise de Dados com Python'));

INSERT INTO jogo (nome, descricao, categoria, pontuacao_maxima, id_curso) VALUES
('Java Challenge', 'Quiz com perguntas de lógica e sintaxe em Java.', 'Quiz', 100, (SELECT id FROM curso WHERE titulo = 'Introdução à Programação com Java')),
('SQL Detective', 'Resolva casos escrevendo consultas SQL para achar pistas.', 'Puzzle', 150, (SELECT id FROM curso WHERE titulo = 'Banco de Dados com PostgreSQL')),
('API Builder Race', 'Monte rotas de uma API o mais rápido possível.', 'Desafio de código', 200, (SELECT id FROM curso WHERE titulo = 'Desenvolvimento Web com Node.js')),
('UX Match', 'Jogo da memória com conceitos e heurísticas de UX.', 'Memória', 80, (SELECT id FROM curso WHERE titulo = 'Design de Interfaces e UX')),
('Scrum Simulator', 'Simule uma Sprint tomando decisões como Scrum Master.', 'Simulação', 120, (SELECT id FROM curso WHERE titulo = 'Gestão de Projetos Ágeis')),
('Interview Ninja', 'Responda perguntas de entrevista em inglês contra o tempo.', 'Simulação', 100, (SELECT id FROM curso WHERE titulo = 'Inglês para Entrevistas e Carreira'));

-- ---------------------------------------------------------------------
-- 4) Atividade, certificado, publicação, mensagem e vaga
-- ---------------------------------------------------------------------

INSERT INTO atividade (titulo, descricao, dt_inicio, dt_fim, nota, nota_maxima, id_sala_de_aula, id_aluno) VALUES
('Exercício: Hello World e variáveis', 'Criar programas simples usando variáveis e entrada de dados.', '2026-03-02 08:00:00', '2026-03-09 23:59:00', 9.50, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Fundamentos de Java'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com')),
('Lista de exercícios sobre laços', 'Resolver 10 problemas usando for e while.', '2026-03-10 08:00:00', '2026-03-17 23:59:00', 8.00, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Fundamentos de Java'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com')),
('Projeto: Sistema de Biblioteca', 'Implementar um cadastro de livros usando orientação a objetos.', '2026-04-06 08:00:00', '2026-04-27 23:59:00', 17.50, 20.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Orientação a Objetos em Java'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com')),
('Modelagem do banco de uma loja', 'Criar o MER e o MR de uma loja virtual.', '2026-05-04 08:00:00', '2026-05-18 23:59:00', 18.00, 20.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Modelagem e SQL Básico'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com')),
('Lista de consultas com JOIN', 'Escrever consultas com INNER JOIN e LEFT JOIN.', '2026-06-01 08:00:00', '2026-06-08 23:59:00', 9.00, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Consultas Avançadas no PostgreSQL'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com')),
('Criação de API de tarefas', 'Construir uma API REST de lista de tarefas com Express.', '2026-08-03 08:00:00', '2026-08-24 23:59:00', 27.00, 30.00, (SELECT id FROM sala_de_aula WHERE titulo = 'APIs REST com Node.js e Express'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com')),
('Migração de JavaScript para TypeScript', 'Converter um projeto existente adicionando tipagem.', '2026-08-31 08:00:00', '2026-09-07 23:59:00', 24.50, 30.00, (SELECT id FROM sala_de_aula WHERE titulo = 'TypeScript no Back-end'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com')),
('Análise heurística de um aplicativo', 'Avaliar um app usando as 10 heurísticas de Nielsen.', '2026-07-06 08:00:00', '2026-07-13 23:59:00', 8.50, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Princípios de UX'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com')),
('Protótipo de tela de login', 'Criar um protótipo navegável de uma tela de login no Figma.', '2026-07-20 08:00:00', '2026-07-27 23:59:00', 9.00, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Prototipação no Figma'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com')),
('Planejamento de uma Sprint', 'Montar o backlog e o planejamento de uma Sprint de 2 semanas.', '2026-09-14 08:00:00', '2026-09-21 23:59:00', 7.50, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Scrum na Prática'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'pedro.barbosa@exemplo.com')),
('Calendário de conteúdo mensal', 'Planejar 30 dias de postagens para uma marca fictícia.', '2026-09-07 08:00:00', '2026-09-14 23:59:00', 9.00, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Marketing de Conteúdo e Redes Sociais'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com')),
('Simulação de entrevista em inglês', 'Gravar uma entrevista simulada respondendo 5 perguntas.', '2026-10-05 08:00:00', '2026-10-12 23:59:00', 8.00, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Inglês para Entrevistas de Emprego'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com')),
('Limpeza de dataset com Pandas', 'Tratar valores nulos e duplicados em um conjunto de dados real.', '2026-10-26 08:00:00', '2026-11-09 23:59:00', NULL, 20.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Análise Exploratória com Pandas'), (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com')),
('Quiz de revisão de Java', 'Questionário de revisão para a turma.', '2026-11-02 08:00:00', '2026-11-09 23:59:00', NULL, 10.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Fundamentos de Java'), NULL),
('Desafio de modelagem DER', 'Modelar o banco de uma clínica veterinária.', '2026-11-09 08:00:00', '2026-11-23 23:59:00', NULL, 20.00, (SELECT id FROM sala_de_aula WHERE titulo = 'Modelagem e SQL Básico'), NULL);

INSERT INTO certificado (titulo, dt_emissao, carga_horaria, id_aluno) VALUES
('Introdução à Programação com Java', '2026-06-20', 60, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com')),
('Banco de Dados com PostgreSQL', '2026-08-15', 40, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com')),
('Workshop de Currículo e LinkedIn', '2026-05-18', 8, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com')),
('Introdução à Programação com Java', '2026-06-20', 60, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com')),
('Desenvolvimento Web com Node.js', '2026-09-10', 80, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com')),
('Gestão de Projetos Ágeis', '2026-07-05', 30, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com')),
('Workshop de Currículo e LinkedIn', '2026-05-18', 8, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com')),
('Banco de Dados com PostgreSQL', '2026-08-15', 40, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com')),
('Gestão de Projetos Ágeis', '2026-07-05', 30, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com')),
('Workshop de Currículo e LinkedIn', '2026-05-18', 8, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com')),
('Desenvolvimento Web com Node.js', '2026-09-10', 80, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com')),
('Design de Interfaces e UX', '2026-08-28', 40, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com')),
('Marketing Digital', '2026-09-20', 45, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com')),
('Workshop de Currículo e LinkedIn', '2026-05-18', 8, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com')),
('Gestão de Projetos Ágeis', '2026-07-05', 30, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com')),
('Inglês para Entrevistas e Carreira', '2026-10-20', 50, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com')),
('Desenvolvimento Web com Node.js', '2026-09-10', 80, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com')),
('Marketing Digital', '2026-09-20', 45, (SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'));

INSERT INTO publicacao (titulo, conteudo, dt_publicacao, id_usuario) VALUES
('Dicas para começar em Java', 'Comece pelos fundamentos: variáveis, laços e orientação a objetos. Pratique todos os dias, mesmo que seja por 30 minutos.', '2026-03-05 10:15:00', (SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com')),
('Por que aprender PostgreSQL?', 'O PostgreSQL é gratuito, robusto e muito usado no mercado. Dominar SQL abre portas em quase qualquer área de tecnologia.', '2026-03-12 09:40:00', (SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com')),
('Meu primeiro projeto em Java', 'Finalizei meu sistema de biblioteca! Foi desafiador entender herança, mas valeu muito a pena.', '2026-04-20 19:05:00', (SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com')),
('UX e carreira: por onde começar', 'Estude usabilidade, monte um portfólio com 3 estudos de caso e peça feedback de outras pessoas da área.', '2026-05-08 11:20:00', (SELECT id FROM usuario WHERE email = 'patricia.duarte@prof.exemplo.com')),
('Como montar um currículo que chama atenção', 'Seja objetivo, destaque projetos e resultados e adapte o currículo para cada vaga.', '2026-05-15 08:30:00', (SELECT id FROM usuario WHERE email = 'ricardo.teixeira@prof.exemplo.com')),
('O que aprendi no curso de UX', 'Aprendi que o usuário nunca é igual a nós. Testar com pessoas reais mudou completamente meu protótipo.', '2026-08-30 20:10:00', (SELECT id FROM usuario WHERE email = 'isabela.martins@exemplo.com')),
('Novidades da plataforma Mapa Carreiras', 'Chegaram os jogos educativos e a nova área de vagas de estágio. Explore e conte para a gente o que achou!', '2026-09-01 09:00:00', (SELECT id FROM usuario WHERE email = 'beatriz.lopes@admin.exemplo.com')),
('Procuro grupo de estudo de Node.js', 'Alguém quer montar um grupo para estudar APIs REST aos fins de semana?', '2026-09-14 21:45:00', (SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com')),
('Preparação para entrevistas em inglês', 'Treine as respostas em voz alta e grave a si mesmo. Perceber os próprios erros acelera muito o aprendizado.', '2026-10-20 15:00:00', (SELECT id FROM usuario WHERE email = 'juliana.mendes@prof.exemplo.com')),
('Vagas de estágio: o que as empresas esperam', 'Além da parte técnica, as empresas valorizam comunicação, vontade de aprender e trabalho em equipe.', '2026-10-22 10:00:00', (SELECT id FROM usuario WHERE email = 'ricardo.teixeira@prof.exemplo.com')),
('Dúvida sobre JOIN no PostgreSQL', 'Alguém consegue explicar a diferença entre INNER JOIN e LEFT JOIN com um exemplo simples?', '2026-10-23 18:25:00', (SELECT id FROM usuario WHERE email = 'rafael.ribeiro@exemplo.com')),
('Manutenção programada', 'A plataforma ficará indisponível no sábado, das 02h às 04h, para manutenção.', '2026-10-25 08:00:00', (SELECT id FROM usuario WHERE email = 'eduardo.silva@admin.exemplo.com')),
('Dica de Ouro para Portfólio', 'Suba seus códigos para o GitHub com um README bem documentado, pois isso ajuda muito os recrutadores de TI experientes e exigentes.', '2026-10-27 14:00:00', (SELECT id FROM usuario WHERE email = 'beatriz.lopes@admin.exemplo.com')),
('Dica de Lógica de Programação', 'Resolva pequenos desafios em plataformas como LeetCode ou HackerRank diariamente para ganhar bastante agilidade mental na programação moderna.', '2026-10-27 15:30:00', (SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com')),
('Oportunidade de Networking', 'Participe de meetups e comunidades de tecnologia para ser lembrado pelo mercado e criar boas conexões profissionais valiosas hoje.', '2026-10-27 16:00:00', (SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com'));

INSERT INTO mensagem (texto, dt_hora_envio, id_usuario_remetente, id_usuario_destinatario) VALUES
('Professor, posso entregar o projeto final com um dia de atraso?', '2026-09-12 14:32:00', (SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com'), (SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com')),
('Pode sim, Ana. Só me avise até amanhã cedo.', '2026-09-12 16:10:00', (SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com')),
('Professora, o material de consultas com JOIN já está disponível?', '2026-09-15 09:05:00', (SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com')),
('Já está na sala, Lucas. Qualquer dúvida é só chamar.', '2026-09-15 11:47:00', (SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com')),
('Ana, você tem as anotações da aula de SQL?', '2026-09-18 20:15:00', (SELECT id FROM usuario WHERE email = 'mariana.pereira@exemplo.com'), (SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com')),
('Tenho sim, te mando hoje à noite.', '2026-09-18 20:40:00', (SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com'), (SELECT id FROM usuario WHERE email = 'mariana.pereira@exemplo.com')),
('Isabela, seu portfólio ficou ótimo. Vale se candidatar à vaga de marketing.', '2026-09-22 13:00:00', (SELECT id FROM usuario WHERE email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM usuario WHERE email = 'isabela.martins@exemplo.com')),
('Obrigada, professor! Já enviei minha candidatura.', '2026-09-22 13:25:00', (SELECT id FROM usuario WHERE email = 'isabela.martins@exemplo.com'), (SELECT id FROM usuario WHERE email = 'ricardo.teixeira@prof.exemplo.com')),
('Olá, Juliana! Seu cadastro de professora está em análise.', '2026-10-16 10:00:00', (SELECT id FROM usuario WHERE email = 'beatriz.lopes@admin.exemplo.com'), (SELECT id FROM usuario WHERE email = 'juliana.mendes@prof.exemplo.com')),
('Obrigada! Já enviei os documentos solicitados.', '2026-10-16 10:30:00', (SELECT id FROM usuario WHERE email = 'juliana.mendes@prof.exemplo.com'), (SELECT id FROM usuario WHERE email = 'beatriz.lopes@admin.exemplo.com')),
('Gabriel, bora estudar para a prova de APIs amanhã?', '2026-10-20 19:50:00', (SELECT id FROM usuario WHERE email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM usuario WHERE email = 'gabriel.almeida@exemplo.com')),
('Bora! Que tal às 19h?', '2026-10-20 20:05:00', (SELECT id FROM usuario WHERE email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM usuario WHERE email = 'rafael.ribeiro@exemplo.com')),
('Camila, sua prototipação ficou muito boa.', '2026-10-21 15:30:00', (SELECT id FROM usuario WHERE email = 'patricia.duarte@prof.exemplo.com'), (SELECT id FROM usuario WHERE email = 'camila.dias@exemplo.com')),
('Professora, posso revisar a atividade de JOIN?', '2026-10-24 17:10:00', (SELECT id FROM usuario WHERE email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com'));

INSERT INTO vaga (titulo, descricao, requisitos, status, dt_emissao, dt_publicacao, id_professor) VALUES
('Estagiário(a) de Desenvolvimento Java', 'Desenvolvimento e manutenção de sistemas web em Java.', 'Java básico, SQL, Git, cursando Computação ou áreas afins.', 'aberta', '2026-09-01', '2026-09-02 09:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com')),
('Estagiário(a) de Dados e BI', 'Apoio na criação de dashboards e análises de dados.', 'SQL, Excel e noções de Python.', 'aberta', '2026-09-10', '2026-09-11 10:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com')),
('Estágio em UX/UI Design', 'Apoio no desenho e teste de interfaces.', 'Figma, noções de usabilidade e portfólio.', 'encerrada', '2026-07-15', '2026-07-16 08:30:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'patricia.duarte@prof.exemplo.com')),
('Assistente de Marketing Digital', 'Criação de conteúdo e acompanhamento de métricas.', 'Redes sociais, redação e noções de SEO.', 'aberta', '2026-09-05', '2026-09-06 14:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com')),
('Desenvolvedor(a) Node.js Júnior', 'Desenvolvimento de APIs REST com Node.js e PostgreSQL.', 'Node.js, TypeScript, Express, SQL e Git.', 'aberta', '2026-10-01', '2026-10-02 09:30:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com')),
('Analista de Dados Júnior', 'Limpeza e análise de dados com Python e SQL.', 'Python, Pandas, SQL e estatística básica.', 'em análise', '2026-10-12', '2026-10-13 11:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com')),
('Trainee em Gestão de Projetos', 'Acompanhamento de sprints e rituais ágeis.', 'Scrum, boa comunicação e inglês intermediário.', 'aberta', '2026-10-15', '2026-10-16 08:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com')),
('Estagiário(a) de Suporte e Infraestrutura', 'Atendimento a chamados técnicos e suporte ao usuário.', 'Noções de redes, sistemas, hardware básico e vontade de aprender.', 'aberta', '2026-10-25', '2026-10-26 09:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com')),
('Desenvolvedor(a) Front-End Júnior', 'Desenvolvimento de interfaces responsivas usando HTML, JavaScript, e react.', 'Cursando Superior em TI, conhecimento básico de Git.', 'aberta', '2026-10-26', '2026-10-27 10:00:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com')),
('Analista de Dados Trainee', 'Auxílio na criação de relatórios, dashboards e tratamento de dados com SQL e Python.', 'Familiaridade com bancos de dados relacionais.', 'aberta', '2026-10-26', '2026-10-27 11:30:00', (SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'patricia.duarte@prof.exemplo.com'));

-- ---------------------------------------------------------------------
-- 5) Tabelas associativas (N:N)
-- ---------------------------------------------------------------------

INSERT INTO prof_espec (id_professor, id_especializacao) VALUES
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Desenvolvimento de Software')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Banco de Dados e Análise de Dados')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Desenvolvimento de Software')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Banco de Dados e Análise de Dados')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'patricia.duarte@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Design e Experiência do Usuário')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Gestão de Carreira e Comunicação')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'juliana.mendes@prof.exemplo.com'), (SELECT id FROM especializacao WHERE nome = 'Gestão de Carreira e Comunicação'));

INSERT INTO professor_formacao (id_professor, id_formacao) VALUES
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2008-12-15')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2018-07-20')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2012-07-10')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2020-12-10')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'patricia.duarte@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2015-12-18')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2010-06-25')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2020-12-10')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'juliana.mendes@prof.exemplo.com'), (SELECT id FROM formacao WHERE dt_form = '2018-07-20'));

INSERT INTO curso_professor (id_professor, id_curso) VALUES
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Introdução à Programação com Java')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Desenvolvimento Web com Node.js')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Banco de Dados com PostgreSQL')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Análise de Dados com Python')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'patricia.duarte@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Design de Interfaces e UX')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Gestão de Projetos Ágeis')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Marketing Digital')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Inglês para Entrevistas e Carreira')),
((SELECT p.id FROM professor p JOIN usuario u ON p.id_usuario = u.id WHERE u.email = 'juliana.mendes@prof.exemplo.com'), (SELECT id FROM curso WHERE titulo = 'Inglês para Entrevistas e Carreira'));

INSERT INTO aluno_vaga (id_aluno, id_vaga) VALUES
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Desenvolvedor(a) Node.js Júnior')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Estagiário(a) de Desenvolvimento Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Desenvolvedor(a) Node.js Júnior')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Estagiário(a) de Desenvolvimento Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Analista de Dados Júnior')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Estagiário(a) de Dados e BI')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Desenvolvedor(a) Node.js Júnior')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Estágio em UX/UI Design')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Assistente de Marketing Digital')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Trainee em Gestão de Projetos')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Assistente de Marketing Digital')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Desenvolvedor(a) Node.js Júnior')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Estagiário(a) de Desenvolvimento Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Assistente de Marketing Digital')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM vaga WHERE titulo = 'Estagiário(a) de Dados e BI'));

INSERT INTO aluno_jogo (id_aluno, id_jogo, pontuacao) VALUES
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Java Challenge'), 90),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'SQL Detective'), 120),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Java Challenge'), 85),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'API Builder Race'), 160),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'SQL Detective'), 140),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Java Challenge'), 70),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'API Builder Race'), 180),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'UX Match'), 75),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Scrum Simulator'), 100),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Interview Ninja'), 90),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'API Builder Race'), 150),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'UX Match'), 60),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Scrum Simulator'), 110),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'SQL Detective'), 95);

INSERT INTO aluno_jogo (id_aluno, id_jogo) VALUES
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM jogo WHERE nome = 'Interview Ninja'));

INSERT INTO aluno_sala (id_aluno, id_sala_de_aula) VALUES
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Orientação a Objetos em Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Fundamentos de Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'ana.souza@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Modelagem e SQL Básico')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Orientação a Objetos em Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Fundamentos de Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'APIs REST com Node.js e Express')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Consultas Avançadas no PostgreSQL')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Modelagem e SQL Básico')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'mariana.pereira@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Análise Exploratória com Pandas')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Fundamentos de Java')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'TypeScript no Back-end')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'APIs REST com Node.js e Express')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Prototipação no Figma')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Princípios de UX')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'isabela.martins@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Marketing de Conteúdo e Redes Sociais')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Scrum na Prática')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Marketing de Conteúdo e Redes Sociais')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Inglês para Entrevistas de Emprego')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Princípios de UX')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Inglês para Entrevistas de Emprego')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'larissa.nunes@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Análise Exploratória com Pandas')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Modelagem e SQL Básico')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'TypeScript no Back-end')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'APIs REST com Node.js e Express')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Prototipação no Figma')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Scrum na Prática')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'camila.dias@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Marketing de Conteúdo e Redes Sociais')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Consultas Avançadas no PostgreSQL')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Inglês para Entrevistas de Emprego')),
((SELECT a.id FROM aluno a JOIN usuario u ON a.id_usuario = u.id WHERE u.email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM sala_de_aula WHERE titulo = 'Análise Exploratória com Pandas'));

INSERT INTO publi_comenta (id_usuario, id_publicacao) VALUES
((SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Dicas para começar em Java')),
((SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Vagas de estágio: o que as empresas esperam')),
((SELECT id FROM usuario WHERE email = 'ana.souza@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Como montar um currículo que chama atenção')),
((SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Meu primeiro projeto em Java')),
((SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Novidades da plataforma Mapa Carreiras')),
((SELECT id FROM usuario WHERE email = 'lucas.oliveira@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Dicas para começar em Java')),
((SELECT id FROM usuario WHERE email = 'mariana.pereira@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Manutenção programada')),
((SELECT id FROM usuario WHERE email = 'mariana.pereira@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Por que aprender PostgreSQL?')),
((SELECT id FROM usuario WHERE email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Procuro grupo de estudo de Node.js')),
((SELECT id FROM usuario WHERE email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Dicas para começar em Java')),
((SELECT id FROM usuario WHERE email = 'gabriel.almeida@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Dúvida sobre JOIN no PostgreSQL')),
((SELECT id FROM usuario WHERE email = 'isabela.martins@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'UX e carreira: por onde começar')),
((SELECT id FROM usuario WHERE email = 'isabela.martins@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Como montar um currículo que chama atenção')),
((SELECT id FROM usuario WHERE email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'O que aprendi no curso de UX')),
((SELECT id FROM usuario WHERE email = 'pedro.barbosa@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Preparação para entrevistas em inglês')),
((SELECT id FROM usuario WHERE email = 'larissa.nunes@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Preparação para entrevistas em inglês')),
((SELECT id FROM usuario WHERE email = 'larissa.nunes@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Como montar um currículo que chama atenção')),
((SELECT id FROM usuario WHERE email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Por que aprender PostgreSQL?')),
((SELECT id FROM usuario WHERE email = 'rafael.ribeiro@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Vagas de estágio: o que as empresas esperam')),
((SELECT id FROM usuario WHERE email = 'camila.dias@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'UX e carreira: por onde começar')),
((SELECT id FROM usuario WHERE email = 'thiago.cardoso@exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Por que aprender PostgreSQL?')),
((SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Meu primeiro projeto em Java')),
((SELECT id FROM usuario WHERE email = 'marcos.ferreira@prof.exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Procuro grupo de estudo de Node.js')),
((SELECT id FROM usuario WHERE email = 'fernanda.rocha@prof.exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Dúvida sobre JOIN no PostgreSQL')),
((SELECT id FROM usuario WHERE email = 'patricia.duarte@prof.exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'O que aprendi no curso de UX')),
((SELECT id FROM usuario WHERE email = 'ricardo.teixeira@prof.exemplo.com'), (SELECT id FROM publicacao WHERE titulo = 'Novidades da plataforma Mapa Carreiras'));

COMMIT;


-- ---------------------------------------------------------------------
-- VIEW: relatório gerencial por curso 
-- Caio Fernando Silva: 11261101927
-- ---------------------------------------------------------------------

CREATE VIEW Relatorio_Gerencial_Cursos AS
SELECT c.id AS id_curso,
       c.titulo AS curso,
       c.area AS area,
       c.carga_horaria AS carga_horaria,
       COUNT(DISTINCT s.id) AS total_salas,
       COUNT(DISTINCT ati.id) AS total_atividades,
       ROUND(AVG(ati.nota / ati.nota_maxima * 100), 2) AS media_aproveitamento,
       (SELECT COUNT(*)
        FROM curso_professor cp
        WHERE cp.id_curso = c.id AND cp.ativo = TRUE) AS total_professores,
       (SELECT COUNT(DISTINCT als.id_aluno)
        FROM aluno_sala als
        JOIN sala_de_aula s2 ON als.id_sala_de_aula = s2.id
        WHERE s2.id_curso = c.id AND s2.ativo = TRUE AND als.ativo = TRUE) AS total_alunos_matriculados,
       (SELECT COUNT(*)
        FROM jogo j
        WHERE j.id_curso = c.id AND j.ativo = TRUE) AS total_jogos
FROM curso c
LEFT JOIN sala_de_aula s ON s.id_curso = c.id AND s.ativo = TRUE
LEFT JOIN atividade ati ON ati.id_sala_de_aula = s.id AND ati.ativo = TRUE
WHERE c.ativo = TRUE
GROUP BY c.id, c.titulo, c.area, c.carga_horaria;

SELECT * FROM Relatorio_Gerencial_Cursos;


-- ---------------------------------------------------------------------
-- ÍNDICE: vagas abertas, das mais recentes para as mais antigas 
-- Caio Fernando Silva: 11261101927
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- VIEW: Relatório gerencial de emissão de certificados por aluno
-- Leonardo Viana de Oliveira: 11261102539
-- ---------------------------------------------------------------------
CREATE VIEW Relatorio_Gerencial_Certificados AS
SELECT u.nome AS aluno,
       COUNT(c.id) AS total_certificados,
       SUM(c.carga_horaria) AS total_horas_certificadas,
       MAX(c.dt_emissao) AS ultimo_certificado_emitido
FROM aluno a
JOIN usuario u ON a.id_usuario = u.id
JOIN certificado c ON c.id_aluno = a.id
WHERE a.ativo = TRUE AND c.ativo = TRUE
GROUP BY a.id, u.nome;

-- ÍNDICE: Otimização de busca de certificados e datas
-- Leonardo Viana de Oliveira: 11261102539
CREATE INDEX idx_certificado_aluno_emissao ON certificado(id_aluno, dt_emissao);
