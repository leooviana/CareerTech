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

create database mapa_carreiras; 

use mapa_carreiras;

create table usuario (
    id int auto_increment primary key,
    nome varchar(300) not null,
    email varchar(150) not null unique,
    senha varchar(200) not null,
    cpf decimal(11) not null unique,
    dt_nasc date,
    endereco varchar(300),
    telefone varchar(20),
    dt_cadastro date,
    ativo boolean not null default true
);

create table administrador (
    id int auto_increment primary key,
    privilegio int check (privilegio in (1, 2, 3)),
    id_usuario int not null,
    ativo boolean not null default true,
    constraint uq_administrador_usuario unique (id_usuario),
    constraint fkadm_usuario foreign key (id_usuario) references usuario(id)
);

create table aluno (
    id int auto_increment primary key,
    id_usuario int not null,
    ativo boolean not null default true,
    constraint uq_aluno_usuario unique (id_usuario),
    constraint fkalu_usuario foreign key (id_usuario) references usuario(id)
);

create table professor (
    id int auto_increment primary key,
    status varchar(10) check (status in ('pendente', 'aprovado', 'reprovado')),
    id_usuario int not null,
    ativo boolean not null default true,
    constraint uq_professor_usuario unique (id_usuario),
    constraint fkprof_usuario foreign key (id_usuario) references usuario(id)
);

create table especializacao (
    id int auto_increment primary key,
    nome varchar(150) not null,
    ativo boolean not null default true
);

create table formacao (
    id int auto_increment primary key,
    dt_form date,
    ativo boolean not null default true
);

create table curso (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    descricao text,
    carga_horaria int,
    area varchar(150),
    ativo boolean not null default true
);

create table sala_de_aula (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    conteudo text,
    id_curso int not null,
    ativo boolean not null default true,
    constraint fksaula_curso foreign key (id_curso) references curso(id)
);

create table atividade (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    descricao text,
    dt_inicio datetime,
    dt_fim datetime,
    nota decimal(5,2),
    nota_maxima decimal(5,2),
    id_sala_de_aula int not null,
    id_aluno int,
    ativo boolean not null default true,
    constraint fkati_sala foreign key (id_sala_de_aula) references sala_de_aula(id),
    constraint fkati_aluno foreign key (id_aluno) references aluno(id)
);

create table certificado (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    dt_emissao date,
    carga_horaria int,
    id_aluno int not null,
    ativo boolean not null default true,
    constraint fkcert_aluno foreign key (id_aluno) references aluno(id)
);

create table publicacao (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    conteudo text not null,
    dt_publicacao datetime default current_timestamp,
    id_usuario int not null,
    ativo boolean not null default true,
    constraint fkpubli_usuario foreign key (id_usuario) references usuario(id)
);

create table mensagem (
    id int auto_increment primary key,
    texto text not null,
    dt_hora_envio datetime,
    id_usuario_remetente int not null,
    id_usuario_destinatario int not null,
    ativo boolean not null default true,
    constraint fkmens_remetente foreign key (id_usuario_remetente) references usuario(id),
    constraint fkmens_destin foreign key (id_usuario_destinatario) references usuario(id)
);

create table vaga (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    descricao text,
    requisitos text,
    status varchar(50),
    dt_emissao date,
    dt_publicacao datetime,
    id_professor int not null,
    ativo boolean not null default true,
    constraint fkvaga_prof foreign key (id_professor) references professor(id)
);

create table jogo (
    id int auto_increment primary key,
    nome varchar(150) not null,
    descricao text,
    categoria varchar(100),
    pontuacao_maxima int,
    id_curso int not null,
    ativo boolean not null default true,
    constraint fkjogo_curso foreign key (id_curso) references curso(id)
);

create table prof_espec (
    id_professor int not null,
    id_especializacao int not null,
    ativo boolean not null default true,
    constraint primary key (id_professor, id_especializacao),
    constraint fkprof_espec_prof foreign key (id_professor) references professor(id),
    constraint fkprof_espec_espec foreign key (id_especializacao) references especializacao(id)
);

create table professor_formacao (
    id_professor int not null,
    id_formacao int not null,
    ativo boolean not null default true,
    constraint primary key (id_professor, id_formacao),
    constraint fkprof_form_prof foreign key (id_professor) references professor(id),
    constraint fkprof_form_form foreign key (id_formacao) references formacao(id)
);

create table curso_professor (
    id_professor int not null,
    id_curso int not null,
    ativo boolean not null default true,
    constraint primary key (id_professor, id_curso),
    constraint fkcurso_prof_prof foreign key (id_professor) references professor(id),
    constraint fkcurso_prof_curso foreign key (id_curso) references curso(id)
);

create table aluno_vaga (
    id_aluno int not null,
    id_vaga int not null,
    ativo boolean not null default true,
    constraint primary key (id_aluno, id_vaga),
    constraint fkaluno_vaga_aluno foreign key (id_aluno) references aluno(id),
    constraint fkaluno_vaga_vaga foreign key (id_vaga) references vaga(id)
);

create table aluno_jogo (
    id_aluno int not null,
    id_jogo int not null,
    pontuacao int default 0,
    ativo boolean not null default true,
    constraint primary key (id_aluno, id_jogo),
    constraint fkaluno_jogo_aluno foreign key (id_aluno) references aluno(id),
    constraint fkaluno_jogo_jogo foreign key (id_jogo) references jogo(id)
);

create table aluno_sala (
    id_aluno int not null,
    id_sala_de_aula int not null,
    ativo boolean not null default true,
    constraint primary key (id_aluno, id_sala_de_aula),
    constraint fkaluno_sala_aluno foreign key (id_aluno) references aluno(id),
    constraint fkaluno_sala_sala foreign key (id_sala_de_aula) references sala_de_aula(id)
);

