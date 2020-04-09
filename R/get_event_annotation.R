#' Title
#'
#' @param comb 
#' @param event_exons 
#' @param exon_vector 
#' @param neg_strand 
#' @param template 
#' @param variant 
#'
#' @return
#'
#' @examples
get_event_annotation <-
  function(comb,
           event_exons,
           exon_vector,
           neg_strand,
           template,
           variant) {
    
    event_annotation <- data.table::data.table(
      event_annotation = character(),
      variant = character(),
      template = character(),
      genomic_start = integer(),
      genomic_end = integer(),
      transcriptomic_start = integer(),
      transcriptomic_end = integer()
    )
    
    #TODO: wrap in function
    if ('afe' %in% comb) {
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'afe',
          variant$transcript_id[1],
          template$transcript_id[1],
          start(variant[1]),
          end(variant[1]),
          variant[1]$tr_start,
          variant[1]$tr_end
        ),
        list(
          'afe',
          template$transcript_id[1],
          variant$transcript_id[1],
          start(template[1]),
          end(template[1]),
          template[1]$tr_start,
          template[1]$tr_end
        )
      ))
    }
    if ('ale' %in% comb) {
      variant_length <- length(variant)
      template_length <- length(template)
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'ale',
          variant$transcript_id[1],
          template$transcript_id[1],
          start(variant[variant_length]),
          end(variant[variant_length]),
          variant[variant_length]$tr_start,
          variant[variant_length]$tr_end
        ),
        list(
          'ale',
          template$transcript_id[1],
          variant$transcript_id[1],
          start(template[template_length]),
          end(template[template_length]),
          template[template_length]$tr_start,
          template[template_length]$tr_end
        )
      ))
    }
    if ('mee' %in% comb) {
      incl_exons <-
        list(template = as.integer(names(event_exons$mee)[2]),
             variant = as.integer(names(event_exons$mee)[3]))
      if (exon_vector[names(event_exons$mee)[3]]) incl_exons[c(1,2)] <- incl_exons[c(2,1)]
      variant_exon <- variant[variant$gene_exon_number == incl_exons$variant]
      template_exon <- template[template$gene_exon_number == incl_exons$template]
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'mee',
          variant$transcript_id[1],
          template$transcript_id[1],
          start(variant_exon),
          end(variant_exon),
          variant_exon$tr_start,
          variant_exon$tr_end
        ),
        list(
          'mee',
          template$transcript_id[1],
          variant$transcript_id[1],
          start(template_exon),
          end(template_exon),
          template_exon$tr_start,
          template_exon$tr_end
        )
      ))
    }
    if ('mes' %in% comb) {
      skipped_exons <- template[template$gene_exon_number %in% as.integer(names((event_exons$mes[-c(1, length(event_exons$mes))])))]
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'mes',
          variant$transcript_id[1],
          template$transcript_id[1],
          paste(start(skipped_exons), collapse = ','),
          paste(end(skipped_exons), collapse = ','),
          paste(skipped_exons$tr_start, collapse = ','),
          paste(skipped_exons$tr_end, collapse = ',')
        )
      ))
    }
    if ('es' %in% comb) {
      skipped_exon <- template[template$gene_exon_number == as.integer(names(event_exons$es[2]))]
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'es',
          variant$transcript_id[1],
          template$transcript_id[1],
          start(skipped_exon),
          end(skipped_exon),
          skipped_exon$tr_start,
          skipped_exon$tr_end
        )
      ))
    }
    if ('ir' %in% comb) {
      ri <- parent.frame()$ri
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'ir',
          variant$transcript_id[1],
          template$transcript_id[1],
          start(ri),
          end(ri),
          ri$tr_start,
          ri$tr_end
        )
      ))
    }
    if ('a3' %in% comb) {
      new_a3 <- parent.frame()$new_a3
      alt_exon <- template[template$gene_exon_number == parent.frame()$a3_index]
      old_a3 <- ifelse(neg_strand, end(alt_exon), start(alt_exon))
      skipped_bases <- abs(old_a3 - new_a3)
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'a3',
          variant$transcript_id[1],
          template$transcript_id[1],
          ifelse(neg_strand, (new_a3 + 1L), old_a3),
          ifelse(neg_strand, old_a3, (new_a3 - 1L)),
          alt_exon$tr_start,
          alt_exon$tr_start + skipped_bases - 1L
        )
      ))
    }
    if ('a5' %in% comb) {
      new_a5 <- parent.frame()$new_a5
      alt_exon <- template[template$gene_exon_number == parent.frame()$a5_index]
      old_a5 <- ifelse(neg_strand, start(alt_exon), end(alt_exon))
      skipped_bases <- abs(old_a5 - new_a5)
      event_annotation <- data.table::rbindlist(list(
        event_annotation,
        list(
          'a5',
          variant$transcript_id[1],
          template$transcript_id[1],
          ifelse(neg_strand, old_a5, (new_a5 + 1)),
          ifelse(neg_strand, (new_a5 - 1L), old_a5),
          alt_exon$tr_end - skipped_bases + 1L,
          alt_exon$tr_end
        )
      ))
    }
    event_annotation
  }