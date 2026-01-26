/* RhythmIQ: Macrotendencias y Dinámicas del Mainstream (2020–2024)

Este proyecto analiza las dinámicas estructurales del mainstream musical global entre 2020 y 2024 a través de la integración de métricas oficiales de Spotify 
y datos de comportamiento real de Last.fm. El objetivo es identificar macrotendencias, patrones de consumo, estrategias de mercado y cambios inducidos por eventos globales, 
con foco en los géneros Pop, Latin/Reggaetón, Indie y Hip-Hop. */

USE rhythmiq;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* BLOQUE I – DOMINIO DEL MAINSTREAM Y EVOLUCIÓN DEL CONSUMO:
Este bloque analiza quién domina el mainstream, cómo evoluciona esa dominancia en el tiempo y si el liderazgo algorítmico se traduce en consumo real. */

/* 1.1 ¿Cómo evoluciona la popularidad promedio de los principales géneros mainstream año a año (2020–2024)? */
SELECT 
    genre_extracted AS genero, 
    track_year AS año, 
    ROUND(AVG(track_popularity)) AS media_popularidad
FROM track
WHERE genre_extracted IN ('pop', 'latin', 'hip-hop', 'indie')
GROUP BY genre_extracted, track_year
ORDER BY genre_extracted ASC, track_year ASC;

/* Los datos de Hip-Hop no son concluyentes debido a una inconsistencia en la recolección desde la API de Spotify. 
Para efectos de este análisis, nos enfocaremos en la comparativa entre Pop, Latin e Indie, donde sí contamos con métricas de popularidad representativas.
Invertir en Pop y Latin es una apuesta segura por el volumen, pero el Indie es un nicho que está madurando rápidamente y ganando tracción comercial. */


/* 1.2 Artistas dominantes por género y año (oyentes reales) */
SELECT 
	artista, genero, año, media_oyentes
FROM (
    SELECT 
        a.artist_name AS artista, 
        t.genre_extracted AS genero, 
        t.track_year AS año, 
        ROUND(AVG(t.listeners)) AS media_oyentes, 
        ROW_NUMBER() OVER(PARTITION BY t.track_year, t.genre_extracted ORDER BY AVG(t.listeners) DESC) AS ranking
    FROM track_artist AS ta
    JOIN artist AS a ON ta.artist_id = a.artist_id
    JOIN track AS t ON ta.track_id = t.track_id
    WHERE t.track_year >= 2020 
      AND t.genre_extracted IN ('pop', 'latin', 'indie', 'hip-hop')
    GROUP BY t.track_year, t.genre_extracted, a.artist_name 
) AS subconsulta
WHERE ranking <= 5
ORDER BY genero, año DESC, media_oyentes DESC;

/* Pop mantiene un liderazgo estable con transición gradual hacia nuevos artistas.
Latin presenta alta rotación y liderazgo compartido entre artistas locales y globales.
Indie y Hip-Hop combinan engagement sostenido; el Indie renueva referentes, mientras el Hip-Hop repite líderes con baja rotación.*/


/* 1.3 Popularidad algorítmica vs consumo real */
SELECT
    genre_extracted AS genero,
    ROUND(AVG(playcount)) AS media_reproducciones,
    ROUND(AVG(track_popularity)) AS media_popularidad,
    ROUND(AVG(playcount) / ROUND(AVG(track_popularity), 2)) AS ratio_reproducciones_popularidad
FROM track
WHERE playcount IS NOT NULL
  AND track_popularity IS NOT NULL
  AND track_popularity > 0
GROUP BY genre_extracted
ORDER BY ratio_reproducciones_popularidad DESC;

/*Diferencias claras entre la popularidad algorítmica de Spotify y el consumo real medido por Last.fm. 
Mientras que el pop muestra una fuerte alineación entre ambas métricas, el género latino presenta una mayor visibilidad en Spotify en relación con su consumo real (Spotify sobre-representa 
este género). Indie mantiene una base de oyentes fiel con menor dependencia del empuje algorítmico. El caso del hip-hop evidencia limitaciones en la calidad de los datos, el resultado no es 
interpretable sin una limpieza adicional de los datos.*/


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* BLOQUE II – HIBRIDACIÓN, COLABORACIONES Y ESTRATEGIAS CREATIVAS: 
Este bloque estudia cómo la mezcla de géneros y las colaboraciones funcionan como palancas de alcance, engagement y expansión de audiencias.*/