create table publi_comenta (
    id_usuario int not null,
    id_publicacao int not null,
    ativo boolean not null default true,
    constraint primary key (id_usuario, id_publicacao),
    constraint fkpubli_comenta_usuario foreign key (id_usuario) references usuario(id),
    constraint fkpubli_comenta_publi foreign key (id_publicacao) references publicacao(id)
);


-- INSERTS

start transaction;


-- ---------------------------------------------------------------------
-- 1) TABELAS SEM DEPENDÊNCIA (não têm chave estrangeira)
--    Aqui INSERT ... VALUES continua sendo o certo, só tiramos o id.
-- ---------------------------------------------------------------------

insert into usuario (nome, email, senha, cpf, dt_nasc, endereco, telefone, dt_cadastro) values
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

insert into especializacao (nome) values
('Desenvolvimento de Software'),
('Banco de Dados e Análise de Dados'),
('Design e Experiência do Usuário'),
('Gestão de Carreira e Comunicação');

insert into formacao (dt_form) values
('2008-12-15'),
('2012-07-10'),
('2015-12-18'),
('2010-06-25'),
('2018-07-20'),
('2020-12-10');

insert into curso (titulo, descricao, carga_horaria, area) values
('Introdução à Programação com Java',   'Lógica de programação, sintaxe do Java e orientação a objetos.',            60, 'Tecnologia'),
('Banco de Dados com PostgreSQL',       'Modelagem relacional, SQL e boas práticas com PostgreSQL.',                 40, 'Tecnologia'),
('Desenvolvimento Web com Node.js',     'Criação de APIs REST com Node.js, Express e TypeScript.',                   80, 'Tecnologia'),
('Design de Interfaces e UX',           'Princípios de usabilidade, pesquisa com usuários e prototipação.',          40, 'Design'),
('Gestão de Projetos Ágeis',            'Scrum, Kanban e rituais ágeis aplicados a equipes pequenas.',               30, 'Gestão'),
('Marketing Digital',                   'Conteúdo, redes sociais, SEO e análise de métricas.',                       45, 'Marketing'),
('Inglês para Entrevistas e Carreira',  'Vocabulário, simulações de entrevista e escrita de e-mails profissionais.', 50, 'Idiomas'),
('Análise de Dados com Python',         'Limpeza, exploração e visualização de dados com Pandas.',                   60, 'Dados');


-- ---------------------------------------------------------------------
-- 2) ESPECIALIZAÇÕES DE USUÁRIO (administrador, aluno, professor)
--    Filtramos/associamos o usuário pelo EMAIL em vez de digitar o id.
-- ---------------------------------------------------------------------

-- Administrador: tabela derivada (email + privilégio) + JOIN com usuario
insert into administrador (privilegio, id_usuario)
select d.privilegio, u.id
from (
    select 'beatriz.lopes@admin.exemplo.com' as email, 3 as privilegio
    union all select 'eduardo.silva@admin.exemplo.com', 2
) as d
join usuario u on u.email = d.email;

-- Aluno: aqui só precisamos do id, então um SELECT com IN já resolve
insert into aluno (id_usuario)
select u.id
from usuario u
where u.email in (
    'ana.souza@exemplo.com',
    'lucas.oliveira@exemplo.com',
    'mariana.pereira@exemplo.com',
    'gabriel.almeida@exemplo.com',
    'isabela.martins@exemplo.com',
    'pedro.barbosa@exemplo.com',
    'larissa.nunes@exemplo.com',
    'rafael.ribeiro@exemplo.com',
    'camila.dias@exemplo.com',
    'thiago.cardoso@exemplo.com'
)
order by u.id;

-- Professor
insert into professor (status, id_usuario)
select d.status, u.id
from (
    select 'aprovado' as status, 'marcos.ferreira@prof.exemplo.com' as email
    union all select 'aprovado', 'fernanda.rocha@prof.exemplo.com'
    union all select 'aprovado', 'patricia.duarte@prof.exemplo.com'
    union all select 'aprovado', 'ricardo.teixeira@prof.exemplo.com'
    union all select 'pendente', 'juliana.mendes@prof.exemplo.com'
) as d
join usuario u on u.email = d.email;


-- ---------------------------------------------------------------------
-- 3) TABELAS QUE DEPENDEM DE CURSO
-- ---------------------------------------------------------------------

-- Sala de aula: troca o título do curso pelo id do curso
insert into sala_de_aula (titulo, conteudo, id_curso)
select d.titulo, d.conteudo, c.id
from (
    select 'Fundamentos de Java' as titulo,
           'Variáveis, tipos, condicionais e laços de repetição.' as conteudo,
           'Introdução à Programação com Java' as curso
    union all select 'Orientação a Objetos em Java',           'Classes, objetos, herança, polimorfismo e interfaces.',    'Introdução à Programação com Java'
    union all select 'Modelagem e SQL Básico',                 'MER, modelo relacional, CREATE TABLE, INSERT e SELECT.',   'Banco de Dados com PostgreSQL'
    union all select 'Consultas Avançadas no PostgreSQL',      'JOINs, subconsultas, agregações e views.',                 'Banco de Dados com PostgreSQL'
    union all select 'APIs REST com Node.js e Express',        'Rotas, middlewares, controllers e persistência de dados.', 'Desenvolvimento Web com Node.js'
    union all select 'TypeScript no Back-end',                 'Tipagem estática, interfaces e organização de projetos.',  'Desenvolvimento Web com Node.js'
    union all select 'Princípios de UX',                       'Heurísticas de usabilidade e jornada do usuário.',         'Design de Interfaces e UX'
    union all select 'Prototipação no Figma',                  'Wireframes, componentes e protótipos navegáveis.',         'Design de Interfaces e UX'
    union all select 'Scrum na Prática',                       'Papéis, eventos e artefatos do Scrum.',                    'Gestão de Projetos Ágeis'
    union all select 'Marketing de Conteúdo e Redes Sociais',  'Planejamento editorial e métricas de engajamento.',        'Marketing Digital'
    union all select 'Inglês para Entrevistas de Emprego',     'Perguntas comuns, respostas modelo e simulações.',         'Inglês para Entrevistas e Carreira'
    union all select 'Análise Exploratória com Pandas',        'Leitura de dados, limpeza e estatísticas descritivas.',    'Análise de Dados com Python'
) as d
join curso c on c.titulo = d.curso;

