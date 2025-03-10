function git_cleanup_branches
    argparse D -- $argv
    or return

    git fetch -p
    set temp_file (mktemp)

    # Get remote branches and filter against local ones
    git branch -r | awk '{print $1}' > $temp_file
    set branches (git branch -vv | grep origin | awk '{print $1}' | egrep -v -f $temp_file)

    if test -z "$branches"
        echo "No branches to clean up."
    else
        echo "Branches that would be deleted:"
        echo $branches | tr ' ' '\n'

        if set -q _flag_D
            echo "Deleting branches..."
            echo $branches | xargs git branch -D
        end
    end

    rm $temp_file
end
