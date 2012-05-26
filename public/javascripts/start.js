soundManager.url = 'soundmanager/swf';
soundManager.onready(function(){
  if( files.length > 0 ){
    var mySound = soundManager.createSound({
      id: 'aSound',
      url: "/play?filename=" + files[0][1]
    });
    mySound.play();
  }
});

