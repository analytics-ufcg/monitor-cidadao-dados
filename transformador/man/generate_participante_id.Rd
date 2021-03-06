% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sagres.R
\name{generate_participante_id}
\alias{generate_participante_id}
\title{Gera um identificador único para cada participante}
\usage{
generate_participante_id(participantes_df)
}
\arguments{
\item{participantes_df}{Dataframe contendo informações sobre os participantes}
}
\value{
Dataframe contendo informações sobre os participantes e seus ids
}
\description{
Gera um identificador único para cada participante
}
\examples{
participantes_dt <- generate_licitacao_id(licitacoes_df)
}
