alias ll "ls -la"
# alias bat batcat
alias k kubectl
# dbt aliases
abbr --add dbs dbt build --select
abbr --add dbtyml --set-cursor "dbt run-operation generate_model_yaml --args '{"model_names": [\"%\"]}' -q > models/out.txt"

# sqlfluff
abbr --add sff sqlfluff fix
abbr --add sfl sqlfluff lint

# git
abbr --add gaa "git add .; git commit -a -m \".\"; git push"
