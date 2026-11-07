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
    dt_cadastro date
);

create table administrador (
    id int auto_increment primary key,
    privilegio int check (privilegio in (1, 2, 3)),
    id_usuario int not null,
    constraint uq_administrador_usuario unique (id_usuario),
    constraint fkadm_usuario foreign key (id_usuario) references usuario(id)
);

create table aluno (
    id int auto_increment primary key,
    id_usuario int not null,
    constraint uq_aluno_usuario unique (id_usuario),
    constraint fkalu_usuario foreign key (id_usuario) references usuario(id)
);

create table professor (
    id int auto_increment primary key,
    status varchar(10) check (status in ('pendente', 'aprovado', 'reprovado')),
    id_usuario int not null,
    constraint uq_professor_usuario unique (id_usuario),
    constraint fkprof_usuario foreign key (id_usuario) references usuario(id)
);

create table especializacao (
    id int auto_increment primary key,
    nome varchar(150) not null
);

create table formacao (
    id int auto_increment primary key,
    dt_form date
);

create table curso (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    descricao text,
    carga_horaria int,
    area varchar(150)
);

create table sala_de_aula (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    conteudo text,
    id_curso int not null,
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
    constraint fkati_sala foreign key (id_sala_de_aula) references sala_de_aula(id),
    constraint fkati_aluno foreign key (id_aluno) references aluno(id)
);

create table certificado (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    dt_emissao date,
    carga_horaria int,
    id_aluno int not null,
    constraint fkcert_aluno foreign key (id_aluno) references aluno(id)
);

create table publicacao (
    id int auto_increment primary key,
    titulo varchar(200) not null,
    conteudo text not null,
    dt_publicacao datetime default current_timestamp,
    id_usuario int not null,
    constraint fkpubli_usuario foreign key (id_usuario) references usuario(id)
);

create table mensagem (
    id int auto_increment primary key,
    texto text not null,
    dt_hora_envio datetime,
    id_destinatario int not null,
    id_remetente int not null,
    constraint fkmens_destin foreign key (id_destinatario) references usuario(id),
    constraint fkmens_remetente foreign key (id_remetente) references usuario(id)
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
    constraint fkvaga_prof foreign key (id_professor) references professor(id)
);

create table jogo (
    id int auto_increment primary key,
    nome varchar(150) not null,
    descricao text,
    categoria varchar(100),
    pontuacao_maxima int,
    id_curso int not null,
    constraint fkjogo_curso foreign key (id_curso) references curso(id)
);

create table prof_espec (
    id_professor int not null,
    id_especializacao int not null,
    constraint primary key (id_professor, id_especializacao),
    constraint fkprof_espec_prof foreign key (id_professor) references professor(id),
    constraint fkprof_espec_espec foreign key (id_especializacao) references especializacao(id)
);

create table professor_formacao (
    id_professor int not null,
    id_formacao int not null,
    constraint primary key (id_professor, id_formacao),
    constraint fkprof_form_prof foreign key (id_professor) references professor(id),
    constraint fkprof_form_form foreign key (id_formacao) references formacao(id)
);

create table curso_professor (
    id_professor int not null,
    id_curso int not null,
    constraint primary key (id_professor, id_curso),
    constraint fkcurso_prof_prof foreign key (id_professor) references professor(id),
    constraint fkcurso_prof_curso foreign key (id_curso) references curso(id)
);

create table aluno_vaga (
    id_aluno int not null,
    id_vaga int not null,
    constraint primary key (id_aluno, id_vaga),
    constraint fkaluno_vaga_aluno foreign key (id_aluno) references aluno(id),
    constraint fkaluno_vaga_vaga foreign key (id_vaga) references vaga(id)
);

create table aluno_jogo (
    id_aluno int not null,
    id_jogo int not null,
    pontuacao int default 0,
    constraint primary key (id_aluno, id_jogo),
    constraint fkaluno_jogo_aluno foreign key (id_aluno) references aluno(id),
    constraint fkaluno_jogo_jogo foreign key (id_jogo) references jogo(id)
);

create table aluno_sala (
    id_aluno int not null,
    id_sala_de_aula int not null,
    constraint primary key (id_aluno, id_sala_de_aula),
    constraint fkaluno_sala_aluno foreign key (id_aluno) references aluno(id),
    constraint fkaluno_sala_sala foreign key (id_sala_de_aula) references sala_de_aula(id)
);

