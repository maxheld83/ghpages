# GitHub Action to Deploy Static Assets to GitHub Pages

> This action lets you deploy folders of static content to [GitHub pages](https://pages.github.com).

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/maxheld83/ghpages)](https://github.com/maxheld83/ghpages/actions)
[![View Action](https://img.shields.io/badge/view-action-blue.svg)](https://github.com/marketplace/actions/github-pages-deploy)

<!-- New picture -->

This works by having your GitHub action `git push` your chosen asset folder (`BUILD_DIR`) to the `gh-pages` branch of your GitHub repository for the `gh-pages` branch to be served.

<!-- Content around filtering action to build site -->

Remember that you may also have to adjust your [repository settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).

Because this action deploys to separate, "deploy-only" branches, you can not use it if you want to deploy from a repo subdirectory such as `docs/`.
In those cases you really don't need a GitHub Action, because you would be committing the build artifacts yourself.
For details see the [GitHub Pages Documentation](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/). 

There are already great GitHub actions to use static site generators *and* then deploy to GitHub Pages (for [jekyll](https://github.com/helaili/jekyll-action), [jekyll](https://github.com/BryanSchuetz/jekyll-deploy-gh-pages), [zola](https://github.com/shalzz/zola-deploy-action) and surely many more to come).
This action isn't that, though I've borrowed much of the git action from these works.

**This action will not build anything, it just deploys.**


## Secrets

<!-- New image -->

Deployment to GitHub pages happens by `git push`ing to the `gh-pages` (or `master`) branch. The GitHub action needs a secret to authorise the deployment.

For now, the `GITHUB_TOKEN` [available for every repo](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) *does*  push to `gh-pages`, but *does not* trigger a page build on GitHub, or even send the new content to the GitHub content-delivery network.

You **have to [create a custom Personal Access Token (PAT)](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)** much like you'd do for external services (say, Travis). You then have to paste this token into the GitHub UI as a secret under the name `GH_PAT` (repository settings/secrets) and call it in the action as in the below.

I've asked GitHub to streamline this process. The discussion is documented [here](https://github.com/maxheld83/ghaction-ghpages/issues/1).

## Example Usage

<!-- New image -->

```yml
name: Deploy Site to GitHub Pages

on:
  push:
    branches:
    - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: npm install and build
        run: |
          npm install
          npm run build
      - name: Deploy site to gh-pages branch
        uses: maxheld83/ghpages@v1.0.0
        with:
          repo-token: ${{ secrets.GH_PAT }}
```
