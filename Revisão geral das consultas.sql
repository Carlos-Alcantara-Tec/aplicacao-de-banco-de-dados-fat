/* =====================================================
REVISAO COMPLETA – MYSQL – ANALISE LOL
===================================================== */
 
 
/* =====================================================
PARTE 1 – O QUE E CADA COMANDO
===================================================== */
 
/*
WHERE
Filtra registros com base em uma condicao.
Ex: WHERE idade > 20
------------------------------------------------------
 
AND / OR
AND exige que todas as condicoes sejam verdadeiras.
OR exige que pelo menos uma seja verdadeira.
------------------------------------------------------
 
IN
Filtra valores dentro de uma lista.
Ex: WHERE regiao IN ('KR','BR')
------------------------------------------------------
 
BETWEEN
Filtra valores dentro de um intervalo.
Ex: WHERE idade BETWEEN 20 AND 30
------------------------------------------------------
 
LIKE
Busca padroes de texto.
% = qualquer coisa
_ = um caractere
Ex: WHERE nome LIKE '%a%'
------------------------------------------------------
 
ORDER BY
Ordena resultados.
ASC = crescente
DESC = decrescente
------------------------------------------------------
 
GROUP BY
Agrupa dados para usar funcoes de agregacao.
------------------------------------------------------
 
HAVING
Filtra resultados depois do GROUP BY.
------------------------------------------------------
 
DISTINCT
Remove valores duplicados.
------------------------------------------------------
 
LIMIT
Limita quantidade de resultados.
------------------------------------------------------
 
OFFSET
Pula registros antes de mostrar resultados.
------------------------------------------------------
 
Alias (AS)
Renomeia colunas temporariamente.
Ex: AVG(kills) AS media_kills
------------------------------------------------------
 
FUNCOES NUMERICAS
ROUND()  -> arredonda
CEIL()   -> arredonda para cima
FLOOR()  -> arredonda para baixo
ABS()    -> valor absoluto
------------------------------------------------------
 
FUNCOES TEXTO
CONCAT()     -> junta textos
LOWER()      -> minusculo
UPPER()      -> maiusculo
LENGTH()     -> tamanho do texto
SUBSTRING()  -> extrai parte do texto
TRIM()       -> remove espacos
------------------------------------------------------
 
FUNCOES DATA
NOW()       -> data e hora atual
CURDATE()   -> data atual
DATEDIFF()  -> diferenca entre datas
DATE_ADD()  -> adiciona dias
DATE_SUB()  -> subtrai dias
------------------------------------------------------
 
FUNCOES AGREGACAO
COUNT() -> conta registros
SUM()   -> soma
AVG()   -> media
MAX()   -> maior valor
MIN()   -> menor valor
------------------------------------------------------
 
JOIN
Une tabelas relacionadas.
------------------------------------------------------
 
SUBQUERY
Uma consulta dentro de outra consulta.
*/
 
 
/* =====================================================
PARTE 2 – DEVERES (FAZER SOMENTE AS CONSULTAS)
===================================================== */
 
 use lol_analytics;
/* 1) Liste jogadores Challenger com idade entre 20 e 27.
   Ordene do mais velho para o mais novo.
*/
 

 select
	nickname,
    idade,
    rank_atual
from 
	jogador
where 
	rank_atual = "Challenger"
and 
	idade between 20 and 27
order by 
	idade desc;
 
/* 2) Mostre campeoes cujo nome contenha 'a'
   e que foram lancados entre 2010 e 2020.
   Exiba o nome em MAIUSCULO.
*/
 
 select 
	upper(nome_campeao),
    ano_lancamento
from
	campeao
where 
	nome_campeao like "%a%" 
	and 
		ano_lancamento between 2010 and 2020
order by 
	ano_lancamento desc;


 
/* 3) Liste DISTINCT regioes da tabela de times.
*/
 
 
select 
	distinct(regiao)	 
from 
	time_lol;
 
/* 4) Mostre os 5 jogadores com maior media de dano,
   pulando os 2 primeiros.
*/
 

 select 
	j.nickname as Jogador,
    avg(dano_total) as "Dano Total"
from 
	jogador as j
join 
	estatistica_jogo as es on es.id_jogador = j.id_jogador
group by 
	j.nickname
order by 
	"Dano Total" desc
limit 5 
offset 2;

/* 5) Mostre a media de duracao das partidas
   arredondada para cima.
*/
 

 select 
	ceil(avg(duracao_min)) as "Média de duração de partida" 
from  
	partida;
 
/* 6) Calcule o KDA medio por jogador:
   (kills + assists) / deaths
   Mostre apenas quem tem KDA maior que 3.
*/
 

 Select 
	j.nickname as Jogador,
	((es.kills + es.assists) / es.deaths) as KDA
 from 
	jogador as j
 join 
	estatistica_jogo as es on es.id_jogador = j.id_jogador;
 
 
/* 7) Liste partidas que aconteceram nos ultimos 30 dias.
   Mostre quantos dias se passaram desde cada partida.
*/
 

 select
	data_partida, 
	curdate() as "Data Atual",
    date_sub(curdate(), interval 30 day) as "1Mês atrás",
    datediff(curdate(), data_partida)
from 
	partida
where 
	datediff(curdate(), data_partida) <= 30;


    
 
/* 8) Liste os times com media de gold maior que 75000
   e media de torres maior que 8.
*/
 

 select
	tl.nome_time as "Nome do Time",
    avg(mt.gold_total) as "Media de Ouro"
from 
	time_lol as tl
join 
	metrica_time as mt on mt.id_time = tl.id_time
group by 
	tl.nome_time having avg(mt.gold_total) > 75000;

/* 9) Mostre jogadores cuja media de kills
   seja maior que a media geral de kills.
*/
 

 select 
	j.nickname,
    avg(es.kills) as kills
from 
	jogador as j
join 
	estatistica_jogo as es on es.id_jogador = j.id_jogador
group by 
	j.nickname 
having 
	kills > (select avg(kills) from estatistica_jogo);
 
/* 10) Monte um ranking de desempenho por time:*/
 

select 
	tl.nome_time, count(p.time_vencedor) 
from 
	time_lol as tl 
join 
	partida as p on p.time_vencedor = tl.id_time
group by 
	tl.nome_time; 

select 
	tl.nome_time,
    avg(es.kills) as Media_Kills,
    avg(mt.gold_total) as Media_Ouro,
    COUNT(p.time_vencedor),
	((AVG(es.kills) * 0.4) + (AVG(mt.gold_total)/1000 * 0.3) + (COUNT(p.time_vencedor) * 0.3)) as score
from 
	time_lol as tl 
join 
	partida as p on p.time_vencedor = tl.id_time
join 
	estatistica_jogo as es on es.id_partida = p.id_partida
join 
	metrica_time as mt on mt.id_time = tl.id_time
group by 
	tl.nome_time;
    
    
    
    
    
    