# ELDROW

Wordle Solver.

## Run

```
$ flutter run
```

## Deploy

```
$ flutter build web
$ cd build/web
$ echo '{}' > composer.json
$ echo 'web: vendor/bin/heroku-php-apache2' > Procfile
$ echo '<?php include_once("index.html"); ?>' > index.php
$ mv build/web/assets/assets/dictionary.txt build/web/assets/ # Unsure why.
$ git init; git add .; git commit -m "Initialize."
$ heroku git:remote -a wordle-eldrow
$ git push heroku main:master --force # Overrides the existing deployed version.
```

## Reference

Dictionary: https://raw.githubusercontent.com/dwyl/english-words/master/words.txt.
