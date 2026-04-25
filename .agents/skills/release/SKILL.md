---
name: release
description: "Complete a GitHub release branch cycle for a non-primary branch: confirm the next VERSION file SemVer bump, commit the version bump, push the branch, create a pull request into the repository default branch, merge it with remote branch deletion, tag the merge commit, update the local default branch, delete the old local branch, and recreate that same branch from the latest default branch. Use when the user asks to finish a branch-to-default-branch release cycle and reset the working branch for the next cycle."
---

# Release

## Overview

Complete one full GitHub release branch cycle:

1. Confirm the next release version from the current `VERSION` file.
2. Commit the `VERSION` bump on `branch-x`.
3. Push `branch-x` to `origin`.
4. Create a PR from `branch-x` into the repository default branch.
5. Merge the PR and delete the remote branch.
6. Tag the PR merge commit as `vX.Y.Z`.
7. Update the local default branch.
8. Delete the old local `branch-x`.
9. Recreate `branch-x` from the latest default branch.

Use `branch-x` as the branch requested by the user. If no branch is named, use the current branch. Detect the repository default branch and do not use this workflow from that branch itself.

## Preconditions

- Confirm the repository is clean before mutating anything:

```bash
git status --short --branch
```

Stop if the working tree has uncommitted changes.

- Confirm the target branch:

```bash
git branch --show-current
```

Stop if the branch is the default branch.

- Detect the default branch from `origin`:

```bash
base_branch=$(git remote show origin | sed -n 's/.*HEAD branch: //p')
test -n "$base_branch"
```

Use `base_branch` as the base branch. Stop and ask before proceeding if the default branch cannot be detected.

- Confirm the current release version:

```bash
test -f VERSION
release_current=$(tr -d '[:space:]' < VERSION)
printf '%s\n' "$release_current"
```

Use this as the current release version. Stop and ask before proceeding if `VERSION` does not exist or does not contain a SemVer `X.Y.Z` version.

- Ask the user to confirm the next release version before editing `VERSION`. Offer `patch`, `minor`, `major`, or an explicit version based on the current version.
  - `patch`: increment `Z`.
  - `minor`: increment `Y` and reset `Z` to `0`.
  - `major`: increment `X` and reset `Y` and `Z` to `0`.

- Stop and ask before proceeding if:
  - the next version cannot be confirmed,
  - the version bump does not change `VERSION`,
  - the PR is not mergeable,
  - CI, branch protection, or GitHub permissions block the merge.

## Workflow

Replace `branch-x` with the actual branch name. Use `$base_branch` as the detected default branch unless the user explicitly requests another base.

1. Confirm the current branch, clean working tree, and default branch:

```bash
git status --short --branch
git branch --show-current
base_branch=$(git remote show origin | sed -n 's/.*HEAD branch: //p')
test -n "$base_branch"
```

Proceed only when the worktree is clean and `branch-x` is not `$base_branch`.

2. Capture the current release version:

```bash
test -f VERSION
release_current=$(tr -d '[:space:]' < VERSION)
printf '%s\n' "$release_current"
```

3. Ask the user to choose the next version bump:

- `patch`
- `minor`
- `major`
- an explicit `X.Y.Z` version

For `patch`, `minor`, or `major`, derive the new `X.Y.Z` from `$release_current` before editing `VERSION`.

4. Apply the confirmed version bump by replacing `VERSION` with the confirmed or derived `X.Y.Z` value:

```bash
printf '%s\n' "$release_version" > VERSION
cat VERSION
```

Set `release_version` to the new version number and `release_tag` to `v$release_version`.

5. Commit the version bump:

```bash
git status --short
git diff -- VERSION
git add VERSION
```

Stage `CHANGELOG.md` only if it already exists and was intentionally updated for this release, or if the user explicitly requested a changelog update.

```bash
git commit -m "Bump version to $release_version"
```

6. Push the branch:

```bash
git push origin branch-x
```

7. Create the PR:

```bash
gh pr create --base "$base_branch" --head branch-x --title "Release $release_tag" --body "<summary and verification>"
```

8. Capture the PR number from the output, then verify the PR:

```bash
gh pr view <PR_NUMBER> --json number,baseRefName,headRefName,state,isDraft,mergeable,url
```

Proceed only when `baseRefName` matches `$base_branch`, `headRefName` is `branch-x`, `state` is `OPEN`, and `mergeable` is `MERGEABLE`.

9. Merge with a merge commit and delete the remote branch:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

10. Capture the PR merge commit SHA:

```bash
gh pr view <PR_NUMBER> --json mergeCommit
```

Set `merge_sha` to the returned merge commit OID. Stop if GitHub does not report a merge commit.

11. Ensure the local default branch is current:

```bash
git checkout "$base_branch"
git pull --ff-only origin "$base_branch"
```

12. Tag the PR merge commit and push the tag:

```bash
git tag "$release_tag" "$merge_sha"
git push origin "$release_tag"
```

13. Delete the old local branch if it still exists:

```bash
git branch --list branch-x
git branch -d branch-x
```

If `gh pr merge --delete-branch` already deleted the local branch, skip `git branch -d branch-x`.

14. Recreate the branch from the latest default branch:

```bash
git checkout -b branch-x
```

## Verification

Run these checks after recreating the branch:

```bash
git branch --show-current
git log --oneline "$base_branch..branch-x"
git ls-remote --heads origin branch-x
git tag --points-at "$merge_sha"
git ls-remote --tags origin "$release_tag"
git status --short --branch
gh pr view <PR_NUMBER> --json state,mergedAt,mergeCommit,url
cat VERSION
```

Expected results:

- Current branch is `branch-x`.
- `git log --oneline "$base_branch..branch-x"` is empty.
- `git ls-remote --heads origin branch-x` is empty.
- `git tag --points-at "$merge_sha"` includes `$release_tag`.
- `git ls-remote --tags origin "$release_tag"` returns the remote tag.
- Worktree is clean.
- PR state is `MERGED`.
- `VERSION` contains `$release_version`.

## Reporting

Summarize the completed cycle with:

- PR URL and PR number.
- Merge commit SHA.
- Release version and tag.
- Detected base branch.
- Current branch.
- Whether remote `branch-x` is deleted.
- Whether remote `$release_tag` exists.
- Whether local `branch-x` was recreated from the latest default branch.