-- Jogo
insert into jogo (nome, descricao, categoria, pontuacao_maxima, id_curso)
select d.nome, d.descricao, d.categoria, d.pontuacao_maxima, c.id
from (
    select 'Java Challenge' as nome,
           'Quiz com perguntas de lógica e sintaxe em Java.' as descricao,
           'Quiz' as categoria,
           100 as pontuacao_maxima,
           'Introdução à Programação com Java' as curso
    union all select 'SQL Detective',    'Resolva casos escrevendo consultas SQL para achar pistas.',  'Puzzle',            150, 'Banco de Dados com PostgreSQL'
    union all select 'API Builder Race', 'Monte rotas de uma API o mais rápido possível.',             'Desafio de código', 200, 'Desenvolvimento Web com Node.js'
    union all select 'UX Match',         'Jogo da memória com conceitos e heurísticas de UX.',         'Memória',            80, 'Design de Interfaces e UX'
    union all select 'Scrum Simulator',  'Simule uma Sprint tomando decisões como Scrum Master.',      'Simulação',         120, 'Gestão de Projetos Ágeis'
    union all select 'Interview Ninja',  'Responda perguntas de entrevista em inglês contra o tempo.', 'Simulação',         100, 'Inglês para Entrevistas e Carreira'
) as d
join curso c on c.titulo = d.curso;


-- ---------------------------------------------------------------------
-- 4) ATIVIDADE
--    id_sala_de_aula vem do título da sala; id_aluno vem do email do aluno
--    (passando por usuario -> aluno). Como id_aluno pode ser NULL
--    (atividades ainda sem aluno), usamos LEFT JOIN para não perder essas linhas.
-- ---------------------------------------------------------------------

insert into atividade (titulo, descricao, dt_inicio, dt_fim, nota, nota_maxima, id_sala_de_aula, id_aluno)
select d.titulo, d.descricao, d.dt_inicio, d.dt_fim, d.nota, d.nota_maxima, s.id, a.id
from (
    select 'Exercício: Hello World e variáveis' as titulo,
           'Criar programas simples usando variáveis e entrada de dados.' as descricao,
           '2026-03-02 08:00:00' as dt_inicio, '2026-03-09 23:59:00' as dt_fim,
           9.50 as nota, 10.00 as nota_maxima,
           'Fundamentos de Java' as sala,
           'ana.souza@exemplo.com' as email_aluno
    union all select 'Lista de exercícios sobre laços',        'Resolver 10 problemas usando for e while.',                       '2026-03-10 08:00:00', '2026-03-17 23:59:00',  8.00, 10.00, 'Fundamentos de Java',                     'gabriel.almeida@exemplo.com'
    union all select 'Projeto: Sistema de Biblioteca',         'Implementar um cadastro de livros usando orientação a objetos.',  '2026-04-06 08:00:00', '2026-04-27 23:59:00', 17.50, 20.00, 'Orientação a Objetos em Java',            'lucas.oliveira@exemplo.com'
    union all select 'Modelagem do banco de uma loja',         'Criar o MER e o MR de uma loja virtual.',                         '2026-05-04 08:00:00', '2026-05-18 23:59:00', 18.00, 20.00, 'Modelagem e SQL Básico',                  'mariana.pereira@exemplo.com'
    union all select 'Lista de consultas com JOIN',            'Escrever consultas com INNER JOIN e LEFT JOIN.',                  '2026-06-01 08:00:00', '2026-06-08 23:59:00',  9.00, 10.00, 'Consultas Avançadas no PostgreSQL',       'thiago.cardoso@exemplo.com'
    union all select 'Criação de API de tarefas',              'Construir uma API REST de lista de tarefas com Express.',         '2026-08-03 08:00:00', '2026-08-24 23:59:00', 27.00, 30.00, 'APIs REST com Node.js e Express',         'rafael.ribeiro@exemplo.com'
    union all select 'Migração de JavaScript para TypeScript', 'Converter um projeto existente adicionando tipagem.',             '2026-08-31 08:00:00', '2026-09-07 23:59:00', 24.50, 30.00, 'TypeScript no Back-end',                  'gabriel.almeida@exemplo.com'
    union all select 'Análise heurística de um aplicativo',    'Avaliar um app usando as 10 heurísticas de Nielsen.',             '2026-07-06 08:00:00', '2026-07-13 23:59:00',  8.50, 10.00, 'Princípios de UX',                        'isabela.martins@exemplo.com'
    union all select 'Protótipo de tela de login',             'Criar um protótipo navegável de uma tela de login no Figma.',     '2026-07-20 08:00:00', '2026-07-27 23:59:00',  9.00, 10.00, 'Prototipação no Figma',                   'camila.dias@exemplo.com'
    union all select 'Planejamento de uma Sprint',             'Montar o backlog e o planejamento de uma Sprint de 2 semanas.',   '2026-09-14 08:00:00', '2026-09-21 23:59:00',  7.50, 10.00, 'Scrum na Prática',                        'pedro.barbosa@exemplo.com'
    union all select 'Calendário de conteúdo mensal',          'Planejar 30 dias de postagens para uma marca fictícia.',          '2026-09-07 08:00:00', '2026-09-14 23:59:00',  9.00, 10.00, 'Marketing de Conteúdo e Redes Sociais',   'isabela.martins@exemplo.com'
    union all select 'Simulação de entrevista em inglês',      'Gravar uma entrevista simulada respondendo 5 perguntas.',         '2026-10-05 08:00:00', '2026-10-12 23:59:00',  8.00, 10.00, 'Inglês para Entrevistas de Emprego',      'larissa.nunes@exemplo.com'
    union all select 'Limpeza de dataset com Pandas',          'Tratar valores nulos e duplicados em um conjunto de dados real.', '2026-10-26 08:00:00', '2026-11-09 23:59:00',  null, 20.00, 'Análise Exploratória com Pandas',         'mariana.pereira@exemplo.com'
    union all select 'Quiz de revisão de Java',                'Questionário de revisão para a turma.',                           '2026-11-02 08:00:00', '2026-11-09 23:59:00',  null, 10.00, 'Fundamentos de Java',                     null
    union all select 'Desafio de modelagem DER',               'Modelar o banco de uma clínica veterinária.',                     '2026-11-09 08:00:00', '2026-11-23 23:59:00',  null, 20.00, 'Modelagem e SQL Básico',                  null
) as d
join sala_de_aula s      on s.titulo = d.sala
left join usuario ua     on ua.email = d.email_aluno
left join aluno a        on a.id_usuario = ua.id;


