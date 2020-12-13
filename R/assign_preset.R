#internal function to assign preset if present
assign_preset <- function(preset, event_probs){
  change_event_probs <- is.null(event_probs)
  if (is.null(preset) & change_event_probs) stop('you have to supply at least one of "preset", "event_probs"')
  if (is.null(preset)) return(list())
  stopifnot(is.character(preset) & (length(preset) == 1))
  utils::data(presets, package = 'ASimulatoR', envir = environment())
  preset <- match.arg(preset, names(presets))
  return(presets[[preset]])
}

# # this code was used to assign presets
# 
# presets <- list()
# max_genes = 10000
# as_events <- c('es', 'mes', 'ir', 'a3', 'a5', 'afe', 'ale', 'mee')
# event_probs <- rep(1/(length(as_events) + 1), length(as_events))
# names(event_probs) <- as_events
# presets$event_partition <- list(
#   event_probs = event_probs,
#   max_genes = max_genes,
#   probs_as_freq = T
# )
# presets$experiment_bias <- list(
#   event_probs = event_probs,
#   max_genes = max_genes,
#   error_model = 'illumina5',
#   pcr_rate = 0.001,
#   bias = 'cdnaf',
#   distr = 'empirical',
#   adapter_contamination = T,
#   probs_as_freq = T
# )
# as_combs <- combn(as_events, 2, FUN = function(...) paste(..., collapse = ','))
# event_probs <- rep(1/(length(as_combs) + 1), length(as_combs))
# presets$event_combination_2 <- list(
#   event_probs = event_probs,
#   max_genes = max_genes,
#   multi_events_per_exon = T
# )
# save(presets, file = 'data/presets.rda')

#' Parameter presets for the \code{\link{simulate_alternative_splicing}} function
#' 
#' You can pass one of this lists names as parameter \code{preset} to \code{\link{simulate_alternative_splicing}}. 
#' This will apply all parameters contained in the corresponding preset.
#' The parameters set by preset can also be overridden using the argument explicitly.
#' You can check the exact parameters by loading the presets e.g.
#' \code{data(presets)}
#' \code{presets$event_partition}
#'
#' @name presets
#' @docType data
#' @author Quirin Manz \email{quirin.manz@@tum.de}
#' @usage simulate_alternative_splicing('some_input_dir', 'some_output_dir', preset = 'event_partition')
#' @keywords data
"presets"