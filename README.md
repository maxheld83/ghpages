# GitHub Action to Deploy Static Assets to GitHub Pages

**This action has been deprecated.
There's [now "native" support for publishing to GitHub Pages using an official GitHub action by GitHub](https://github.com/actions/deploy-pages).
It is much better than this approach.**

<!-- badges: start -->
[![Actions Status](https://github.com/maxheld83/ghpages/workflows/Deployment/badge.svg)](https://github.com/maxheld83/ghpages/actions)
<!-- badges: end -->

This action simply lets you deploy arbitrary folders of static content from your workflow's working directory (`/github/workspace`) to [GitHub pages](https://pages.github.com).
This works by having your action instance `git push` your chosen asset folder (`BUILD_DIR`) to the `gh-pages` branch of your GitHub repository for the `gh-pages` branch to be served.
If you are running this action inside an [organization or user repository](https://help.github.com/articles/user-organization-and-project-pages/) (named `username/username.github.io`) it will deploy to the `master` branch instead.

Remember that you may also have to adjust your [repository settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).

Because this action deploys to separate, "deploy-only" branches, you can not use it if you want to deploy from a repo subdirectory such as `docs/`.
In those cases you really don't need a GitHub Action, because you would be committing the build artifacts yourself.
For details see the [GitHub Pages Documentation](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).

There are already great GitHub actions to use static site generators *and* then deploy to GitHub Pages (for [jekyll](https://github.com/helaili/jekyll-action), [jekyll](https://github.com/BryanSchuetz/jekyll-deploy-gh-pages), [zola](https://github.com/shalzz/zola-deploy-action) and surely many more to come).
This action isn't that, though I've borrowed much of the git action from these works.

**This action will not build anything, it just deploys.**

## Inputs

None.


## Outputs

None.


## Secrets

Deployment to GitHub pages happens by `git push`ing to the `gh-pages` (or `master`) branch.
To authorise this, the GitHub action needs a secret.
For now, somewhat confusingly, the `GITHUB_TOKEN` [available for every repo](https://developer.github.com/actions/creating-workflows/storing-secrets/) *does* suffice to push to `gh-pages`, but *does not* suffice to trigger a  page build on GitHub, or even propagate the content to the GitHub content-delivery network.

You therefore **have to [create a custom Personal Access Token (PAT)](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)** much like you'd do for external services (say, Travis). This token must be created with `repo` permissions in order to deploy to Github Pages.
You then have to paste this token into the GitHub UI as a secret under the name `GH_PAT` (repository settings/secrets) and call it in the action as in the below.

I've asked GitHub to streamline this process.
The discussion is documented [here](https://github.com/maxheld83/ghaction-ghpages/issues/1).


## Environment Variables

Just `BUILD_DIR`, the build directory relative to your repository root.
You can also pass `.` if you want to push your repository root.


## Example Usage

```yaml
name: Deployment

"on":
  - push
  - pull_request

jobs:
  deploy_ghpages:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v1
      - run: echo $GITHUB_SHA >> public/index.html
      - uses: maxheld83/ghpages@v0.3.0
        env:
          BUILD_DIR: public/
          GH_PAT: ${{ secrets.GH_PAT }}
```