create table publi_comenta (
    id_usuario int not null,
    id_publicacao int not null,
    constraint primary key (id_usuario, id_publicacao),
    constraint fkpubli_comenta_usuario foreign key (id_usuario) references usuario(id),
    constraint fkpubli_comenta_publi foreign key (id_publicacao) references publicacao(id)
);

-- INSERTS


insert into usuario (id, nome, email, senha, cpf, dt_nasc, endereco, telefone, dt_cadastro) values
(1,  'Ana Beatriz Souza',        'ana.souza@exemplo.com',        'senha123', '01234567890', '2002-03-14', 'Rua das Acácias, 120 - São Paulo/SP', '(11) 91234-5601', '2026-02-02'),
(2,  'Lucas Henrique Oliveira',  'lucas.oliveira@exemplo.com',   'senha123', '23456789012', '2001-07-22', 'Av. Brasil, 450 - Campinas/SP', '(19) 98123-4502', '2026-02-02'),
(3,  'Mariana Costa Pereira',    'mariana.pereira@exemplo.com',  'senha123', '34567890123', '2003-11-05', 'Rua Sete de Setembro, 88 - Santos/SP', '(13) 99876-5403', '2026-02-03'),
(4,  'Gabriel Santos Almeida',   'gabriel.almeida@exemplo.com',  'senha123', '45678901234', '2000-01-30', 'Rua XV de Novembro, 301 - Curitiba/PR', '(41) 99765-4304', '2026-02-05'),
(5,  'Isabela Rodrigues Martins','isabela.martins@exemplo.com',  'senha123', '56789012345', '2004-05-18', 'Av. Paulista, 1500 - São Paulo/SP', '(11) 97654-3205', '2026-02-05'),
(6,  'Pedro Augusto Barbosa',    'pedro.barbosa@exemplo.com',    'senha123', '67890123456', '1999-09-09', 'Rua Minas Gerais, 77 - Belo Horizonte/MG', '(31) 98543-2106', '2026-02-09'),
(7,  'Larissa Fernandes Nunes',  'larissa.nunes@exemplo.com',    'senha123', '78901234567', '2002-12-01', 'Rua do Comércio, 19 - Recife/PE', '(81) 99432-1007', '2026-02-10'),
(8,  'Rafael Carvalho Ribeiro',  'rafael.ribeiro@exemplo.com',   'senha123', '89012345678', '2001-04-27', 'Rua das Palmeiras, 640 - Sorocaba/SP', '(15) 98321-0908', '2026-02-12'),
(9,  'Camila Araújo Dias',       'camila.dias@exemplo.com',      'senha123', '90123456789', '2005-08-16', 'Av. Atlântica, 210 - Rio de Janeiro/RJ', '(21) 97210-9809', '2026-02-16'),
(10, 'Thiago Moreira Cardoso',   'thiago.cardoso@exemplo.com',   'senha123', '02345678901', '2000-10-03', 'Rua Goiás, 55 - Goiânia/GO', '(62) 99109-8710', '2026-02-16'),
(11, 'Marcos Vinícius Ferreira', 'marcos.ferreira@prof.exemplo.com',  'senha123', '13579246801', '1982-06-12', 'Rua Augusta, 900 - São Paulo/SP', '(11) 95555-1101', '2025-11-10'),
(12, 'Fernanda Lima Rocha',      'fernanda.rocha@prof.exemplo.com',   'senha123', '24680135792', '1985-02-25', 'Rua Bahia, 340 - Salvador/BA', '(71) 95555-1202', '2025-11-10'),
(13, 'Patrícia Gomes Duarte',    'patricia.duarte@prof.exemplo.com',  'senha123', '35791368024', '1988-09-14', 'Rua das Laranjeiras, 15 - Florianópolis/SC','(48) 95555-1303', '2025-11-12'),
(14, 'Ricardo Alves Teixeira',   'ricardo.teixeira@prof.exemplo.com', 'senha123', '46802479135', '1979-12-03', 'Av. Independência, 720 - Porto Alegre/RS','(51) 95555-1404', '2025-11-12'),
(15, 'Juliana Castro Mendes',    'juliana.mendes@prof.exemplo.com',   'senha123', '57913580246', '1990-04-08', 'Rua Pernambuco, 98 - Fortaleza/CE', '(85) 95555-1505', '2026-10-15'),
(16, 'Beatriz Monteiro Lopes',   'beatriz.lopes@admin.exemplo.com',   'senha123', '68024691357', '1984-07-19', 'Rua da Consolação, 2000 - São Paulo/SP', '(11) 94444-1606', '2025-10-01'),
(17, 'Eduardo Pinheiro Silva',   'eduardo.silva@admin.exemplo.com',   'senha123', '79135702468', '1987-03-23', 'Av. Rio Branco, 500 - Rio de Janeiro/RJ', '(21) 94444-1707', '2025-10-01'),
(18, 'Jéssica Lima Silveira', 'jessica.silveira@exemplo.com', 'senha123', '98765432109', '2004-02-11', 'Rua das Flores, 300 - Campinas/SP', '(19) 97788-9900', '2026-03-01'),
(19, 'Lucas Gabriel Martins', 'lucas.martins@exemplo.com', 'senha123', '12345678901', '2003-07-15', 'Av. Paulista, 1000 - São Paulo/SP', '(11) 98877-6655', '2026-03-02'),
(20, 'Beatriz Souza Costa', 'beatriz.costa@exemplo.com', 'senha123', '32165498702', '2001-11-20', 'Rua da Bahia, 500 - Belo Horizonte/MG', '(31) 97766-5544', '2026-03-02');