/* 2.1 ¿Qué artistas operan en más de un macro-género? */
SELECT 
    a.artist_name AS artista, 
    COUNT(DISTINCT (
        CASE 
            WHEN g.genre_name LIKE '%pop%' THEN 'Pop'
            WHEN g.genre_name LIKE '%latin%' OR g.genre_name LIKE '%reggaeton%' OR g.genre_name LIKE '%urban%' OR g.genre_name LIKE '%cumbia%' OR g.genre_name LIKE '%bail%' OR g.genre_name LIKE '%guaracha%' OR g.genre_name LIKE '%champeta%' OR g.genre_name LIKE '%salsa%' OR g.genre_name LIKE '%bachata%' OR g.genre_name LIKE '%merengue%' OR g.genre_name LIKE '%vallenato%' OR g.genre_name LIKE '%mambo%' OR g.genre_name LIKE '%timba%' OR g.genre_name LIKE '%son cubano%' OR g.genre_name LIKE '%rkt%' OR g.genre_name LIKE '%turreo%' OR g.genre_name LIKE '%techengue%' OR g.genre_name LIKE '%dembow%' THEN 'Latin'
            WHEN g.genre_name LIKE '%hip%hop%' OR g.genre_name LIKE '%rap%' OR g.genre_name LIKE '%trap%' OR g.genre_name LIKE '%drill%' THEN 'Hip-Hop'
            WHEN g.genre_name LIKE '%indie%' OR g.genre_name LIKE '%alternative%' OR g.genre_name LIKE '%lo-fi%' OR g.genre_name LIKE '%shoegaze%' THEN 'Indie'
            ELSE 'Otros'
        END)) AS total_macro_generos,
    GROUP_CONCAT(DISTINCT (
        CASE 
            WHEN g.genre_name LIKE '%pop%' THEN 'Pop'
            WHEN g.genre_name LIKE '%latin%' OR g.genre_name LIKE '%reggaeton%' OR g.genre_name LIKE '%urban%' OR g.genre_name LIKE '%cumbia%' OR g.genre_name LIKE '%bail%' OR g.genre_name LIKE '%guaracha%' OR g.genre_name LIKE '%champeta%' OR g.genre_name LIKE '%salsa%' OR g.genre_name LIKE '%bachata%' OR g.genre_name LIKE '%merengue%' OR g.genre_name LIKE '%vallenato%' OR g.genre_name LIKE '%mambo%' OR g.genre_name LIKE '%timba%' OR g.genre_name LIKE '%son cubano%' OR g.genre_name LIKE '%rkt%' OR g.genre_name LIKE '%turreo%' OR g.genre_name LIKE '%techengue%' OR g.genre_name LIKE '%dembow%' THEN 'Latin'
            WHEN g.genre_name LIKE '%hip%hop%' OR g.genre_name LIKE '%rap%' OR g.genre_name LIKE '%trap%' OR g.genre_name LIKE '%drill%' THEN 'Hip-Hop'
            WHEN g.genre_name LIKE '%indie%' OR g.genre_name LIKE '%alternative%' OR g.genre_name LIKE '%lo-fi%' OR g.genre_name LIKE '%shoegaze%' THEN 'Indie'
            ELSE 'Otros'
        END) ORDER BY g.genre_name ASC SEPARATOR ' + ') AS mezcla_generos
FROM artist a
LEFT JOIN artist_genre ag ON a.artist_id = ag.artist_id
LEFT JOIN genre g ON g.genre_id = ag.genre_id
GROUP BY a.artist_name
HAVING total_macro_generos > 1
ORDER BY total_macro_generos DESC;


/*	2.2 ¿En qué géneros las colaboraciones son más frecuentes? */
SELECT 
    t.genre_extracted genero, 
    ROUND(AVG(t.playcount)) media_reproducciones, 
    SUM(t.collaboration) total_colaboraciones
FROM track t
WHERE t.collaboration = 1
GROUP BY genero
ORDER BY total_colaboraciones DESC;


/*	2.3 ¿Qué combinaciones de géneros generan mayor popularidad y engagement? */
SELECT 
    combinacion_generos,
    COUNT(*) AS cantidad_tracks,
    ROUND(AVG(playcount)) AS media_reproducciones,
    ROUND(AVG(track_popularity)) AS media_popularidad,
    ROUND(AVG(listeners)) AS media_oyentes
