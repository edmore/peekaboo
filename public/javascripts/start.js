soundManager.url = 'soundmanager/swf';
soundManager.debugMode = false;

soundManager.onready(function(){
  if( files.length > 0 ){
    for( var i=0; i < files.length; i+=1 ){
      var mySound = soundManager.createSound({
	id: 'Sound'+ i,
	url: "/play?filename=" + files[i][1]
      });
      console.log("Currently playing...." + files[i][0]);
      mySound.play();
    }
  }
});

