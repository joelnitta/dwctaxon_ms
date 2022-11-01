# dwctaxon_ms

Repo to compile manuscript 'dwctaxon, an R package for editing and validating taxonomic data in Darwin Core format'

## Compiling paper

First run `targets::tar_make()` in R.

Then compile the paper with docker:

```
docker run --rm \
    --volume $PWD:/data \
    --user $(id -u):$(id -g) \
    --env JOURNAL=joss \
    openjournals/inara
```