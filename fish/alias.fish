alias ll "ls -lah"
alias k kubectl

abbr va source .venv/bin/activate.fish
abbr es envsource .env
abbr vv "source .venv/bin/activate.fish; envsource .env"

# dbt aliases
abbr --add dbs dbt build --select
abbr --add dbtyml --set-cursor "dbt run-operation generate_model_yaml --args '{"model_names": [\"%\"], "upstream_descriptions": "True", "include_data_types": "False"}' -q > models/out.txt"

# ruff
abbr --add rcf ruff check --fix
abbr --add rcfu ruff check --fix --unsafe-fixes
abbr --add rf ruff format
abbr --add ri ruff check --fix --select I

# sqlfluff
abbr --add sff sqlfluff fix
abbr --add sfl sqlfluff lint

# git
abbr --add gaa "git add .; git commit -a -m \".\"; git push"
