workflow "Test ghpages" {
  on = "push"
  resolves = ["Deploy to GitHub Pages"]
}

action "Write sha" {
  uses = "actions/bin/sh@db72a46c8ce298e5d2c3a51861e20c455581524f"
  args = ["echo $GITHUB_SHA >> public/index.html"]
}

action "Deploy to GitHub Pages" {
  uses = "./"
  needs = "Write sha"
  env = {
    BUILD_DIR = "public/"
  }
  secrets = ["GH_PAT"]
}