FROM (
   SELECT 
		t.track_id,
		t.playcount,
		t.track_popularity,
        t.listeners,
		GROUP_CONCAT(DISTINCT (
			CASE 
				WHEN g.genre_name LIKE '%pop%' THEN 'Pop'
				WHEN (g.genre_name LIKE '%latin%' OR g.genre_name LIKE '%reggaeton%' OR g.genre_name LIKE '%urban%' OR g.genre_name LIKE '%cumbia%' OR g.genre_name LIKE '%guaracha%' OR g.genre_name LIKE '%salsa%' OR g.genre_name LIKE '%bachata%' OR g.genre_name LIKE '%merengue%' OR g.genre_name LIKE '%vallenato%' OR g.genre_name LIKE '%rkt%' OR g.genre_name LIKE '%turreo%' OR g.genre_name LIKE '%dembow%') THEN 'Latin'
				WHEN (g.genre_name LIKE '%hip%hop%' OR g.genre_name LIKE '%rap%' OR g.genre_name LIKE '%trap%' OR g.genre_name LIKE '%drill%') THEN 'Hip-Hop'
				WHEN (g.genre_name LIKE '%indie%' OR g.genre_name LIKE '%alternative%' OR g.genre_name LIKE '%lo-fi%' OR g.genre_name LIKE '%shoegaze%') THEN 'Indie'
			END) ORDER BY g.genre_name ASC SEPARATOR ' + ') AS combinacion_generos
    FROM track t
    INNER JOIN track_artist ta ON t.track_id = ta.track_id
    INNER JOIN artist_genre ag ON ta.artist_id = ag.artist_id
    INNER JOIN genre g ON ag.genre_id = g.genre_id
    WHERE t.track_popularity > 0
    GROUP BY t.track_id, t.playcount, t.track_popularity, t.listeners
) AS sub
WHERE combinacion_generos IS NOT NULL
	AND combinacion_generos LIKE '%+%'
GROUP BY combinacion_generos
ORDER BY media_reproducciones DESC;


/*	2.4 Impacto de las colaboraciones en el engagement */
SELECT 
    t.genre_extracted AS genero_principal,
    ROUND(AVG(CASE WHEN t.collaboration = 1 THEN t.listeners END)) AS media_oyentes_colaboracion,
    ROUND(AVG(CASE WHEN t.collaboration = 0 THEN t.listeners  END)) AS media_oyentes_solitario,
    ROUND(AVG(CASE WHEN t.collaboration = 1 THEN t.listeners  END) - 
          AVG(CASE WHEN t.collaboration = 0 THEN t.listeners  END)) AS incremento_por_colab,
    COUNT(DISTINCT CASE WHEN t.collaboration = 1 THEN t.track_id END) AS total_colaboraciones
FROM track t
GROUP BY t.genre_extracted
ORDER BY incremento_por_colab DESC;


/* 2.5 TOP10 colaboraciones que han producido mayor engagement? */
WITH track_max AS (
    SELECT
        t.track_name,
        a.artist_name AS artista_principal,
        t.playcount,
        t.track_popularity,
        t.listeners,
        ROW_NUMBER() OVER (PARTITION BY a.artist_name, LEFT(t.track_name, POSITION('(' IN t.track_name || '(') - 1)
            ORDER BY t.playcount DESC) AS rn
    FROM track t
    INNER JOIN track_artist ta
        ON t.track_id = ta.track_id AND ta.is_main_artist = 1
    INNER JOIN artist a
        ON ta.artist_id = a.artist_id
    WHERE t.collaboration = 1
)
SELECT
    track_name AS track,
    artista_principal AS artista_principal,
    playcount AS reproducciones,
    track_popularity AS popularidad,
    listeners AS oyentes
FROM track_max
WHERE rn = 1
ORDER BY reproducciones DESC
LIMIT 10;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* BLOQUE III – INDUSTRIA, DISTRIBUCIÓN Y PODER DE MERCADO: 
Este bloque examina cómo la industria estructura el mainstream: formatos de lanzamiento y control por grandes discográficas. */

/* 3.1 ¿Qué formatos dominan el lanzamiento de música mainstream? */
SELECT
    t.genre_extracted AS genero,
    a.album_type AS formato_lanzamiento,
    COUNT(DISTINCT a.album_id) AS num_lanzamientos
FROM album a
JOIN track t ON a.album_id = t.album_id
GROUP BY t.genre_extracted, a.album_type
ORDER BY t.genre_extracted, num_lanzamientos DESC;


