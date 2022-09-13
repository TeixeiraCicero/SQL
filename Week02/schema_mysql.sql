create schema brh;
use brh;

create table papel (
	id bigint not null auto_increment,
	nome varchar(255) not null,
	constraint pk_papel primary key (id),
	constraint papel_unico unique (nome)
);

create table departamento (
	sigla varchar(6) not null,
	nome varchar (255) not null,
	chefe varchar(10) not null,
	departamento_superior varchar(6),
	constraint pk_departamento primary key (sigla),
	constraint fk_departamento_superior
		foreign key (departamento_superior)
		references departamento (sigla)
);

create table cep_colab (
	cep varchar(10) not null,
	estado char(2) not null,
	cidade varchar(255) not null,
	constraint pk_endereco primary key (cep)
);

create table colaborador (
	matricula varchar(10) not null,
	email_corporativo varchar(255) not null,
    cep varchar(10) not null,
	complemento_endereco varchar(255),
	cpf varchar(14) not null,
	departamento varchar(6),
	constraint pk_colaborador primary key (matricula),
	constraint fk_departamento_colaborador
		foreign key (departamento)
		references departamento (sigla),
	constraint fk_cep_colab
		foreign key (cep)
		references cep_colab (cep)
);

create table info_colab (
	cpf varchar(14) not null,
	nome varchar(255) not null,
	salario decimal(10,2) not null,
	email_pessoal varchar(255) not null,
    constraint fk_telefone_colaborador
		foreign key (cpf)
		references colaborador (matricula)
);
create table telefone_colaborador(
	numero varchar(20) not null,
    matricula varchar(10) not null,
	tipo char(1) not null default 'R',
	constraint pk_telefone primary key (matricula, numero),
	constraint fk_telefone_colab
		foreign key (matricula)
		references colaborador (matricula),
	constraint tipo_telefone_valido check (tipo in ('R', 'M', 'C')) -- Residencial, Móvel, Corporativo
);

create table dependente(
	cpf char(14) not null,
	matricula varchar(10) not null,
	nome varchar(255) not null,
	data_nascimento date not null,
	parentesco varchar(20) not null,
	constraint pk_dependente primary key (cpf),
	constraint fk_dependente_colaborador
		foreign key (matricula)
		references colaborador (matricula),
	constraint parentesco_valido check (parentesco in ('Cônjuge', 'Filho(a)', 'Pai', 'Mãe'))
);

create table projeto (
	id bigint not null auto_increment,
	nome varchar(255) not null,
	responsavel varchar(10),
	inicio date not null,
	fim date,
	constraint pk_projeto primary key (id),
	constraint fk_colaborador_projeto
		foreign key (responsavel)
		references colaborador (matricula),
	constraint projeto_unico unique (nome)
);

create table atribuicao (
	colaborador varchar(10) not null,
	projeto bigint not null,
	papel bigint not null,
	constraint pk_atribuicao primary key (colaborador, projeto, papel)
);

alter table departamento add constraint fk_chefe_departamento
	foreign key (chefe) references colaborador (matricula);
	
