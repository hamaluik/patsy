var project = new Project('Patsy');

project.windowOptions = {
	width : 960,
	height : 540
};

project.addSources('src');
project.addAssets('assets/final/**')

project.addLibrary("mammoth");
project.addLibrary("edge");

project.addParameter('-debug');
project.addParameter('-D source-map-content');

resolve(project);
