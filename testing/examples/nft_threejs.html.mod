<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">

	<title>Pattern marker example with Three.js</title>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
<style>
html,body {
	margin: 0;
	padding: 0;
	width: 100%;
	text-align: center;
	overflow-x: hidden;
}
.portrait canvas {
	transform-origin: 0 0;
	transform: rotate(-90deg) translateX(-100%);
}
.desktop canvas {
 	transform: scale(-1, 1);
}
</style>
</head>
<body>

<h1>NFT marker example with Three.js</h1>
<p>On Chrome on Android, tap the screen to start playing video stream.</p>
<p>Show  <a href="https://github.com/artoolkit/artoolkit5/blob/master/doc/Marker%20images/pinball.jpg">Pinball image</a> to camera to display a colorful object on top of it. Tap the screen to rotate the object.

<p>&larr; <a href="index.html">Back to examples</a></p>

<script async src="js/third_party/three.js/three.min.js"></script>

<script async src="js/artoolkit.min.js"></script>
<script async src="js/artoolkit.three.js"></script>

<script src="https://threejs.org/examples/js/ParametricGeometries.js"></script>
<script src="https://threejs.org/docs/scenes/js/geometry.js"></script>

<script>

window.ARThreeOnLoad = function() {

	ARController.getUserMediaThreeScene(
			{
				maxARVideoSize: 320,
				cameraParam: 'Data/camera_para-iPhone 5 rear 640x480 1.0m.dat',
				onSuccess: function(arScene, arController, arCamera) {

					document.body.className = arController.orientation;

					var renderer = new THREE.WebGLRenderer({antialias: true});

					if (arController.orientation === 'portrait') {
						var w = (window.innerWidth / arController.videoHeight) * arController.videoWidth;
						var h = window.innerWidth;
						renderer.setSize(w, h);
						renderer.domElement.style.paddingBottom = (w-h) + 'px';
					} else {
						if (/Android|mobile|iPad|iPhone/i.test(navigator.userAgent)) {
							renderer.setSize(window.innerWidth, (window.innerWidth / arController.videoWidth) * arController.videoHeight);
						} else {
							renderer.setSize(arController.videoWidth, arController.videoHeight);
							document.body.className += ' desktop';
						}
					}
					renderer.domElement.className = "testing";
					document.body.insertBefore(renderer.domElement, document.body.firstChild);

					var rotationV = 0;
					var rotationTarget = 0;

					renderer.domElement.addEventListener('click', function(ev) {
						ev.preventDefault();
						rotationTarget += 1;
					}, false);


					// ***** Clipping planes: *****
					var localPlane = new THREE.Plane( new THREE.Vector3( 0, - 1, 0 ), 0.8 );
					var globalPlane = new THREE.Plane( new THREE.Vector3( - 1, 0, 0 ), 0.1 );
					// Geometry
					var material = new THREE.MeshPhongMaterial( {
								color: 0x80ee10,
								shininess: 100,
								side: THREE.DoubleSide,
								// ***** Clipping setup (material): *****
								clippingPlanes: [ localPlane ],
								clipShadows: true
							} );
					var geometry = new THREE.TorusKnotGeometry( 0.4, 0.08, 95, 20 );
					// var geometry = new THREE.TorusKnotGeometry( 10, 3, 100, 16 );
					var material = new THREE.MeshBasicMaterial( { color: 0xffff00 } );
					var torusKnot = new THREE.Mesh( geometry, material );
					torusKnot.material.shading = THREE.FlatShading;
					torusKnot.position.z = 50;
					torusKnot.position.x = 100;
					torusKnot.position.y = 100;
					torusKnot.scale.set(80,80,80);
					torusKnot.castShadow = true;
					// scene.add( object );


					var spotLight = new THREE.SpotLight( 0xffffff );
					spotLight.angle = Math.PI / 5;
					spotLight.penumbra = 0.2;
					spotLight.position.set( 2, 3, 3 );
					spotLight.castShadow = true;


					var lights = [];
					lights[ 0 ] = new THREE.PointLight( 0xffffff, 1, 0 );
					lights[ 1 ] = new THREE.PointLight( 0xffffff, 1, 0 );
					lights[ 2 ] = new THREE.PointLight( 0xffffff, 1, 0 );

					lights[ 0 ].position.set( 0, 200, 0 );
					lights[ 1 ].position.set( 100, 200, 100 );
					lights[ 2 ].position.set( - 100, - 200, - 100 );

					var mesh = new THREE.Object3D();

					mesh.add( new THREE.LineSegments(

							new THREE.Geometry(),

							new THREE.LineBasicMaterial( {
								color: 0xffffff,
								transparent: true,
								opacity: 0.5
							} )

					) );

					mesh.add( new THREE.Mesh(

							new THREE.Geometry(),

							new THREE.MeshPhongMaterial( {
								color: 0x156289,
								emissive: 0x072534,
								side: THREE.DoubleSide,
								shading: THREE.FlatShading
							} )

					) );


					arController.loadNFTMarker('DataNFT/freedom_sw', function(markerId) {




						var markerRoot = arController.createThreeNFTMarker(markerId);
						//markerRoot.add( new THREE.AmbientLight( 0x505050 ) );
						markerRoot.add( lights[ 0 ] );
						markerRoot.add( lights[ 1 ] );
						markerRoot.add( lights[ 2 ] );
						markerRoot.add(spotLight);
						markerRoot.add(mesh);
						arScene.scene.add(markerRoot);
					});

					/*arController.loadMarker('Data/patt.kanji', function(markerId) {
						var markerRoot = arController.createThreeMarker(markerId);
						markerRoot.add(torus);
						arScene.scene.add(markerRoot);
					});*/

					var tick = function() {
						arScene.process();

						rotationV += (rotationTarget - torusKnot.rotation.z) * 0.05;
						torusKnot.rotation.z += rotationV;
						//torus.rotation.y += rotationV;
						rotationV *= 0.8;

						arScene.renderOn(renderer);
						requestAnimationFrame(tick);
					};

					tick();

				}
			}
	);

	delete window.ARThreeOnLoad;

};

if (window.ARController && ARController.getUserMediaThreeScene) {
	ARThreeOnLoad();
}
</script>

</body>
</html>