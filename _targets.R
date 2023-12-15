library(targets)
library(tarchetypes)

source("R/packages.R")
source("R/functions.R")

tar_plan(
  # Download data ----
  # - Specify data hash set with contentid
  # This hash corresponds to the GBIF backbone from 2023-08-28
  # https://hosted-datasets.gbif.org/datasets/backbone/2023-08-28/backbone.zip
  gbif_hash = "hash://sha256/2897887cc7fb6fe27188c5b0fa5ce2b14762b43c61ceecd1e3dfad25083f5770", # nolint
  gbif_backbone = load_backbone(contentid::resolve(gbif_hash, store = TRUE)),

  # Validate data ----
  gbif_check = dct_validate(
    gbif_backbone,
    valid_tax_status = paste(
      "accepted, doubtful, heterotypic synonym,",
      "homotypic synonym,", "proparte synonym,",
      "synonym"),
    on_fail = "summary"
  ),

  # Calculate stats ----
  gbif_backbone_size = nrow(gbif_backbone),

  # Render MS ----
  # - First render to markdown
  tar_quarto(
    ms_markdown_initial,
    "ms.Qmd",
    quiet = FALSE
  ),
  # - Fix reference formatting
  tar_file(
    ms_markdown_fixed,
    clean_refs(ms_markdown_initial, "paper.md")
  ),
  # - Finally render to JOSS PDF
  tar_file(
    ms_pdf,
    render_joss_ms(ms_markdown_fixed)
  )
)
