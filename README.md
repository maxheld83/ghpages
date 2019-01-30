# Deploy arbitrary static assets to GitHub Actions

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/maxheld83/ghaction-ghpages)](https://github.com/maxheld83/ghaction-ghpages/actions)

This action simply lets your deploy arbitrary folders of static content from your actions working directory (`/github/workspace`) to [GitHub pages](https://pages.github.com).
This works by just git commiting your chosen asset folder (`BUILD_DIR`) to the `gh-pages` branch of your GitHub repository.
Remember that you may also have to adjust your [repository settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).

There are already great GitHub actions to use static site generators *and* then deploy to GitHub Pages (for [jekyll](https://github.com/helaili/jekyll-action), [jekyll](https://github.com/BryanSchuetz/jekyll-deploy-gh-pages), [zola](https://github.com/shalzz/zola-deploy-action) and surely many more to come).
This action isn't that, though I've borrowed much of the git action from these works.

**This action will not build anything, it just deploys.**.


## Secrets

You just need to check the pre-configured `GITHUB_TOKEN` for this action.


## Environment Variables

Just `BUILD_DIR`, the build directory relative to your repository root.


## Arguments

There are none.


## Example Usage

```
action "Deploy to GitHub Pages" {
  uses = "maxheld83/ghaction-ghpages"
  env = {
    BUILD_DIR = "public/"
  }
  secrets = ["GITHUB_TOKEN"]
}
```