-- ---------------------------------------------------------------------
-- 5) CERTIFICADO, PUBLICAÇÃO, MENSAGEM, VAGA
-- ---------------------------------------------------------------------

-- Certificado: aluno encontrado pelo email (usuario -> aluno)
insert into certificado (titulo, dt_emissao, carga_horaria, id_aluno)
select d.titulo, d.dt_emissao, d.carga_horaria, a.id
from (
    select 'Introdução à Programação com Java' as titulo, '2026-06-20' as dt_emissao, 60 as carga_horaria, 'ana.souza@exemplo.com' as email
    union all select 'Banco de Dados com PostgreSQL',      '2026-08-15', 40, 'ana.souza@exemplo.com'
    union all select 'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 'ana.souza@exemplo.com'
    union all select 'Introdução à Programação com Java',  '2026-06-20', 60, 'lucas.oliveira@exemplo.com'
    union all select 'Desenvolvimento Web com Node.js',    '2026-09-10', 80, 'lucas.oliveira@exemplo.com'
    union all select 'Gestão de Projetos Ágeis',           '2026-07-05', 30, 'lucas.oliveira@exemplo.com'
    union all select 'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 'lucas.oliveira@exemplo.com'
    union all select 'Banco de Dados com PostgreSQL',      '2026-08-15', 40, 'mariana.pereira@exemplo.com'
    union all select 'Gestão de Projetos Ágeis',           '2026-07-05', 30, 'mariana.pereira@exemplo.com'
    union all select 'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 'mariana.pereira@exemplo.com'
    union all select 'Desenvolvimento Web com Node.js',    '2026-09-10', 80, 'gabriel.almeida@exemplo.com'
    union all select 'Design de Interfaces e UX',          '2026-08-28', 40, 'isabela.martins@exemplo.com'
    union all select 'Marketing Digital',                  '2026-09-20', 45, 'isabela.martins@exemplo.com'
    union all select 'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 'isabela.martins@exemplo.com'
    union all select 'Gestão de Projetos Ágeis',           '2026-07-05', 30, 'isabela.martins@exemplo.com'
    union all select 'Inglês para Entrevistas e Carreira', '2026-10-20', 50, 'larissa.nunes@exemplo.com'
    union all select 'Desenvolvimento Web com Node.js',    '2026-09-10', 80, 'rafael.ribeiro@exemplo.com'
    union all select 'Marketing Digital',                  '2026-09-20', 45, 'camila.dias@exemplo.com'
) as d
join usuario u on u.email = d.email
join aluno a   on a.id_usuario = u.id;