insert into administrador (id, privilegio, id_usuario) values
(1, 3, 16),
(2, 2, 17);

insert into aluno (id, id_usuario) values
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

insert into professor (id, status, id_usuario) values
(1, 'aprovado', 11),
(2, 'aprovado', 12),
(3, 'aprovado', 13),
(4, 'aprovado', 14),
(5, 'pendente', 15);

insert into especializacao (id, nome) values
(1, 'Desenvolvimento de Software'),
(2, 'Banco de Dados e Análise de Dados'),
(3, 'Design e Experiência do Usuário'),
(4, 'Gestão de Carreira e Comunicação');

insert into formacao (id, dt_form) values
(1, '2008-12-15'),
(2, '2012-07-10'),
(3, '2015-12-18'),
(4, '2010-06-25'),
(5, '2018-07-20'),
(6, '2020-12-10');

insert into curso (id, titulo, descricao, carga_horaria, area) values
(1, 'Introdução à Programação com Java',   'Lógica de programação, sintaxe do Java e orientação a objetos.',          60, 'Tecnologia'),
(2, 'Banco de Dados com PostgreSQL',       'Modelagem relacional, SQL e boas práticas com PostgreSQL.',               40, 'Tecnologia'),
(3, 'Desenvolvimento Web com Node.js',     'Criação de APIs REST com Node.js, Express e TypeScript.',                 80, 'Tecnologia'),
(4, 'Design de Interfaces e UX',           'Princípios de usabilidade, pesquisa com usuários e prototipação.',        40, 'Design'),
(5, 'Gestão de Projetos Ágeis',            'Scrum, Kanban e rituais ágeis aplicados a equipes pequenas.',             30, 'Gestão'),
(6, 'Marketing Digital',                   'Conteúdo, redes sociais, SEO e análise de métricas.',                     45, 'Marketing'),
(7, 'Inglês para Entrevistas e Carreira',  'Vocabulário, simulações de entrevista e escrita de e-mails profissionais.', 50, 'Idiomas'),
(8, 'Análise de Dados com Python',         'Limpeza, exploração e visualização de dados com Pandas.',                 60, 'Dados');

