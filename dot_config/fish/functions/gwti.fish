# ~/.config/fish/functions/gwti.fish

function gwti --description 'Git Worktree Init: creates worktree, copies ignored files, and installs dependencies'
    # Check if user provided an input for the branch name
    if test (count $argv) -eq 0
        echo "💥 Error: Missing input for the new branch name."
        echo "Usage: gwti <new-branch-name>"
        return 1
    end

    # Check if inside a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "💥 Error: Not a git repository."
        return 1
    end

    # --- Variable Setup ---
    set user_input $argv[1]
    set current_dir_name (basename (pwd))
    set worktree_name "$current_dir_name-$user_input"
    set worktree_path "../$worktree_name"
    set original_path (pwd)

    # --- Pre-flight Checks for Existing Branch or Folder ---
    if git rev-parse --verify --quiet $user_input >/dev/null 2>&1
        echo "💥 Error: Branch '$user_input' already exists."
        return 1
    end

    if test -e $worktree_path
        echo "💥 Error: Directory '$worktree_path' already exists."
        return 1
    end

    # --- 1. Detect Package Manager (from original directory) ---
    set pkg_manager none
    if test -e bun.lock
        set pkg_manager bun
    else if test -e pnpm-lock.yaml
        set pkg_manager pnpm
    else if test -e yarn.lock
        set pkg_manager yarn
    else if test -e package-lock.json
        set pkg_manager npm
    else if test -e package.json
        # Fallback to npm if no lockfile is found
        set pkg_manager npm
    end

    # --- 2. Create the Git Worktree ---
    echo "🌳 Creating new worktree..."
    echo "   - Branch: '$user_input'"
    echo "   - Path:   '$worktree_path'"

    if not git worktree add -b $user_input $worktree_path
        echo "💥 Error: Failed to create git worktree for an unexpected reason."
        return 1
    end
    echo "✅ Worktree created successfully."

    # --- 3. Copy Ignored Files ---
    if test -e .gitignore
        echo "📋 Copying files and folders listed in .gitignore..."
        while read -l item_to_copy
            set trimmed_item (string trim -- "$item_to_copy")
            if test -z "$trimmed_item"; or string match -q "^#" "$trimmed_item"
                continue
            end
            set final_item (string trim -r -c '/' -- "$trimmed_item")
            if test -e "$final_item"
                echo "   - Copying '$final_item' to '$worktree_path/'"
                cp -r "$final_item" "$worktree_path/"
            else
                echo "   - Skipping '$final_item' (pattern or does not exist)."
            end
        end <.gitignore
    end

    # --- 4. Auto-install Dependencies ---
    if test "$pkg_manager" != none
        echo "📦 Switching to new worktree to install dependencies..."
        cd $worktree_path

        switch $pkg_manager
            case bun
                echo "   - Installing with Bun..."
                bun install
            case pnpm
                echo "   - Installing with pnpm..."
                pnpm install
            case yarn
                echo "   - Installing with Yarn..."
                yarn install
            case npm
                echo "   - Installing with npm..."
                npm install
        end

        # Return to the original directory
        cd $original_path
    else
        echo "🤔 No lockfile found, skipping dependency installation."
    end

    echo "✨ Done. Your new worktree is ready at '$worktree_path'"
end