/* 3.2 ¿Qué discográficas (label) concentran la producción por género? */
SELECT
    CASE
        WHEN a.label LIKE '%Sony%' THEN 'Sony Music'
        WHEN a.label LIKE '%Universal%'
          OR a.label LIKE '%UMG%'
          OR a.label LIKE '%Capitol%'
          OR a.label LIKE '%Polydor%'
          OR a.label LIKE '%Def Jam%'
          OR a.label LIKE '%EMI%' THEN 'Universal Music Group'
        WHEN a.label LIKE '%Warner%'
          OR a.label LIKE '%WEA%'
          OR a.label LIKE '%Atlantic%'
          OR a.label LIKE '%Elektra%'
          OR a.label LIKE '%Parlophone%'
          OR a.label LIKE '%Rhino%' THEN 'Warner Music Group'
        ELSE 'Independent / Other'
    END AS grupo_discografica,
    t.genre_extracted AS genero,
    COUNT(t.track_id) AS num_tracks
FROM album a
JOIN track t ON a.album_id = t.album_id
GROUP BY grupo_discografica, genero
ORDER BY num_tracks DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* BLOQUE IV – CONTEXTO GLOBAL, EVENTOS Y VIRALIDAD: 
Este bloque conecta el consumo musical con eventos globales, shocks culturales y dinámicas de viralidad. */

/* 4.1 ¿Cómo responden los géneros a eventos globales? */
SELECT
    t.track_year AS año,
    t.genre_extracted AS genero,
    ROUND(AVG(t.track_popularity), 2) AS media_popularidad,
    ROUND(AVG(t.listeners), 0) AS media_oyentes,
    ROUND(AVG(t.playcount), 0) AS media_reproducciones
FROM track AS t
GROUP BY t.track_year, t.genre_extracted
ORDER BY t.genre_extracted, t.track_year, media_popularidad DESC;


/* 4.2 Boom musical COVID vs PostCOVID */
SELECT
    t.genre_extracted AS genero,
    ROUND(MAX(CASE WHEN t.track_year BETWEEN 2020 AND 2021 THEN t.track_popularity END)) AS popularidad_peak_covid,
    ROUND(AVG(CASE WHEN t.track_year BETWEEN 2022 AND 2024 THEN t.track_popularity END)) AS popularidad_post_covid,
    ROUND(MAX(CASE WHEN t.track_year BETWEEN 2020 AND 2021 THEN t.track_popularity END)) - ROUND(AVG(CASE WHEN t.track_year BETWEEN 2022 AND 2024 THEN t.track_popularity END)) AS diferencia_popularidad,
	ROUND(MAX(CASE WHEN t.track_year BETWEEN 2020 AND 2021 THEN t.playcount END)) AS reproducciones_peak_covid,
    ROUND(AVG(CASE WHEN t.track_year BETWEEN 2022 AND 2024 THEN t.playcount END)) AS reproducciones_post_covid,
    ROUND(MAX(CASE WHEN t.track_year BETWEEN 2020 AND 2021 THEN t.playcount END)) - ROUND(AVG(CASE WHEN t.track_year BETWEEN 2022 AND 2024 THEN t.playcount END)) AS diferencia_reproducciones,
	ROUND(MAX(CASE WHEN t.track_year BETWEEN 2020 AND 2021 THEN t.listeners END)) AS oyentes_peak_covid,
    ROUND(AVG(CASE WHEN t.track_year BETWEEN 2022 AND 2024 THEN t.listeners END)) AS oyentes_post_covid,
    ROUND(MAX(CASE WHEN t.track_year BETWEEN 2020 AND 2021 THEN t.listeners END)) - ROUND(AVG(CASE WHEN t.track_year BETWEEN 2022 AND 2024 THEN t.listeners END)) AS diferencia_oyentes
FROM track t
GROUP BY t.genre_extracted
ORDER BY diferencia_reproducciones DESC;


/* 4.3 Mundial 2022: tendencias rápidas / virales */
SELECT
    t.genre_extracted genero,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.track_popularity END)) AS popularidad_pre_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.track_popularity END)) AS popularidad_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.track_popularity END)) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.track_popularity END)) AS diferencia_popularidad,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.playcount END)) AS reproducciones_pre_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.playcount END)) AS reproducciones_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.playcount END)) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.playcount END)) AS diferencia_reproducciones,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.listeners END)) AS oyentes_pre_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.listeners END)) AS oyentes_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.listeners END)) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (9,10) THEN t.listeners END)) AS diferencia_oyentes
FROM track t
WHERE YEAR(t.track_release_date) = 2022
GROUP BY t.genre_extracted
ORDER BY diferencia_reproducciones DESC;


