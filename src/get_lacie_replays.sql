SELECT
    r.ID        AS replay_id,
    r.post_date AS replay_date,
    o.ID        AS original_id,
    o.post_date AS original_date
FROM wp_posts r
JOIN wp_postmeta pm
      ON pm.post_id = r.ID
     AND pm.meta_key = 'pr_metadata_orig'

-- original
JOIN wp_posts o
      ON o.ID = pm.meta_value
     AND o.post_type = 'programma'

-- replay language = nl
JOIN wp_term_relationships tr_lang_r
      ON tr_lang_r.object_id = r.ID
JOIN wp_term_taxonomy tt_lang_r
      ON tt_lang_r.term_taxonomy_id = tr_lang_r.term_taxonomy_id
     AND tt_lang_r.taxonomy = 'language'
JOIN wp_terms t_lang_r
      ON t_lang_r.term_id = tt_lang_r.term_id
     AND t_lang_r.slug = 'nl'

-- get TRID of the original (taxonomy = post_translations)
JOIN wp_term_relationships tr_trid
      ON tr_trid.object_id = o.ID
JOIN wp_term_taxonomy tt_trid
      ON tt_trid.term_taxonomy_id = tr_trid.term_taxonomy_id
     AND tt_trid.taxonomy = 'post_translations'

-- enforce that this TRID has BOTH nl AND en posts
WHERE
      r.post_type = 'programma_woj'
  AND o.post_title like 'tussen swing%' -- get LaCie-replays for this title
  AND EXISTS (
        SELECT 1
        FROM wp_term_relationships tr_nl
        JOIN wp_term_taxonomy tt_nl
              ON tt_nl.term_taxonomy_id = tr_nl.term_taxonomy_id
             AND tt_nl.taxonomy = 'language'
        JOIN wp_terms t_nl
              ON t_nl.term_id = tt_nl.term_id
        WHERE tr_nl.object_id IN (
              SELECT object_id
              FROM wp_term_relationships
              WHERE term_taxonomy_id = tt_trid.term_taxonomy_id
        )
          AND t_nl.slug = 'nl'
    )
  AND EXISTS (
        SELECT 1
        FROM wp_term_relationships tr_en
        JOIN wp_term_taxonomy tt_en
              ON tt_en.term_taxonomy_id = tr_en.term_taxonomy_id
             AND tt_en.taxonomy = 'language'
        JOIN wp_terms t_en
              ON t_en.term_id = tt_en.term_id
        WHERE tr_en.object_id IN (
              SELECT object_id
              FROM wp_term_relationships
              WHERE term_taxonomy_id = tt_trid.term_taxonomy_id
        )
          AND t_en.slug = 'en'
    )
    order by 3, 2;