-- Publicação: o autor pode ser qualquer usuário (aluno, professor ou admin),
-- então ligamos direto com usuario.
insert into publicacao (titulo, conteudo, dt_publicacao, id_usuario)
select d.titulo, d.conteudo, d.dt_publicacao, u.id
from (
    select 'Dicas para começar em Java' as titulo,
           'Comece pelos fundamentos: variáveis, laços e orientação a objetos. Pratique todos os dias, mesmo que seja por 30 minutos.' as conteudo,
           '2026-03-05 10:15:00' as dt_publicacao,
           'marcos.ferreira@prof.exemplo.com' as email
    union all select 'Por que aprender PostgreSQL?',               'O PostgreSQL é gratuito, robusto e muito usado no mercado. Dominar SQL abre portas em quase qualquer área de tecnologia.', '2026-03-12 09:40:00', 'fernanda.rocha@prof.exemplo.com'
    union all select 'Meu primeiro projeto em Java',               'Finalizei meu sistema de biblioteca! Foi desafiador entender herança, mas valeu muito a pena.',                            '2026-04-20 19:05:00', 'ana.souza@exemplo.com'
    union all select 'UX e carreira: por onde começar',            'Estude usabilidade, monte um portfólio com 3 estudos de caso e peça feedback de outras pessoas da área.',                  '2026-05-08 11:20:00', 'patricia.duarte@prof.exemplo.com'
    union all select 'Como montar um currículo que chama atenção', 'Seja objetivo, destaque projetos e resultados e adapte o currículo para cada vaga.',                                        '2026-05-15 08:30:00', 'ricardo.teixeira@prof.exemplo.com'
    union all select 'O que aprendi no curso de UX',               'Aprendi que o usuário nunca é igual a nós. Testar com pessoas reais mudou completamente meu protótipo.',                   '2026-08-30 20:10:00', 'isabela.martins@exemplo.com'
    union all select 'Novidades da plataforma Mapa Carreiras',     'Chegaram os jogos educativos e a nova área de vagas de estágio. Explore e conte para a gente o que achou!',                '2026-09-01 09:00:00', 'beatriz.lopes@admin.exemplo.com'
    union all select 'Procuro grupo de estudo de Node.js',         'Alguém quer montar um grupo para estudar APIs REST aos fins de semana?',                                                   '2026-09-14 21:45:00', 'lucas.oliveira@exemplo.com'
    union all select 'Preparação para entrevistas em inglês',      'Treine as respostas em voz alta e grave a si mesmo. Perceber os próprios erros acelera muito o aprendizado.',              '2026-10-20 15:00:00', 'juliana.mendes@prof.exemplo.com'
    union all select 'Vagas de estágio: o que as empresas esperam','Além da parte técnica, as empresas valorizam comunicação, vontade de aprender e trabalho em equipe.',                         '2026-10-22 10:00:00', 'ricardo.teixeira@prof.exemplo.com'
    union all select 'Dúvida sobre JOIN no PostgreSQL',            'Alguém consegue explicar a diferença entre INNER JOIN e LEFT JOIN com um exemplo simples?',                                '2026-10-23 18:25:00', 'rafael.ribeiro@exemplo.com'
    union all select 'Manutenção programada',                      'A plataforma ficará indisponível no sábado, das 02h às 04h, para manutenção.',                                             '2026-10-25 08:00:00', 'eduardo.silva@admin.exemplo.com'
    union all select 'Dica de Ouro para Portfólio',                'Suba seus códigos para o GitHub com um README bem documentado, pois isso ajuda muito os recrutadores de TI experientes e exigentes.', '2026-10-27 14:00:00', 'beatriz.lopes@admin.exemplo.com'
    union all select 'Dica de Lógica de Programação',              'Resolva pequenos desafios em plataformas como LeetCode ou HackerRank diariamente para ganhar bastante agilidade mental na programação moderna.', '2026-10-27 15:30:00', 'marcos.ferreira@prof.exemplo.com'
    union all select 'Oportunidade de Networking',                 'Participe de meetups e comunidades de tecnologia para ser lembrado pelo mercado e criar boas conexões profissionais valiosas hoje.', '2026-10-27 16:00:00', 'fernanda.rocha@prof.exemplo.com'
) as d
join usuario u on u.email = d.email;

-- Mensagem: DUAS chaves estrangeiras para a mesma tabela (usuario).
-- Por isso fazemos dois JOINs com apelidos diferentes: ud (destinatário) e ur (remetente).
insert into mensagem (texto, dt_hora_envio, id_usuario_remetente, id_usuario_destinatario)
select d.texto, d.dt_hora_envio, ur.id, ud.id
from (
    select 'Professor, posso entregar o projeto final com um dia de atraso?' as texto,
           '2026-09-12 14:32:00' as dt_hora_envio,
           'marcos.ferreira@prof.exemplo.com' as email_destinatario,
           'ana.souza@exemplo.com' as email_remetente
    union all select 'Pode sim, Ana. Só me avise até amanhã cedo.',                                   '2026-09-12 16:10:00', 'ana.souza@exemplo.com',             'marcos.ferreira@prof.exemplo.com'
    union all select 'Professora, o material de consultas com JOIN já está disponível?',              '2026-09-15 09:05:00', 'fernanda.rocha@prof.exemplo.com',   'lucas.oliveira@exemplo.com'
    union all select 'Já está na sala, Lucas. Qualquer dúvida é só chamar.',                          '2026-09-15 11:47:00', 'lucas.oliveira@exemplo.com',        'fernanda.rocha@prof.exemplo.com'
    union all select 'Ana, você tem as anotações da aula de SQL?',                                    '2026-09-18 20:15:00', 'ana.souza@exemplo.com',             'mariana.pereira@exemplo.com'
    union all select 'Tenho sim, te mando hoje à noite.',                                             '2026-09-18 20:40:00', 'mariana.pereira@exemplo.com',       'ana.souza@exemplo.com'
    union all select 'Isabela, seu portfólio ficou ótimo. Vale se candidatar à vaga de marketing.',   '2026-09-22 13:00:00', 'isabela.martins@exemplo.com',       'ricardo.teixeira@prof.exemplo.com'
    union all select 'Obrigada, professor! Já enviei minha candidatura.',                             '2026-09-22 13:25:00', 'ricardo.teixeira@prof.exemplo.com', 'isabela.martins@exemplo.com'
    union all select 'Olá, Juliana! Seu cadastro de professora está em análise.',                     '2026-10-16 10:00:00', 'juliana.mendes@prof.exemplo.com',   'beatriz.lopes@admin.exemplo.com'
    union all select 'Obrigada! Já enviei os documentos solicitados.',                                '2026-10-16 10:30:00', 'beatriz.lopes@admin.exemplo.com',   'juliana.mendes@prof.exemplo.com'
    union all select 'Gabriel, bora estudar para a prova de APIs amanhã?',                            '2026-10-20 19:50:00', 'gabriel.almeida@exemplo.com',       'rafael.ribeiro@exemplo.com'
    union all select 'Bora! Que tal às 19h?',                                                         '2026-10-20 20:05:00', 'rafael.ribeiro@exemplo.com',        'gabriel.almeida@exemplo.com'
    union all select 'Camila, sua prototipação ficou muito boa.',                                     '2026-10-21 15:30:00', 'camila.dias@exemplo.com',           'patricia.duarte@prof.exemplo.com'
    union all select 'Professora, posso revisar a atividade de JOIN?',                                '2026-10-24 17:10:00', 'fernanda.rocha@prof.exemplo.com',   'thiago.cardoso@exemplo.com'
) as d
join usuario ud on ud.email = d.email_destinatario
join usuario ur on ur.email = d.email_remetente;

