load_backbone <- function(gbif_backbone_zip) {

 # Unzip Taxon.tsv to a temporary directory
  temp_dir <- tempdir(check = TRUE)

  utils::unzip(
    gbif_backbone_zip, files = "backbone/Taxon.tsv",
    overwrite = TRUE, junkpaths = TRUE, exdir = temp_dir)

  # Read in data
  temp_tsv <- fs::path(temp_dir, "Taxon.tsv")
  res <- readr::read_tsv(temp_tsv)

  # Delete temp file
  fs::file_delete(temp_tsv)

  res

}

clean_refs <- function(in_file, out_file) {
  tempfile <- tempfile()
  system(glue::glue("sed -e 's/\\\\\\]/\\]/g' {in_file} > {tempfile}"))
  system(glue::glue("sed -e 's/\\\\\\[/\\[/g' {tempfile} > {out_file}"))
  system(glue::glue("sed -i '' -e 's/ / /g' {out_file}"))
  fs::file_delete(tempfile)
  out_file
}