insert into sala_de_aula (id, titulo, conteudo, id_curso) values
(1,  'Fundamentos de Java',                    'Variáveis, tipos, condicionais e laços de repetição.',          1),
(2,  'Orientação a Objetos em Java',           'Classes, objetos, herança, polimorfismo e interfaces.',         1),
(3,  'Modelagem e SQL Básico',                 'MER, modelo relacional, CREATE TABLE, INSERT e SELECT.',        2),
(4,  'Consultas Avançadas no PostgreSQL',      'JOINs, subconsultas, agregações e views.',                      2),
(5,  'APIs REST com Node.js e Express',        'Rotas, middlewares, controllers e persistência de dados.',      3),
(6,  'TypeScript no Back-end',                 'Tipagem estática, interfaces e organização de projetos.',       3),
(7,  'Princípios de UX',                       'Heurísticas de usabilidade e jornada do usuário.',              4),
(8,  'Prototipação no Figma',                  'Wireframes, componentes e protótipos navegáveis.',              4),
(9,  'Scrum na Prática',                       'Papéis, eventos e artefatos do Scrum.',                         5),
(10, 'Marketing de Conteúdo e Redes Sociais',  'Planejamento editorial e métricas de engajamento.',             6),
(11, 'Inglês para Entrevistas de Emprego',     'Perguntas comuns, respostas modelo e simulações.',              7),
(12, 'Análise Exploratória com Pandas',        'Leitura de dados, limpeza e estatísticas descritivas.',         8);

insert into atividade (id, titulo, descricao, dt_inicio, dt_fim, nota, nota_maxima, id_sala_de_aula, id_aluno) values
(1,  'Exercício: Hello World e variáveis',     'Criar programas simples usando variáveis e entrada de dados.',      '2026-03-02 08:00:00', '2026-03-09 23:59:00',  9.50, 10.00,  1, 1),
(2,  'Lista de exercícios sobre laços',        'Resolver 10 problemas usando for e while.',                         '2026-03-10 08:00:00', '2026-03-17 23:59:00',  8.00, 10.00,  1, 4),
(3,  'Projeto: Sistema de Biblioteca',         'Implementar um cadastro de livros usando orientação a objetos.',    '2026-04-06 08:00:00', '2026-04-27 23:59:00', 17.50, 20.00,  2, 2),
(4,  'Modelagem do banco de uma loja',         'Criar o MER e o MR de uma loja virtual.',                           '2026-05-04 08:00:00', '2026-05-18 23:59:00', 18.00, 20.00,  3, 3),
(5,  'Lista de consultas com JOIN',            'Escrever consultas com INNER JOIN e LEFT JOIN.',                    '2026-06-01 08:00:00', '2026-06-08 23:59:00',  9.00, 10.00,  4, 10),
(6,  'Criação de API de tarefas',              'Construir uma API REST de lista de tarefas com Express.',           '2026-08-03 08:00:00', '2026-08-24 23:59:00', 27.00, 30.00,  5, 8),
(7,  'Migração de JavaScript para TypeScript', 'Converter um projeto existente adicionando tipagem.',               '2026-08-31 08:00:00', '2026-09-07 23:59:00', 24.50, 30.00,  6, 4),
(8,  'Análise heurística de um aplicativo',    'Avaliar um app usando as 10 heurísticas de Nielsen.',               '2026-07-06 08:00:00', '2026-07-13 23:59:00',  8.50, 10.00,  7, 5),
(9,  'Protótipo de tela de login',             'Criar um protótipo navegável de uma tela de login no Figma.',       '2026-07-20 08:00:00', '2026-07-27 23:59:00',  9.00, 10.00,  8, 9),
(10, 'Planejamento de uma Sprint',             'Montar o backlog e o planejamento de uma Sprint de 2 semanas.',     '2026-09-14 08:00:00', '2026-09-21 23:59:00',  7.50, 10.00,  9, 6),
(11, 'Calendário de conteúdo mensal',          'Planejar 30 dias de postagens para uma marca fictícia.',            '2026-09-07 08:00:00', '2026-09-14 23:59:00',  9.00, 10.00, 10, 5),
(12, 'Simulação de entrevista em inglês',      'Gravar uma entrevista simulada respondendo 5 perguntas.',           '2026-10-05 08:00:00', '2026-10-12 23:59:00',  8.00, 10.00, 11, 7),
(13, 'Limpeza de dataset com Pandas',          'Tratar valores nulos e duplicados em um conjunto de dados real.',   '2026-10-26 08:00:00', '2026-11-09 23:59:00', null, 20.00, 12, 3),
(14, 'Quiz de revisão de Java',                'Questionário de revisão para a turma.',                             '2026-11-02 08:00:00', '2026-11-09 23:59:00', null, 10.00,  1, null),
(15, 'Desafio de modelagem DER',               'Modelar o banco de uma clínica veterinária.',                       '2026-11-09 08:00:00', '2026-11-23 23:59:00', null, 20.00,  3, null);