-- Vaga: o professor responsável é encontrado pelo email (usuario -> professor)
insert into vaga (titulo, descricao, requisitos, status, dt_emissao, dt_publicacao, id_professor)
select d.titulo, d.descricao, d.requisitos, d.status, d.dt_emissao, d.dt_publicacao, p.id
from (
    select 'Estagiário(a) de Desenvolvimento Java' as titulo,
           'Desenvolvimento e manutenção de sistemas web em Java.' as descricao,
           'Java básico, SQL, Git, cursando Computação ou áreas afins.' as requisitos,
           'aberta' as status,
           '2026-09-01' as dt_emissao,
           '2026-09-02 09:00:00' as dt_publicacao,
           'marcos.ferreira@prof.exemplo.com' as email_prof
    union all select 'Estagiário(a) de Dados e BI',               'Apoio na criação de dashboards e análises de dados.',                                  'SQL, Excel e noções de Python.',                              'aberta',     '2026-09-10', '2026-09-11 10:00:00', 'fernanda.rocha@prof.exemplo.com'
    union all select 'Estágio em UX/UI Design',                   'Apoio no desenho e teste de interfaces.',                                              'Figma, noções de usabilidade e portfólio.',                   'encerrada',  '2026-07-15', '2026-07-16 08:30:00', 'patricia.duarte@prof.exemplo.com'
    union all select 'Assistente de Marketing Digital',           'Criação de conteúdo e acompanhamento de métricas.',                                    'Redes sociais, redação e noções de SEO.',                     'aberta',     '2026-09-05', '2026-09-06 14:00:00', 'ricardo.teixeira@prof.exemplo.com'
    union all select 'Desenvolvedor(a) Node.js Júnior',           'Desenvolvimento de APIs REST com Node.js e PostgreSQL.',                               'Node.js, TypeScript, Express, SQL e Git.',                    'aberta',     '2026-10-01', '2026-10-02 09:30:00', 'marcos.ferreira@prof.exemplo.com'
    union all select 'Analista de Dados Júnior',                  'Limpeza e análise de dados com Python e SQL.',                                         'Python, Pandas, SQL e estatística básica.',                   'em análise', '2026-10-12', '2026-10-13 11:00:00', 'fernanda.rocha@prof.exemplo.com'
    union all select 'Trainee em Gestão de Projetos',             'Acompanhamento de sprints e rituais ágeis.',                                           'Scrum, boa comunicação e inglês intermediário.',              'aberta',     '2026-10-15', '2026-10-16 08:00:00', 'ricardo.teixeira@prof.exemplo.com'
    union all select 'Estagiário(a) de Suporte e Infraestrutura', 'Atendimento a chamados técnicos e suporte ao usuário.',                                'Noções de redes, sistemas, hardware básico e vontade de aprender.', 'aberta', '2026-10-25', '2026-10-26 09:00:00', 'marcos.ferreira@prof.exemplo.com'
    union all select 'Desenvolvedor(a) Front-End Júnior',         'Desenvolvimento de interfaces responsivas usando HTML, JavaScript, e react.',          'Cursando Superior em TI, conhecimento básico de Git.',        'aberta',     '2026-10-26', '2026-10-27 10:00:00', 'fernanda.rocha@prof.exemplo.com'
    union all select 'Analista de Dados Trainee',                 'Auxílio na criação de relatórios, dashboards e tratamento de dados com SQL e Python.', 'Familiaridade com bancos de dados relacionais.',                'aberta',     '2026-10-26', '2026-10-27 11:30:00', 'patricia.duarte@prof.exemplo.com'
) as d
join usuario u   on u.email = d.email_prof
join professor p on p.id_usuario = u.id;


-- ---------------------------------------------------------------------
-- 6) TABELAS ASSOCIATIVAS (N:N)
--    Aqui o ganho é maior: só têm chaves estrangeiras, então sem o
--    INSERT ... SELECT teríamos só "números soltos" difíceis de conferir.
-- ---------------------------------------------------------------------

-- Professor <-> Especialização
insert into prof_espec (id_professor, id_especializacao)
select p.id, e.id
from (
    select 'marcos.ferreira@prof.exemplo.com' as email, 'Desenvolvimento de Software' as especializacao
    union all select 'marcos.ferreira@prof.exemplo.com',  'Banco de Dados e Análise de Dados'
    union all select 'fernanda.rocha@prof.exemplo.com',   'Banco de Dados e Análise de Dados'
    union all select 'fernanda.rocha@prof.exemplo.com',   'Desenvolvimento de Software'
    union all select 'patricia.duarte@prof.exemplo.com',  'Design e Experiência do Usuário'
    union all select 'ricardo.teixeira@prof.exemplo.com', 'Gestão de Carreira e Comunicação'
    union all select 'juliana.mendes@prof.exemplo.com',   'Gestão de Carreira e Comunicação'
) as d
join usuario u        on u.email = d.email
join professor p      on p.id_usuario = u.id
join especializacao e on e.nome = d.especializacao;

