soundManager.url = 'soundmanager/swf/';
soundManager.debugMode = false;

soundManager.onready(function(){
  var mySounds = [];

  if( sounds.length > 0 ){
    for( var i=0; i < sounds.length; i+=1 ){
      mySounds.push( soundManager.createSound({
	id: sounds[i][0],
	url: "/play?filename=" + sounds[i][1]
      })
	);
    }
    console.log(mySounds);
  }
});

