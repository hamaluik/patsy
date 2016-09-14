var project = new Project('Patsy');

project.windowOptions = {
	width : 960,
	height : 540
};

project.addSources('src');
project.addAssets('assets/final/**')

project.addLibrary("mammoth");
project.addLibrary("edge");

(function setupMammoth() {
	var libDir = '';
	var results = require('child_process').execSync('haxelib list').toString().split('\n');
	for (var i = 0; i < results.length; i++) {
		if(results[i].startsWith('mammoth: [')) {
			var libPart = results[i].substring(10, results[i].length - 1);
			libDir = libPart.substr(libPart.indexOf(':') + 1);
			break;
		}
	}
	console.log('  <mammoth> library location: ' + libDir);
	const fs = require('fs');

	// load all the resources
	var resourceTypes = ['shader', 'font', 'image'];
	for (var i = 0; i < resourceTypes.length; i++) {
		var resourcesDir = libDir + "/src/assets/" + resourceTypes[i] + "s";
		var resources = fs.readdirSync(resourcesDir);
		for (var j = 0; j < resources.length; j++) {
			var resourceFile = resourcesDir + '/' + resources[j];
			project.addParameter('-resource ' + resourceFile + '@' + resourceTypes[i] + '/' + resources[j]);
			console.log('  <mammoth> added built-in ' + resourceTypes[i] + ': ' + resources[j]);
		}
	}
})();

project.addParameter('-debug');
project.addParameter('-D source-map-content');

resolve(project);