-- Professor <-> Formação (formacao só tem a data, então usamos a data como chave natural)
insert into professor_formacao (id_professor, id_formacao)
select p.id, f.id
from (
    select 'marcos.ferreira@prof.exemplo.com' as email, '2008-12-15' as dt_form
    union all select 'marcos.ferreira@prof.exemplo.com',  '2018-07-20'
    union all select 'fernanda.rocha@prof.exemplo.com',   '2012-07-10'
    union all select 'fernanda.rocha@prof.exemplo.com',   '2020-12-10'
    union all select 'patricia.duarte@prof.exemplo.com',  '2015-12-18'
    union all select 'ricardo.teixeira@prof.exemplo.com', '2010-06-25'
    union all select 'ricardo.teixeira@prof.exemplo.com', '2020-12-10'
    union all select 'juliana.mendes@prof.exemplo.com',   '2018-07-20'
) as d
join usuario u   on u.email = d.email
join professor p on p.id_usuario = u.id
join formacao f  on f.dt_form = d.dt_form;

-- Curso <-> Professor
insert into curso_professor (id_professor, id_curso)
select p.id, c.id
from (
    select 'marcos.ferreira@prof.exemplo.com' as email, 'Introdução à Programação com Java' as curso
    union all select 'marcos.ferreira@prof.exemplo.com',  'Desenvolvimento Web com Node.js'
    union all select 'fernanda.rocha@prof.exemplo.com',   'Banco de Dados com PostgreSQL'
    union all select 'fernanda.rocha@prof.exemplo.com',   'Análise de Dados com Python'
    union all select 'patricia.duarte@prof.exemplo.com',  'Design de Interfaces e UX'
    union all select 'ricardo.teixeira@prof.exemplo.com', 'Gestão de Projetos Ágeis'
    union all select 'ricardo.teixeira@prof.exemplo.com', 'Marketing Digital'
    union all select 'ricardo.teixeira@prof.exemplo.com', 'Inglês para Entrevistas e Carreira'
    union all select 'juliana.mendes@prof.exemplo.com',   'Inglês para Entrevistas e Carreira'
) as d
join usuario u   on u.email = d.email
join professor p on p.id_usuario = u.id
join curso c     on c.titulo = d.curso;

-- Aluno <-> Vaga (candidaturas)
insert into aluno_vaga (id_aluno, id_vaga)
select a.id, v.id
from (
    select 'ana.souza@exemplo.com' as email, 'Estagiário(a) de Desenvolvimento Java' as vaga
    union all select 'ana.souza@exemplo.com',         'Desenvolvedor(a) Node.js Júnior'
    union all select 'lucas.oliveira@exemplo.com',    'Estagiário(a) de Desenvolvimento Java'
    union all select 'lucas.oliveira@exemplo.com',    'Desenvolvedor(a) Node.js Júnior'
    union all select 'mariana.pereira@exemplo.com',   'Estagiário(a) de Dados e BI'
    union all select 'mariana.pereira@exemplo.com',   'Analista de Dados Júnior'
    union all select 'gabriel.almeida@exemplo.com',   'Desenvolvedor(a) Node.js Júnior'
    union all select 'isabela.martins@exemplo.com',   'Estágio em UX/UI Design'
    union all select 'isabela.martins@exemplo.com',   'Assistente de Marketing Digital'
    union all select 'pedro.barbosa@exemplo.com',     'Trainee em Gestão de Projetos'
    union all select 'larissa.nunes@exemplo.com',     'Assistente de Marketing Digital'
    union all select 'rafael.ribeiro@exemplo.com',    'Estagiário(a) de Desenvolvimento Java'
    union all select 'rafael.ribeiro@exemplo.com',    'Desenvolvedor(a) Node.js Júnior'
    union all select 'camila.dias@exemplo.com',       'Assistente de Marketing Digital'
    union all select 'thiago.cardoso@exemplo.com',    'Estagiário(a) de Dados e BI'
) as d
join usuario u on u.email = d.email
join aluno a   on a.id_usuario = u.id
join vaga v    on v.titulo = d.vaga;

-- Aluno <-> Jogo (com pontuação)
insert into aluno_jogo (id_aluno, id_jogo, pontuacao)
select a.id, j.id, d.pontuacao
from (
    select 'ana.souza@exemplo.com' as email, 'Java Challenge' as jogo, 90 as pontuacao
    union all select 'ana.souza@exemplo.com',         'SQL Detective',    120
    union all select 'lucas.oliveira@exemplo.com',    'Java Challenge',    85
    union all select 'lucas.oliveira@exemplo.com',    'API Builder Race', 160
    union all select 'mariana.pereira@exemplo.com',   'SQL Detective',    140
    union all select 'gabriel.almeida@exemplo.com',   'Java Challenge',    70
    union all select 'gabriel.almeida@exemplo.com',   'API Builder Race', 180
    union all select 'isabela.martins@exemplo.com',   'UX Match',          75
    union all select 'pedro.barbosa@exemplo.com',     'Scrum Simulator',  100
    union all select 'larissa.nunes@exemplo.com',     'Interview Ninja',   90
    union all select 'rafael.ribeiro@exemplo.com',    'API Builder Race', 150
    union all select 'camila.dias@exemplo.com',       'UX Match',          60
    union all select 'camila.dias@exemplo.com',       'Scrum Simulator',  110
    union all select 'thiago.cardoso@exemplo.com',    'SQL Detective',     95
) as d
join usuario u on u.email = d.email
join aluno a   on a.id_usuario = u.id
join jogo j    on j.nome = d.jogo;

-- Quem ainda não jogou: não informamos "pontuacao", então vale o DEFAULT 0 da coluna
insert into aluno_jogo (id_aluno, id_jogo)
select a.id, j.id
from usuario u
join aluno a on a.id_usuario = u.id
join jogo j  on j.nome = 'Interview Ninja'
where u.email = 'thiago.cardoso@exemplo.com';

