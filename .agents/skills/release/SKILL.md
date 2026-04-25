---
name: release
description: "Complete a GitHub release branch cycle for a non-primary branch: detect the repository default branch, push the current or named branch, create a pull request into the default branch, merge it with remote branch deletion, update the local default branch, delete the old local branch, and recreate that same branch from the latest default branch. Use when the user asks to finish a branch-to-default-branch PR/merge cycle and reset the working branch for the next cycle."
---

# Release

## Overview

Complete one full GitHub branch cycle:

1. Push `branch-x` to `origin`.
2. Create a PR from `branch-x` into the repository default branch.
3. Merge the PR and delete the remote branch.
4. Update the local default branch.
5. Delete the old local `branch-x`.
6. Recreate `branch-x` from the latest default branch.

Use `branch-x` as the branch requested by the user. If no branch is named, use the current branch. Detect the repository default branch and do not use this workflow from that branch itself.

## Preconditions

- Confirm the repository is clean before mutating anything:

```bash
git status --short --branch
```

- Confirm the target branch:

```bash
git branch --show-current
```

- Detect the default branch from `origin`:

```bash
base_branch=$(git remote show origin | sed -n 's/.*HEAD branch: //p')
test -n "$base_branch"
```

Use `base_branch` as the base branch. Stop and ask before proceeding if the default branch cannot be detected.

- Stop and ask before proceeding if:
  - the working tree has uncommitted changes,
  - the branch is `$base_branch`,
  - the PR is not mergeable,
  - CI, branch protection, or GitHub permissions block the merge.

## Workflow

Replace `branch-x` with the actual branch name. Use `$base_branch` as the detected default branch unless the user explicitly requests another base.

1. Push the branch:

```bash
git push origin branch-x
```

2. Create the PR:

```bash
gh pr create --base "$base_branch" --head branch-x --title "<concise title>" --body "<summary and verification>"
```

3. Capture the PR number from the output, then verify the PR:

```bash
gh pr view <PR_NUMBER> --json number,baseRefName,headRefName,state,isDraft,mergeable,url
```

Proceed only when `baseRefName` matches `$base_branch`, `headRefName` is `branch-x`, `state` is `OPEN`, and `mergeable` is `MERGEABLE`.

4. Merge with a merge commit and delete the remote branch:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

5. Ensure the local default branch is current:

```bash
git checkout "$base_branch"
git pull --ff-only origin "$base_branch"
```

6. Delete the old local branch if it still exists:

```bash
git branch --list branch-x
git branch -d branch-x
```

If `gh pr merge --delete-branch` already deleted the local branch, skip `git branch -d branch-x`.

7. Recreate the branch from the latest default branch:

```bash
git checkout -b branch-x
```

## Verification

Run these checks after recreating the branch:

```bash
git branch --show-current
git log --oneline "$base_branch..branch-x"
git ls-remote --heads origin branch-x
git status --short --branch
gh pr view <PR_NUMBER> --json state,mergedAt,mergeCommit,url
```

Expected results:

- Current branch is `branch-x`.
- `git log --oneline "$base_branch..branch-x"` is empty.
- `git ls-remote --heads origin branch-x` is empty.
- Worktree is clean.
- PR state is `MERGED`.

## Reporting

Summarize the completed cycle with:

- PR URL and PR number.
- Merge commit SHA.
- Detected base branch.
- Current branch.
- Whether remote `branch-x` is deleted.
- Whether local `branch-x` was recreated from the latest default branch.
