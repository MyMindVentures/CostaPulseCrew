# Codex task: clean import of SaaS Boilerplate

## Goal
Replace the contents of this branch with a clean import of the free MIT-licensed repository:

- Source: https://github.com/ixartz/SaaS-Boilerplate
- Target repository: https://github.com/MyMindVentures/CostaPulseCrew
- Target branch: `codex/import-saas-template`
- Base branch: `main`

## Requirements

1. Do not use GitHub Actions.
2. Do not preserve the source repository's Git history.
3. Import the complete current contents of the source repository, including dotfiles, assets, configuration, lockfiles, tests, and the MIT license.
4. Remove this `CODEX_TASK.md` file as part of the final imported result.
5. Do not include the source `.git` directory.
6. Keep the work on this PR branch. Do not force-push or write directly to `main`.
7. Use one or more normal commits on this branch.
8. Verify that the resulting project files match the source template and that no temporary import scripts or archives remain.
9. Report any files that cannot be copied, any license concern, or any build/install failure in the PR description or a PR comment.

## Suggested procedure

```bash
git clone --depth 1 https://github.com/ixartz/SaaS-Boilerplate.git /tmp/saas-template
rm -rf /tmp/saas-template/.git
find . -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
cp -a /tmp/saas-template/. .
git add -A
git commit -m "Import ixartz SaaS Boilerplate as clean project base"
```

Then run the project's documented install, lint, type-check, test, and build commands where feasible. Do not add secrets or generated dependency folders such as `node_modules`.
