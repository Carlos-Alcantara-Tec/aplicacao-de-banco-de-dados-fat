/*=====================================================
ANALISE AVANCADA LOL (MYSQL)
SOMENTE FAZER AS CONSULTAS
===================================================== */

 Use lol_analytics;
/* =====================================================
NIVEL 1 – EASY MODE
===================================================== */
 
/* 1) Liste todos os campeoes ordenados pelo ano de lancamento (mais antigo primeiro) */
 
 SELECT nome_campeao from campeao order by ano_lancamento asc;
 
/* 2) Mostre os jogadores que possuem idade maior que 25 anos */
 

 select nickname, idade from jogador where idade > 25;
 
/* =====================================================
NIVEL 2 – INTERMEDIARIO
===================================================== */
 
/* 3) Calcule a media de ouro ganho por jogador */
 

 select 
	jogador.nickname,
	avg(es.ouro_ganho) as media_ouro
from estatistica_jogo as es
join jogador on es.id_jogador = jogador.id_jogador
group by jogador.nickname having avg(es.ouro_ganho) > (select avg(ouro_ganho) from estatistica_jogo);

  
/* 4) Mostre a maior duracao de partida ja registrada */

 select MAX(duracao_min)from partida;
 
/* 5) Liste os times que nunca venceram nenhuma partida */
 
 
 select
	tl.nome_time
    from time_lol as tl
    left join partida as p on tl.id_time = p.time_vencedor
    where time_vencedor is null;
 
/* =====================================================
NIVEL 3 – HARD MODE
===================================================== */
 
/* 6) Mostre os jogadores que tiveram mais de 10 kills em alguma partida */
 
 select 
	jogador.nickname,
    es.kills
from estatistica_jogo as es
join jogador on es.id_jogador = jogador.id_jogador
where es.kills > 10;
 
/* 7) Calcule a media de torres destruidas por time */
 
select
	time_lol.nome_time,
    avg(metrica_time.torres_destruidas)
from time_lol
join metrica_time on time_lol.id_time = metrica_time.id_time
group by time_lol.nome_time 
having avg(metrica_time.torres_destruidas) > (select avg(torres_destruidas) from metrica_time);

/* 8) Liste os campeoes que nunca foram utilizados em nenhuma partida */
 
 select 
	c.nome_campeao
from campeao as c
left join estatistica_jogo as es on c.id_campeao = es.id_campeao
 where  es.id_campeao is null;
 
/* =====================================================
NIVEL 4 – ELITE
===================================================== */
 
/* 9) Encontre os jogadores cujo dano medio seja maior que a media geral de dano */
 
 
 Select 
	j.nickname as Jogador,
    avg(es.dano_total) as TotalDano
 From jogador as j
 Join estatistica_jogo as es on es.id_jogador = j.id_jogador
 group by jogador having TotalDano > (Select avg(dano_total) from estatistica_jogo);
 
/* 10) Calcule a media de dragoes por partida e mostre apenas as paridats acima dessa media */
 
 select 
	id_partida,
    avg(dragoes)
from metrica_time
group by id_partida having avg(dragoes) > (select avg(dragoes) from metrica_time);
 
/* =====================================================
NIVEL 5 – GIGACHAD MODE 🔥
===================================================== */
 
/* 11) Monte um ranking de impacto por jogador usando*/
 
select 
j.nickname as jogador,
(AVG(es.kills) * 0.5) + (AVG(es.assists) * 0.3) - (AVG(es.deaths) * 0.2) as Impacto
from jogador as j
join estatistica_jogo as es on es.id_jogador = j.id_jogador
group by jogador 
order by Impacto desc;

 
 
/* 12) Descubra qual time tem melhor eficiencia de objetivo:*/

select
	tl.nome_time as Time,
    round(((AVG(mt.dragoes) + AVG(mt.barons)) / AVG(pt.duracao_min)) * 100, 2) AS Eficiencia
from time_lol as tl
join metrica_time as mt on mt.id_time = tl.id_time
join partida as pt on pt.time_vencedor = tl.id_time
group by Time 
order by Eficiencia desc;
    
    
