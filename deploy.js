const dotenv = require("dotenv")
const fs = require("fs")
const path = require("path")
dotenv.config()

function getDirs() {
	return fs.readdirSync(__dirname).filter(function (file) {
		return fs.statSync(path.join(__dirname, file)).isDirectory()
	})
}

function filterDirs(dirs) {
	const forbidden = ["node_modules"]
	const allowed = process.env.DEPLOY_DIRS
		? process.env.DEPLOY_DIRS.split(",")
		: []

	return dirs
		.filter((dir) => !forbidden.includes(dir))
		.filter((dir) => allowed.includes(dir))
}

const dirs = filterDirs(getDirs())

console.log("loading deployment scripts")
const deploys = dirs.map((dir) => {
	const deployFunctionPath = path.resolve(__dirname, dir, "deploy.js")
	return require(deployFunctionPath)
})

const env = process.env
env.BACKEND_API_URL = `https://${env.BACKEND_APP_NAME}.herokuapp.com`

console.log("deployment started")
deploys.forEach((deploy) => deploy({ env }))
console.log("deployed successfully")
