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