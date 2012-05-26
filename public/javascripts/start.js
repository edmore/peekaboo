soundManager.url = 'soundmanager/swf/';
soundManager.debugMode = false;

soundManager.onready(function(){
  var mySounds = [];

  if( files.length > 0 ){
    for( var i=0; i < files.length; i+=1 ){
      mySounds.push( soundManager.createSound({
	id: files[i][0],
	url: "/play?filename=" + files[i][1]
      })
	);
    }
    console.log(mySounds);
    mySounds[0].play();
    mySounds[1].play();
  }
});

