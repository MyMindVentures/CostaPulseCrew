# Railway one-shot SaaS template importer

This temporary service imports the free MIT-licensed `ixartz/SaaS-Boilerplate` repository into a separate branch of `MyMindVentures/CostaPulseCrew` without preserving the source Git history.

## Railway deployment

Deploy the GitHub branch `railway/import-saas-template` as a Railway service. Railway detects the root `railway.json`, builds `railway-importer/Dockerfile`, runs the importer once, and does not restart it after exit.

Set these Railway variables:

| Variable | Required | Value |
|---|---:|---|
| `GITHUB_TOKEN` | Yes | Fine-grained GitHub token with **Contents: Read and write** access to `MyMindVentures/CostaPulseCrew` |
| `CONFIRM_IMPORT` | Yes | `CostaPulseCrew` |
| `TARGET_REPO` | No | Defaults to `MyMindVentures/CostaPulseCrew` |
| `TARGET_BRANCH` | No | Defaults to `setup/saas-template` |
| `SOURCE_REPO_URL` | No | Defaults to `https://github.com/ixartz/SaaS-Boilerplate.git` |
| `SOURCE_REF` | No | Defaults to `main` |
| `GIT_AUTHOR_NAME` | No | Defaults to `Railway Importer` |
| `GIT_AUTHOR_EMAIL` | No | Defaults to `railway-importer@users.noreply.github.com` |

## Safety behavior

- Refuses to run without `CONFIRM_IMPORT=CostaPulseCrew`.
- Refuses to push directly to `main` or `master`.
- Deletes the source `.git` directory.
- Creates one clean commit.
- Force-updates only the configured import branch.
- Does not print the GitHub token.
- Cleans its temporary workspace on exit.

## After success

1. Open a pull request from `setup/saas-template` to `main`.
2. Review the imported license and project files.
3. Delete the Railway service and its `GITHUB_TOKEN` variable.
4. Remove this temporary importer branch when it is no longer needed.