insert into certificado (id, titulo, dt_emissao, carga_horaria, id_aluno) values
(1,  'Introdução à Programação com Java',  '2026-06-20', 60, 1),
(2,  'Banco de Dados com PostgreSQL',      '2026-08-15', 40, 1),
(3,  'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 1),
(4,  'Introdução à Programação com Java',  '2026-06-20', 60, 2),
(5,  'Desenvolvimento Web com Node.js',    '2026-09-10', 80, 2),
(6,  'Gestão de Projetos Ágeis',           '2026-07-05', 30, 2),
(7,  'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 2),
(8,  'Banco de Dados com PostgreSQL',      '2026-08-15', 40, 3),
(9,  'Gestão de Projetos Ágeis',           '2026-07-05', 30, 3),
(10, 'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 3),
(11, 'Desenvolvimento Web com Node.js',    '2026-09-10', 80, 4),
(12, 'Design de Interfaces e UX',          '2026-08-28', 40, 5),
(13, 'Marketing Digital',                  '2026-09-20', 45, 5),
(14, 'Workshop de Currículo e LinkedIn',   '2026-05-18',  8, 5),
(15, 'Gestão de Projetos Ágeis',           '2026-07-05', 30, 5),
(16, 'Inglês para Entrevistas e Carreira', '2026-10-20', 50, 7),
(17, 'Desenvolvimento Web com Node.js',    '2026-09-10', 80, 8),
(18, 'Marketing Digital',                  '2026-09-20', 45, 9);


insert into publicacao (id, titulo, conteudo, dt_publicacao, id_usuario) values
(1,  'Dicas para começar em Java',                  'Comece pelos fundamentos: variáveis, laços e orientação a objetos. Pratique todos os dias, mesmo que seja por 30 minutos.', '2026-03-05 10:15:00', 11),
(2,  'Por que aprender PostgreSQL?',                'O PostgreSQL é gratuito, robusto e muito usado no mercado. Dominar SQL abre portas em quase qualquer área de tecnologia.', '2026-03-12 09:40:00', 12),
(3,  'Meu primeiro projeto em Java',                'Finalizei meu sistema de biblioteca! Foi desafiador entender herança, mas valeu muito a pena.',                            '2026-04-20 19:05:00', 1),
(4,  'UX e carreira: por onde começar',             'Estude usabilidade, monte um portfólio com 3 estudos de caso e peça feedback de outras pessoas da área.',                '2026-05-08 11:20:00', 13),
(5,  'Como montar um currículo que chama atenção',  'Seja objetivo, destaque projetos e resultados e adapte o currículo para cada vaga.',                                      '2026-05-15 08:30:00', 14),
(6,  'O que aprendi no curso de UX',                'Aprendi que o usuário nunca é igual a nós. Testar com pessoas reais mudou completamente meu protótipo.',                  '2026-08-30 20:10:00', 5),
(7,  'Novidades da plataforma Mapa Carreiras',      'Chegaram os jogos educativos e a nova área de vagas de estágio. Explore e conte para a gente o que achou!',               '2026-09-01 09:00:00', 16),
(8,  'Procuro grupo de estudo de Node.js',          'Alguém quer montar um grupo para estudar APIs REST aos fins de semana?',                                                  '2026-09-14 21:45:00', 2),
(9,  'Preparação para entrevistas em inglês',       'Treine as respostas em voz alta e grave a si mesmo. Perceber os próprios erros acelera muito o aprendizado.',             '2026-10-20 15:00:00', 15),
(10, 'Vagas de estágio: o que as empresas esperam', 'Além da parte técnica, as empresas valorizam comunicação, vontade de aprender e trabalho em equipe.',                  '2026-10-22 10:00:00', 14),
(11, 'Dúvida sobre JOIN no PostgreSQL',             'Alguém consegue explicar a diferença entre INNER JOIN e LEFT JOIN com um exemplo simples?',                               '2026-10-23 18:25:00', 8),
(12, 'Manutenção programada',                       'A plataforma ficará indisponível no sábado, das 02h às 04h, para manutenção.',                                            '2026-10-25 08:00:00', 17),
(13, 'Dica de Ouro para Portfólio',  'Suba seus códigos para o GitHub com um README bem documentado, pois isso ajuda muito os recrutadores de TI experientes e exigentes. ', '2026-10-27 14:00:00', 16),
(14, 'Dica de Lógica de Programação','Resolva pequenos desafios em plataformas como LeetCode ou HackerRank diariamente para ganhar bastante agilidade mental na programação moderna.', '2026-10-27 15:30:00', 11),
(15, 'Oportunidade de Networking',  'Participe de meetups e comunidades de tecnologia para ser lembrado pelo mercado e criar boas conexões profissionais valiosas hoje. ', '2026-10-27 16:00:00', 12);

insert into mensagem (id, texto, dt_hora_envio, id_destinatario, id_remetente) values
(1,  'Professor, posso entregar o projeto final com um dia de atraso?',                 '2026-09-12 14:32:00', 11, 1),
(2,  'Pode sim, Ana. Só me avise até amanhã cedo.',                                      '2026-09-12 16:10:00', 1,  11),
(3,  'Professora, o material de consultas com JOIN já está disponível?',                '2026-09-15 09:05:00', 12, 2),
(4,  'Já está na sala, Lucas. Qualquer dúvida é só chamar.',                             '2026-09-15 11:47:00', 2,  12),
(5,  'Ana, você tem as anotações da aula de SQL?',                                       '2026-09-18 20:15:00', 1,  3),
(6,  'Tenho sim, te mando hoje à noite.',                                                '2026-09-18 20:40:00', 3,  1),
(7,  'Isabela, seu portfólio ficou ótimo. Vale se candidatar à vaga de marketing.',      '2026-09-22 13:00:00', 5,  14),
(8,  'Obrigada, professor! Já enviei minha candidatura.',                                '2026-09-22 13:25:00', 14, 5),
(9,  'Olá, Juliana! Seu cadastro de professora está em análise.',                        '2026-10-16 10:00:00', 15, 16),
(10, 'Obrigada! Já enviei os documentos solicitados.',                                   '2026-10-16 10:30:00', 16, 15),
(11, 'Gabriel, bora estudar para a prova de APIs amanhã?',                               '2026-10-20 19:50:00', 4,  8),
(12, 'Bora! Que tal às 19h?',                                                            '2026-10-20 20:05:00', 8,  4),
(13, 'Camila, sua prototipação ficou muito boa.',                                        '2026-10-21 15:30:00', 9,  13),
(14, 'Professora, posso revisar a atividade de JOIN?',                                   '2026-10-24 17:10:00', 12, 10);


insert into vaga (id, titulo, descricao, requisitos, status, dt_emissao, dt_publicacao, id_professor) values
(1, 'Estagiário(a) de Desenvolvimento Java',  'Desenvolvimento e manutenção de sistemas web em Java.',      'Java básico, SQL, Git, cursando Computação ou áreas afins.', 'aberta',     '2026-09-01', '2026-09-02 09:00:00', 1),
(2, 'Estagiário(a) de Dados e BI',            'Apoio na criação de dashboards e análises de dados.',        'SQL, Excel e noções de Python.',                              'aberta',     '2026-09-10', '2026-09-11 10:00:00', 2),
(3, 'Estágio em UX/UI Design',                'Apoio no desenho e teste de interfaces.',                    'Figma, noções de usabilidade e portfólio.',                   'encerrada',  '2026-07-15', '2026-07-16 08:30:00', 3),
(4, 'Assistente de Marketing Digital',        'Criação de conteúdo e acompanhamento de métricas.',          'Redes sociais, redação e noções de SEO.',                     'aberta',     '2026-09-05', '2026-09-06 14:00:00', 4),
(5, 'Desenvolvedor(a) Node.js Júnior',        'Desenvolvimento de APIs REST com Node.js e PostgreSQL.',     'Node.js, TypeScript, Express, SQL e Git.',                    'aberta',     '2026-10-01', '2026-10-02 09:30:00', 1),
(6, 'Analista de Dados Júnior',               'Limpeza e análise de dados com Python e SQL.',               'Python, Pandas, SQL e estatística básica.',                   'em análise', '2026-10-12', '2026-10-13 11:00:00', 2),
(7, 'Trainee em Gestão de Projetos',          'Acompanhamento de sprints e rituais ágeis.',                 'Scrum, boa comunicação e inglês intermediário.',              'aberta',     '2026-10-15', '2026-10-16 08:00:00', 4),
(8, 'Estagiário(a) de Suporte e Infraestrutura', 'Atendimento a chamados técnicos e suporte ao usuário.', 'Noções de redes, sistemas , hardware básico e vontade de aprender.', 'aberta', '2026-10-25', '2026-10-26 09:00:00', 1),
(9, 'Desenvolvedor(a) Front-End Júnior', 'Desenvolvimento de interfaces responsivas usando HTML, JavaScript, e react.', 'Cursando Superior em TI, conhecimento básico de Git.', 'aberta', '2026-10-26', '2026-10-27 10:00:00', 2),
(10, 'Analista de Dados Trainee', 'Auxílio na criação de relatórios, dashboards e tratamento de dados com SQL e Python.', 'Familiaridade com bancos de dados relacionais.  ', 'aberta', '2026-10-26', '2026-10-27 11:30:00', 3);

insert into jogo (id, nome, descricao, categoria, pontuacao_maxima, id_curso) values
(1, 'Java Challenge',    'Quiz com perguntas de lógica e sintaxe em Java.',            'Quiz',              100, 1),
(2, 'SQL Detective',     'Resolva casos escrevendo consultas SQL para achar pistas.',  'Puzzle',            150, 2),
(3, 'API Builder Race',  'Monte rotas de uma API o mais rápido possível.',             'Desafio de código', 200, 3),
(4, 'UX Match',          'Jogo da memória com conceitos e heurísticas de UX.',         'Memória',            80, 4),
(5, 'Scrum Simulator',   'Simule uma Sprint tomando decisões como Scrum Master.',      'Simulação',         120, 5),
(6, 'Interview Ninja',   'Responda perguntas de entrevista em inglês contra o tempo.', 'Simulação',         100, 7);


insert into prof_espec (id_professor, id_especializacao) values
(1, 1), (1, 2),
(2, 2), (2, 1),
(3, 3),
(4, 4),
(5, 4);

insert into professor_formacao (id_professor, id_formacao) values
(1, 1), (1, 5),
(2, 2), (2, 6),
(3, 3),
(4, 4), (4, 6),
(5, 5);

insert into curso_professor (id_professor, id_curso) values
(1, 1), (1, 3),
(2, 2), (2, 8),
(3, 4),
(4, 5), (4, 6), (4, 7),
(5, 7);

insert into aluno_vaga (id_aluno, id_vaga) values
(1, 1), (1, 5),
(2, 1), (2, 5),
(3, 2), (3, 6),
(4, 5),
(5, 3), (5, 4),
(6, 7),
(7, 4),
(8, 1), (8, 5),
(9, 4),
(10, 2);

insert into aluno_jogo (id_aluno, id_jogo, pontuacao) values
(1, 1,  90),
(1, 2, 120),
(2, 1,  85),
(2, 3, 160),
(3, 2, 140),
(4, 1,  70),
(4, 3, 180),
(5, 4,  75),
(6, 5, 100),
(7, 6,  90),
(8, 3, 150),
(9, 4,  60),
(9, 5, 110),
(10, 2, 95);

insert into aluno_jogo (id_aluno, id_jogo) values
(10, 6);

insert into aluno_sala (id_aluno, id_sala_de_aula) values
(1, 1),  (1, 2),  (1, 3),
(2, 1),  (2, 2),  (2, 5),
(3, 3),  (3, 4),  (3, 12),
(4, 1),  (4, 5),  (4, 6),
(5, 7),  (5, 8),  (5, 10),
(6, 9),  (6, 10), (6, 11),
(7, 7),  (7, 11), (7, 12),
(8, 3),  (8, 5),  (8, 6),
(9, 8),  (9, 9),  (9, 10),
(10, 4), (10, 11), (10, 12);


insert into publi_comenta (id_usuario, id_publicacao) values
(1, 1),  (2, 1),  (4, 1),
(3, 2),  (8, 2),  (10, 2),
(11, 3), (2, 3),
(5, 4),  (9, 4),
(1, 5),  (5, 5),  (7, 5),
(13, 6), (6, 6),
(2, 7),  (14, 7),
(4, 8),  (11, 8),
(6, 9),  (7, 9),
(8, 10), (1, 10),
(12, 11), (4, 11),
(3, 12);
