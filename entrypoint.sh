#!/bin/sh

set -e

echo "#################################################"
echo "Changing directory to 'BUILD_DIR' $BUILD_DIR ..."
cd $BUILD_DIR

echo "#################################################"
echo "Now deploying to GitHub Pages..."
remote_repo="https://${GH_PAT}@github.com/${GITHUB_REPOSITORY}.git" && \
remote_branch="gh-pages" && \
git init && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
git add . && \
git commit -m 'Deploy to GitHub pages' && \
git push --force $remote_repo master:$remote_branch && \
rm -fr .git && \
cd .. && \
echo "Content of $BUILD_DIR has been deployed to GitHub Pages."
