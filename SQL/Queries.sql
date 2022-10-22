SELECT P.RIOT_ID, M.NOME_MAPA, ((P.KILLS + P.ASSISTS)/P.DEATHS) AS KDA
FROM PARTICIPA P INNER JOIN PARTIDA M ON P.ID_PARTIDA = M.ID_PARTIDA
WHERE ((P.KILLS + P.ASSISTS)/P.DEATHS) >
      (SELECT (SUM(P1.KILLS) + SUM(P1.ASSISTS))/SUM(P1.DEATHS) AS AVG_KDA
       FROM PARTICIPA P1
       GROUP BY ID_PARTIDA
       HAVING P1.ID_PARTIDA = P.ID_PARTIDA);

-- Jogadores que não participaram de partidas, mas que possuem skins e amigos (sometimes it's about money and bitches)

-- Possuem | Participa | Amizade
-- 0 0 0 - Jano
-- 0 0 1 - Risky Business
-- 0 1 0 - MicroconsDelxs
-- 0 1 1 - Trap Pillow
-- 1 0 0 - Delaunay
-- 1 0 1 - kkmr
-- 1 1 0 - IBRAHIM
-- 1 1 1 - Renemoo

SELECT P.RIOT_ID AS 'Nome do ostentador', COUNT(P.SKIN_ID) AS 'Qtd. de skins', SUM(S.PRECO) AS 'VP gastos com skin'
FROM Possuem P INNER JOIN Skin S ON P.ID_SKIN = S.ID_SKIN
WHERE NOT EXISTS (
      SELECT *
      FROM Participa PA
      WHERE PA.RIOT_ID = P.RIOT_ID
) AND EXISTS (
      SELECT *
      FROM Amizade A
      WHERE (A.ADICIONA = P.RIOT_ID) OR (A.ADICIONADO = P.RIOT_ID)
)
GROUP BY P.RIOT_ID