-- Aluno <-> Sala de aula (matrículas)
insert into aluno_sala (id_aluno, id_sala_de_aula)
select a.id, s.id
from (
    select 'ana.souza@exemplo.com' as email, 'Fundamentos de Java' as sala
    union all select 'ana.souza@exemplo.com',        'Orientação a Objetos em Java'
    union all select 'ana.souza@exemplo.com',        'Modelagem e SQL Básico'
    union all select 'lucas.oliveira@exemplo.com',   'Fundamentos de Java'
    union all select 'lucas.oliveira@exemplo.com',   'Orientação a Objetos em Java'
    union all select 'lucas.oliveira@exemplo.com',   'APIs REST com Node.js e Express'
    union all select 'mariana.pereira@exemplo.com',  'Modelagem e SQL Básico'
    union all select 'mariana.pereira@exemplo.com',  'Consultas Avançadas no PostgreSQL'
    union all select 'mariana.pereira@exemplo.com',  'Análise Exploratória com Pandas'
    union all select 'gabriel.almeida@exemplo.com',  'Fundamentos de Java'
    union all select 'gabriel.almeida@exemplo.com',  'APIs REST com Node.js e Express'
    union all select 'gabriel.almeida@exemplo.com',  'TypeScript no Back-end'
    union all select 'isabela.martins@exemplo.com',  'Princípios de UX'
    union all select 'isabela.martins@exemplo.com',  'Prototipação no Figma'
    union all select 'isabela.martins@exemplo.com',  'Marketing de Conteúdo e Redes Sociais'
    union all select 'pedro.barbosa@exemplo.com',    'Scrum na Prática'
    union all select 'pedro.barbosa@exemplo.com',    'Marketing de Conteúdo e Redes Sociais'
    union all select 'pedro.barbosa@exemplo.com',    'Inglês para Entrevistas de Emprego'
    union all select 'larissa.nunes@exemplo.com',    'Princípios de UX'
    union all select 'larissa.nunes@exemplo.com',    'Inglês para Entrevistas de Emprego'
    union all select 'larissa.nunes@exemplo.com',    'Análise Exploratória com Pandas'
    union all select 'rafael.ribeiro@exemplo.com',   'Modelagem e SQL Básico'
    union all select 'rafael.ribeiro@exemplo.com',   'APIs REST com Node.js e Express'
    union all select 'rafael.ribeiro@exemplo.com',   'TypeScript no Back-end'
    union all select 'camila.dias@exemplo.com',      'Prototipação no Figma'
    union all select 'camila.dias@exemplo.com',      'Scrum na Prática'
    union all select 'camila.dias@exemplo.com',      'Marketing de Conteúdo e Redes Sociais'
    union all select 'thiago.cardoso@exemplo.com',   'Consultas Avançadas no PostgreSQL'
    union all select 'thiago.cardoso@exemplo.com',   'Inglês para Entrevistas de Emprego'
    union all select 'thiago.cardoso@exemplo.com',   'Análise Exploratória com Pandas'
) as d
join usuario u      on u.email = d.email
join aluno a        on a.id_usuario = u.id
join sala_de_aula s on s.titulo = d.sala;

-- Usuário <-> Publicação (comentários)
insert into publi_comenta (id_usuario, id_publicacao)
select u.id, p.id
from (
    select 'ana.souza@exemplo.com' as email, 'Dicas para começar em Java' as publicacao
    union all select 'lucas.oliveira@exemplo.com',        'Dicas para começar em Java'
    union all select 'gabriel.almeida@exemplo.com',       'Dicas para começar em Java'
    union all select 'mariana.pereira@exemplo.com',       'Por que aprender PostgreSQL?'
    union all select 'rafael.ribeiro@exemplo.com',        'Por que aprender PostgreSQL?'
    union all select 'thiago.cardoso@exemplo.com',        'Por que aprender PostgreSQL?'
    union all select 'marcos.ferreira@prof.exemplo.com',  'Meu primeiro projeto em Java'
    union all select 'lucas.oliveira@exemplo.com',        'Meu primeiro projeto em Java'
    union all select 'isabela.martins@exemplo.com',       'UX e carreira: por onde começar'
    union all select 'camila.dias@exemplo.com',           'UX e carreira: por onde começar'
    union all select 'ana.souza@exemplo.com',             'Como montar um currículo que chama atenção'
    union all select 'isabela.martins@exemplo.com',       'Como montar um currículo que chama atenção'
    union all select 'larissa.nunes@exemplo.com',         'Como montar um currículo que chama atenção'
    union all select 'patricia.duarte@prof.exemplo.com',  'O que aprendi no curso de UX'
    union all select 'pedro.barbosa@exemplo.com',         'O que aprendi no curso de UX'
    union all select 'lucas.oliveira@exemplo.com',        'Novidades da plataforma Mapa Carreiras'
    union all select 'ricardo.teixeira@prof.exemplo.com', 'Novidades da plataforma Mapa Carreiras'
    union all select 'gabriel.almeida@exemplo.com',       'Procuro grupo de estudo de Node.js'
    union all select 'marcos.ferreira@prof.exemplo.com',  'Procuro grupo de estudo de Node.js'
    union all select 'pedro.barbosa@exemplo.com',         'Preparação para entrevistas em inglês'
    union all select 'larissa.nunes@exemplo.com',         'Preparação para entrevistas em inglês'
    union all select 'rafael.ribeiro@exemplo.com',        'Vagas de estágio: o que as empresas esperam'
    union all select 'ana.souza@exemplo.com',             'Vagas de estágio: o que as empresas esperam'
    union all select 'fernanda.rocha@prof.exemplo.com',   'Dúvida sobre JOIN no PostgreSQL'
    union all select 'gabriel.almeida@exemplo.com',       'Dúvida sobre JOIN no PostgreSQL'
    union all select 'mariana.pereira@exemplo.com',       'Manutenção programada'
) as d
join usuario u    on u.email = d.email
join publicacao p on p.titulo = d.publicacao;

commit;
