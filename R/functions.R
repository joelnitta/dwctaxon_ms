load_backbone <- function(gbif_backbone_zip) {

  # Unzip Taxon.tsv to a temporary directory
  temp_dir <- tempdir(check = TRUE)

  utils::unzip(
    gbif_backbone_zip, files = "Taxon.tsv",
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
  system(glue::glue("sed -i '' -e 's/“/\"/g' {out_file}"))
  system(glue::glue("sed -i '' -e 's/”/\"/g' {out_file}"))
  fs::file_delete(tempfile)
  out_file
}

render_joss_ms <- function(md_file) {
  # Prepare paths
  md_file_only <- fs::path_file(md_file)
  md_file_path <- fs::path(md_file) |>
    fs::path_abs()
  md_file_folder <- fs::path_dir(md_file_path)
  pdf_file_only <- md_file_only |>
    fs::path_ext_remove() |>
    fs::path_ext_set("pdf")

  # Run docker
  babelwhale::run(
    container_id = "openjournals/inara:latest",
    volumes = glue::glue("{md_file_folder}:/data"),
    environment_variables = c("JOURNAL" = "joss"),
    args = md_file_only,
    command = "/usr/local/bin/inara"
  )

  # Return path to output
  fs::path(md_file_folder, pdf_file_only)
}