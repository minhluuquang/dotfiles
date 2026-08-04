# ~/.config/fish/functions/gwtt.fish
# --- FINAL CORRECTED VERSION ---

function gwtt --description 'Git Worktree Teardown: removes worktree, deletes branch, and returns to main'
    # Check if inside a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "💥 Error: Not a git repository."
        return 1
    end

    # --- 1. Identify worktree details using direct, robust commands ---
    set git_dir (git rev-parse --git-dir)

    # Check if we are in the main worktree
    if not string match -q "*/.git/worktrees/*" "$git_dir"
        echo "💥 Error: You are in the main worktree. This command cannot be run from here."
        return 1
    end

    # Get the details needed for teardown
    set worktree_to_delete (git rev-parse --show-toplevel)
    set branch_to_delete (git rev-parse --abbrev-ref HEAD)
    set main_worktree_path (dirname (git rev-parse --git-common-dir))

    # --- 2. Confirmation ---
    echo "This will perform the following actions:"
    echo "  - 🗑️  Delete worktree folder: " (set_color yellow)"$worktree_to_delete"(set_color normal)
    echo "  - 🗑️  Delete local git branch: " (set_color yellow)"$branch_to_delete"(set_color normal)

    read -P "Are you sure you want to continue? (y/N) " -l confirm

    if test (string lower -- "$confirm") != y
        echo "🚫 Operation cancelled."
        return 0
    end

    # --- 3. Deletion and Navigation ---

    echo "✅ Navigating to main worktree..."
    cd "$main_worktree_path"

    # Now that we are in a safe location, we can delete the worktree.
    echo "✅ Deleting worktree folder..."
    if not git worktree remove --force "$worktree_to_delete"
        echo "💥 Error: Failed to remove the worktree."
        return 1
    end

    echo "✅ Deleting branch..."
    # Use -D to force-delete the branch, as it's unlikely to be merged.
    if not git branch -D "$branch_to_delete"
        # This warning is unlikely now but kept for safety.
        echo "⚠️ Warning: Failed to delete the branch '$branch_to_delete'."
        return 1
    end

    echo "✨ Teardown complete. You are now in the main project directory."
end
