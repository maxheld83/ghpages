import {exec} from 'child_process';
import * as core from '@actions/core';
import * as github from '@actions/github';

const repoToken = core.getInput('repo-token', {required: true});
const siteDirectory = core.getInput('site-directory', {required: true});

const {pusher, repository} = github.context.payload;

const deployBranch = 'gh-pages';
const repo = (repository && repository.name) || '';
const gitUrl = `https://${repoToken}@github.com/${repo}.git`;

function execPromise(command: string):Promise<String> {
	return new Promise((resolve, reject) => {
		exec(command, (error, stdout, stderr) => {
			if (error) {
				reject(error);
				return;
			}

			resolve(stdout.trim());
		});
	});
};

(async () => {
	try {
		await execPromise(`cd ${siteDirectory}`);
		await execPromise('git init');
		await execPromise(`git config user.name ${pusher.name}`);
		await execPromise(`git config user.email ${pusher.email}`);

		const gitStatus = await execPromise(`git status --porcelain`);
		if(gitStatus){
			console.log('Nothing to deploy');
			return;
		}

		await execPromise('git add .');
		await execPromise('git commit -m "Deploy to GitHub Pages"');
		await execPromise(`git push --force ${gitUrl} master:${deployBranch}`);

		console.log(`✅ Successfully deployed to GitHub pages. The ${siteDirectory} directory has been pushed to ${deployBranch} branch`);
	} catch (error) {
		core.error(error);
		core.setFailed(`❌ Failed to deploy to GitHub pages: ${siteDirectory} directory failed to push to ${deployBranch} branch\n${error}`);
	}
})();
