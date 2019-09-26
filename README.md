# GitHub Action to Deploy Static Assets to GitHub Actions

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/maxheld83/ghpages)](https://github.com/maxheld83/ghpages/actions)
[![View Action](https://img.shields.io/badge/view-action-blue.svg)](https://github.com/marketplace/actions/github-pages-deploy)

<img src="https://github.com/maxheld83/ghpages/blob/master/action-running.gif?raw=true" align="right" width=200/>

This action simply lets you deploy arbitrary folders of static content from your workflow's working directory (`/github/workspace`) to [GitHub pages](https://pages.github.com).
This works by having your action instance `git push` your chosen asset folder (`BUILD_DIR`) to the `gh-pages` branch of your GitHub repository for the `gh-pages` branch to be served.
If you are running this action inside an [organization or user repository](https://help.github.com/articles/user-organization-and-project-pages/) (named `username/username.github.io`) it will deploy to the `master` branch instead.

Remember to add appropriate [filter action](https://github.com/actions/bin/tree/master/filter) as dependencies on this action to avoid deploying from all branches, as well as to avoid "infinite loops" where the deployment itself would trigger another run.

Remember that you may also have to adjust your [repository settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).

Because this action deploys to separate, "deploy-only" branches, you can not use it if you want to deploy from a repo subdirectory such as `docs/`.
In those cases you really don't need a GitHub Action, because you would be committing the build artifacts yourself.
For details see the [GitHub Pages Documentation](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/). 

There are already great GitHub actions to use static site generators *and* then deploy to GitHub Pages (for [jekyll](https://github.com/helaili/jekyll-action), [jekyll](https://github.com/BryanSchuetz/jekyll-deploy-gh-pages), [zola](https://github.com/shalzz/zola-deploy-action) and surely many more to come).
This action isn't that, though I've borrowed much of the git action from these works.

**This action will not build anything, it just deploys.**

**This action cannot publish a pages site that does not exist**

Currently the Github Actions feature is still in __Beta__, 
and while it is actions are unable to trigger the initial build 
on github which publishs the repos project pages site. 

If your repo does not have a project pages site yet,
for this to work you will need to push to pages from 
an account that has admin privilages on the repo, the eaisest 
way to do this is to clone the repo using the account:

```bash
$ git clone https://YOUR_USERNAME:YOUR_PASSWORD@github.com/YOUR_USERNAME/YOUR_REPO
```

Then add and commit the files to be published, ie if i wanted to serve my new docs folder:

```bash
$ git add -A docs  
$ git commit -m 'YOUR COMMIT MESSAGE'
```

And finally, you can publish it to github pages using the `gh-pages` command line tool:

```bash
$ npx gh-pages -d docs
```


## Secrets

Deployment to GitHub pages happens by `git push`ing to the `gh-pages` (or `master`) branch.
To authorise this, the GitHub action needs access to the `GITHUB_TOKEN` secret.


## Environment Variables

Just `BUILD_DIR`, the build directory relative to your repository root.
You can also pass `.` if you want to push your repository root.


## Arguments

None.


## Example Usage

<img src="https://github.com/maxheld83/ghpages/blob/master/action-in-use.png?raw=true" align="right" width=200/>

```
action "Deploy to GitHub Pages" {
  uses = "maxheld83/ghpages@v0.2.1"
  env = {
    BUILD_DIR = "public/"
  }
  secrets = ["GITHUB_TOKEN"]
}
```
