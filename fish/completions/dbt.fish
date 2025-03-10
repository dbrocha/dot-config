# Function to find project root - walks up directories until it finds dbt_project.yml
function __fish_dbt_find_project_root
    set -l directory $PWD
    set -l slashes (string replace -a -r '[^/]' '' $PWD | string length)
    
    for i in (seq $slashes -1 0)
        if test -e "$directory/dbt_project.yml"
            echo "$directory"
            return 0
        end
        set directory "$directory/.."
    end
    return 1
end

# Function to parse manifest and extract selectors
function __fish_dbt_parse_manifest
    set -l manifest_path $argv[1]
    set -l prefix $argv[2]

    python -c "
import json
import sys

try:
    with open('$manifest_path', 'r') as f:
        manifest = json.load(f)
    
    prefix = '$prefix'
    
    models = set(
        '{}{}' .format(prefix, node['name'])
        for node in manifest['nodes'].values()
        if node['resource_type'] in ['model', 'seed']
    )
    
    tags = set(
        '{}tag:{}' .format(prefix, tag)
        for node in manifest['nodes'].values()
        for tag in node.get('tags', [])
        if node['resource_type'] == 'model'
    )
    
    sources = set(
        '{}source:{}' .format(prefix, node['source_name'])
        for node in manifest['nodes'].values()
        if node['resource_type'] == 'source'
    ) | set(
        '{}source:{}.{}' .format(prefix, node['source_name'], node['name'])
        for node in manifest['nodes'].values()
        if node['resource_type'] == 'source'
    )
    
    fqns = set(
        '{}{}.*' .format(prefix, '.'.join(node['fqn'][:i-1]))
        for node in manifest['nodes'].values()
        for i in range(len(node.get('fqn', [])))
        if node['resource_type'] == 'model'
    )
    
    selectors = [
        selector
        for selector in (models | tags | sources | fqns)
        if selector != ''
    ]
    
    print('\\n'.join(selectors))

except Exception as e:
    sys.exit(1)
" 2>/dev/null
end

# Function to check if current argument is for a selector flag
function __fish_dbt_is_selector_flag
    set -l prev (commandline -poc)[-1]
    
    if contains -- $prev '-m' '--model' '--models' '-s' '--select' '--exclude'
        return 0
    end
    
    set -l token (commandline -t)
    
    if string match -q -- '-m=*' $token; or \
       string match -q -- '--model=*' $token; or \
       string match -q -- '--models=*' $token; or \
       string match -q -- '-s=*' $token; or \
       string match -q -- '--select=*' $token; or \
       string match -q -- '--exclude=*' $token
        return 0
    end
    
    return 1
end

# Main completion function for dbt
function __fish_dbt_complete
    set -l project_dir (__fish_dbt_find_project_root)
    if test -z "$project_dir"
        return 1
    end
    
    set -l manifest_path "$project_dir/target/manifest.json"
    if not test -f "$manifest_path"
        return 1
    end
    
    set -l current_token (commandline -ct)
    
    if string match -q -- '-*' $current_token
        return
    end
    
    set -l cmd (commandline -opc)
    if contains -- $cmd "run" "test" "build" "compile" "debug" "clean" "deps" "docs" "init" "list" "parse" "seed" "snapshot" "source"
        return
    end
    
    if not __fish_dbt_is_selector_flag
        return
    end
    
    set -l prefix ""
    if string match -q -- '+*' $current_token
        set prefix "+"
        set current_token (string sub -s 2 -- $current_token)
    else if string match -q -- '@*' $current_token
        set prefix "@"
        set current_token (string sub -s 2 -- $current_token)
    end

    set -l selectors (__fish_dbt_parse_manifest "$manifest_path" $prefix)
    
    for selector in $selectors
        set -l selector_clean $selector
        if test -n "$prefix"
            set selector_clean (string sub -s 2 -- $selector)
        end
        
        if test -z "$current_token" 
            or string match -q -- "$current_token*" $selector_clean
            echo $selector
        end
    end
end

function __fish_dbt_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

# Top-level dbt commands
complete -c dbt -f -n "__fish_dbt_needs_command" -a "run" -d "Run models"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "test" -d "Run tests"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "build" -d "Build and test all resources"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "compile" -d "Compile models"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "debug" -d "Debug dbt configs" 
complete -c dbt -f -n "__fish_dbt_needs_command" -a "clean" -d "Clean the target directory"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "deps" -d "Install dependencies"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "docs" -d "Generate documentation"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "init" -d "Initialize a dbt project"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "list" -d "List resources"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "parse" -d "Parse project"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "seed" -d "Load seed files"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "snapshot" -d "Execute snapshots"
complete -c dbt -f -n "__fish_dbt_needs_command" -a "source" -d "Source commands"

# Common flags for dbt commands
complete -c dbt -f -l models -s m -d "Models to include" 
complete -c dbt -f -l select -s s -d "Resources to select"
complete -c dbt -f -l exclude -d "Resources to exclude"

complete -c dbt -l fail-fast -d "Stop on first error"
complete -c dbt -l threads -d "Specify number of threads"
complete -c dbt -l no-version-check -d "Skip version check"
complete -c dbt -l project-dir -d "Specify project directory"
complete -c dbt -l profiles-dir -d "Specify profiles directory"
complete -c dbt -l target -d "Specify target in profile"
complete -c dbt -l vars -d "Supply variables"

# Hook the __fish_dbt_complete function into the Fish shell's completion system for the dbt command
complete -c dbt -f -a "(__fish_dbt_complete)"