/* 4.3.1 Géneros con peak de viralidad en el Mundial de 2022 vs resto del año*/ 
SELECT
    t.genre_extracted AS genero,
    MAX(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.track_popularity END) AS peak_popularidad_mundial,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) NOT IN (11,12) THEN t.track_popularity END)) AS media_popularidad_resto_2022,
    MAX(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.track_popularity END) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) NOT IN (11,12) THEN t.track_popularity END)) AS diferencia_popularidad,
    MAX(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.playcount END) AS peak_reproducciones_mundial,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) NOT IN (11,12) THEN t.playcount END), 0) AS media_reproducciones_resto_2022,
	MAX(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.playcount END) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) NOT IN (11,12) THEN t.playcount END), 0) AS diferencia_reproducciones,
	MAX(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.listeners END) AS peak_oyentes_mundial,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) NOT IN (11,12) THEN t.listeners END), 0) AS media_oyentes_resto_2022,
	MAX(CASE WHEN MONTH(t.track_release_date) IN (11,12) THEN t.listeners END) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) NOT IN (11,12) THEN t.listeners END), 0) AS diferencia_oyentes
FROM track t
WHERE YEAR(t.track_release_date) = 2022
GROUP BY t.genre_extracted
ORDER BY diferencia_reproducciones DESC;


/* 4.4 Eurovisión 2023: Evolución de metricas pre, durante y post evento */
SELECT
    t.genre_extracted AS genero,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (3,4) THEN t.track_popularity END), 2) AS popularidad_pre_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.track_popularity END), 2) AS popularidad_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (6,7) THEN t.track_popularity END), 2) AS popularidad_post_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (3,4) THEN t.playcount END), 0) AS reproducciones_pre_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.playcount END), 0) AS reproducciones_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (6,7) THEN t.playcount END), 0) AS reproducciones_post_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (3,4) THEN t.listeners END), 0) AS oyentes_pre_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.listeners END), 0) AS oyentes_eurovision,
	ROUND(AVG(CASE WHEN MONTH(t.track_release_date) IN (6,7) THEN t.listeners END), 0) AS oyentes_post_eurovision
FROM track t
WHERE YEAR(t.track_release_date) = 2023
GROUP BY t.genre_extracted
ORDER BY reproducciones_eurovision DESC;


/* 4.4.1 Géneros con peak de viralidad en Eurovisión 2023 vs resto del año */
SELECT
    t.genre_extracted AS genero,
    MAX(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.track_popularity END) AS peak_eurovision_popularidad,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) <> 5 THEN t.track_popularity END), 2) AS media_popularidad_resto_año,
    MAX(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.track_popularity END) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) <> 5 THEN t.track_popularity END), 2) AS diferencia_popularidad,
    MAX(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.playcount END) AS peak_eurovision_reproducciones,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) <> 5 THEN t.playcount END), 0) AS media_reproducciones_resto_año,
    MAX(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.playcount END) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) <> 5 THEN t.playcount END), 0) AS diferencia_reproducciones,
    MAX(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.listeners END) AS peak_eurovision_oyentes,
    ROUND(AVG(CASE WHEN MONTH(t.track_release_date) <> 5 THEN t.listeners END), 0) AS media_oyentes_resto_año,
    MAX(CASE WHEN MONTH(t.track_release_date) = 5 THEN t.listeners END) - ROUND(AVG(CASE WHEN MONTH(t.track_release_date) <> 5 THEN t.listeners END), 0) AS diferencia_oyentes
FROM track t
WHERE YEAR(t.track_release_date) = 2023
GROUP BY t.genre_extracted
ORDER BY diferencia_reproducciones DESC;


/* 4.5 Impacto de festivales musicales 2020–2024: Popularidad, Oyentes y Reproducciones por Género:
	Festivales musicales analizados: 
    Lollapalooza → marzo
	Coachella → abril
	Primavera Sound → junio
	Red Bull Batalla → diciembre*/
SELECT
    YEAR(t.track_release_date) AS año,
    MONTH(t.track_release_date) AS mes,
    t.genre_extracted AS genero,
    CASE
        WHEN MONTH(t.track_release_date) = 3 THEN 'Lollapalooza'
        WHEN MONTH(t.track_release_date) = 4 THEN 'Coachella'
        WHEN MONTH(t.track_release_date) = 6 THEN 'Primavera Sound'
        WHEN MONTH(t.track_release_date) = 12 THEN 'Red Bull Batalla'
        ELSE 'No Festival'
    END AS festival,
    ROUND(AVG(t.track_popularity), 2) AS media_popularidad,
    ROUND(AVG(t.listeners), 0) AS media_oyentes,
    ROUND(AVG(t.playcount), 0) AS media_reproducciones
