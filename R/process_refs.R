# Filter a list of references in YAML format to those cited in an RMD file
library(tidyverse)
library(rmdref)

# Filter YAML references from Zotero library.
# main_library.yaml has been exported from Zotero
# like this: file -> "export library" -> "Better CSL YAML"
# or created as a symlink like this:
# cd _targets/user/data_raw/
# ln -s ~/Dropbox/bibliography/main_library.yaml

# Write out 'aux' file with citation keys to make collection in Zotero,
# export to here as bib file.
# The collection can be made with the betterbibtex for Zotero plugin:
# https://retorque.re/zotero-better-bibtex/citing/aux-scanner/
extract_citations("ms.Qmd") %>%
  # aux file just consists of lines formatted like
  # \citation{KEY}
  # where KEY is the citation key
  mutate(latex = glue::glue("\\citation{[key]}", .open = "[", .close = "]")) %>%
  pull(latex) %>%
  write_lines("working/dwctaxon_ms.aux")
