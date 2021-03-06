ng-json-explorer
================

Simple json explorer angular directive that uses raw json data as source.

This module is based in the firefox jsonview extension made by Ben Hollis: https://github.com/bhollis/jsonview/

Modifications by Robin Hu.

Usage
-------------------------
Check the demo folder (demo.html) for a simple example.
Include the required files (js and css). 
This module is obviously dependent on angularJS, so include that.

-------------------------
```
<script src="bower_components/angular/angular.js"></script>
<script src="dist/jsonexplorer.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="dist/all.css" />
```

Send the json data to your template
-------------------------
```
$scope.data = {
	'name': 'Json Explorer',
	'qty': 10,
	'has_data': true,
	'arr': [
		10,
		'str',
		{
			'nested': 'object'
		}
	],
	'obj': {
		'hello': 'world'
	}
};
```

Using the directive to display the data
-------------------------
```
<json-explorer json-data="data"></json-explorer>
```

How To Build Source
--------------------------

Make sure you have node.js installed.
```
npm install
bower install
grunt
```