FROM track t
WHERE t.track_release_date IS NOT NULL
GROUP BY año, mes, genero, festival
ORDER BY t.genre_extracted, año, mes;


/* 4.6 Géneros más virales 2020–2024: Reproducciones por oyente y potencial de picos*/
SELECT
    genre_extracted AS genero,
    ROUND(AVG(playcount / listeners), 2) AS reproducciones_por_oyente,
    ROUND(MAX(playcount / listeners)) AS peak_reproducciones_por_oyente,
    ROUND(MIN(playcount / listeners)) AS min_reproducciones_por_oyente,
    ROUND(MAX(playcount / listeners) - MIN(playcount / listeners), 2) AS rango_reproducciones_por_oyente
FROM track
WHERE playcount IS NOT NULL
  AND listeners IS NOT NULL
GROUP BY genre_extracted
ORDER BY reproducciones_por_oyente DESC;

/*Pop: “género explosivo”: canciones que pueden dispararse intensamente en pocos oyentes.
Latin: “viralidad concentrada”: algunos hits generan impacto fuerte, otros medianos.
Indie: “nicho estable con picos moderados”.
Hip-Hop: “consumo homogéneo, poca viralidad extrema”.*/


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* BLOQUE V – IDENTIDAD DE GÉNERO VS PERCEPCIÓN DEL OYENTE: 
Este bloque analiza la brecha entre clasificación oficial (Spotify) y percepción comunitaria (Last.fm) */

/* 5.1 ¿Coinciden los géneros oficiales con las etiquetas generadas por los oyentes? */
WITH track_tag_genero AS (
    SELECT 
        t.track_name AS track,
        t.genre_extracted AS genero,
        tag.tags AS tags
    FROM track t
    JOIN track_tag tt ON t.track_id = tt.track_id
    JOIN tag tag ON tag.tag_id = tt.tag_id
    WHERE tag.tags IS NOT NULL
)
SELECT 
    track,
    genero,
    tags
FROM track_tag_genero
WHERE 
    (genero = 'pop' AND tags NOT LIKE '%pop%')
 OR (genero = 'indie' AND tags NOT LIKE '%indie%')
 OR (genero = 'hip-hop' AND tags NOT LIKE '%hip%')
 OR (genero = 'latin' AND tags NOT LIKE '%latin%')
 OR (genero = 'reggaeton' AND tags NOT LIKE '%reag%')
ORDER BY track;


/* 5.2 Índice de discrepancia: Cuantificando la brecha de percepción por género. */
WITH track_tag_genero AS (
    SELECT 
        t.genre_extracted AS genero,
        tag.tags
    FROM track t
    JOIN track_tag tt ON t.track_id = tt.track_id
    JOIN tag tag ON tag.tag_id = tt.tag_id
    WHERE tag.tags IS NOT NULL
)
SELECT 
    genero,
    COUNT(*) AS total_tags_discrepantes
FROM track_tag_genero
WHERE 
    (genero = 'pop' AND tags NOT LIKE '%pop%')
 OR (genero = 'indie' AND tags NOT LIKE '%indie%')
 OR (genero = 'hip-hop' AND tags NOT LIKE '%hip%')
 OR (genero = 'latin' AND tags NOT LIKE '%latin%')
 OR (genero = 'reggaeton' AND tags NOT LIKE '%reag%')
GROUP BY genero
ORDER BY total_tags_discrepantes DESC;


/* 5.3 Consenso de Identidad: Géneros cuya etiqueta oficial coincide para la comunidad. */
WITH track_tag_genero AS (
    SELECT 
        t.genre_extracted AS genero,
        tag.tags
    FROM track t
    JOIN track_tag tt ON t.track_id = tt.track_id
    JOIN tag tag ON tag.tag_id = tt.tag_id
    WHERE tag.tags IS NOT NULL
)
SELECT 
    genero,
    COUNT(*) AS total_tags_coincidentes
FROM track_tag_genero
WHERE 
    (genero = 'pop' AND tags LIKE '%pop%')
 OR (genero = 'indie' AND tags LIKE '%indie%')
 OR (genero = 'hip-hop' AND tags LIKE '%hip%')
 OR (genero = 'latin' AND tags LIKE '%latin%')
 OR (genero = 'reggaeton' AND tags LIKE '%reag%')
GROUP BY genero
ORDER BY total_tags_coincidentes DESC;