---
name: release
description: "Complete a GitHub release branch cycle for a non-primary branch: push the current or named branch, create a pull request into master, merge it with remote branch deletion, update local master, delete the old local branch, and recreate that same branch from the latest master. Use when the user asks to finish a branch-to-master PR/merge cycle and reset the working branch for the next cycle."
---

# Release

## Overview

Complete one full GitHub branch cycle:

1. Push `branch-x` to `origin`.
2. Create a PR from `branch-x` into `master`.
3. Merge the PR and delete the remote branch.
4. Update local `master`.
5. Delete the old local `branch-x`.
6. Recreate `branch-x` from the latest `master`.

Use `branch-x` as the branch requested by the user. If no branch is named, use the current branch. Do not use this workflow from `master` itself.

## Preconditions

- Confirm the repository is clean before mutating anything:

```bash
git status --short --branch
```

- Confirm the target branch:

```bash
git branch --show-current
```

- Stop and ask before proceeding if:
  - the working tree has uncommitted changes,
  - the branch is `master`,
  - the PR is not mergeable,
  - CI, branch protection, or GitHub permissions block the merge.

## Workflow

Replace `branch-x` with the actual branch name and keep `master` as the base branch unless the user explicitly requests another base.

1. Push the branch:

```bash
git push origin branch-x
```

2. Create the PR:

```bash
gh pr create --base master --head branch-x --title "<concise title>" --body "<summary and verification>"
```

3. Capture the PR number from the output, then verify the PR:

```bash
gh pr view <PR_NUMBER> --json number,baseRefName,headRefName,state,isDraft,mergeable,url
```

Proceed only when `baseRefName` is `master`, `headRefName` is `branch-x`, `state` is `OPEN`, and `mergeable` is `MERGEABLE`.

4. Merge with a merge commit and delete the remote branch:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

5. Ensure local `master` is current:

```bash
git checkout master
git pull --ff-only origin master
```

6. Delete the old local branch if it still exists:

```bash
git branch --list branch-x
git branch -d branch-x
```

If `gh pr merge --delete-branch` already deleted the local branch, skip `git branch -d branch-x`.

7. Recreate the branch from latest `master`:

```bash
git checkout -b branch-x
```

## Verification

Run these checks after recreating the branch:

```bash
git branch --show-current
git log --oneline master..branch-x
git ls-remote --heads origin branch-x
git status --short --branch
gh pr view <PR_NUMBER> --json state,mergedAt,mergeCommit,url
```

Expected results:

- Current branch is `branch-x`.
- `git log --oneline master..branch-x` is empty.
- `git ls-remote --heads origin branch-x` is empty.
- Worktree is clean.
- PR state is `MERGED`.

## Reporting

Summarize the completed cycle with:

- PR URL and PR number.
- Merge commit SHA.
- Current branch.
- Whether remote `branch-x` is deleted.
- Whether local `branch-x` was recreated from latest `master`.
