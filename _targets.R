library(targets)
library(tarchetypes)

source("R/packages.R")
source("R/functions.R")

tar_plan(
  tar_file(
    gbif_backbone_zip_file,
    "_targets/user/data/backbone.zip"
  ),
  gbif_backbone = load_backbone(gbif_backbone_zip_file),
  gbif_check = dct_validate(
    gbif_backbone,
    valid_tax_status = paste(
      "accepted, doubtful, heterotypic synonym",
      "homotypic synonym", "proparte synonym",
      "synonym"),
    on_fail = "summary"
  ),
  tar_quarto(
    ms_initial,
    "ms.Qmd"
  ),
  # fix reference formatting
  tar_file(
    ms_final,
    clean_refs(ms_initial, "paper.md")
  )
)
