soundManager.url = 'soundmanager/swf/';
soundManager.debugMode = false;

soundManager.onready(function(){
  function loop(){
    setTimeout(function(){
      var sound = sounds.splice( 0, 1 ),
      clearDivContents = function( klasses ){
	console.log( klasses );
	for( var i=0; i < klasses.length; i+=1 ){
	  $( klasses[i] ).children().detach();
	}
      };

    if( sound.length > 0 ){
      $("#container").text( sound[0][0] + "?" );
      console.log( "Playing " + sound[0][1] );
      var mySound = soundManager.createSound({
	id: sound[0][0],
	  url: "/play?filename=" + sound[0][1]
      });
      mySound.play();

      if ( sound[0][0] === presets[0] ){
	console.log( "Display random image of person" );
	$("#person").append( "<img src='images/people/person.jpeg'></img>" );
	clearDivContents( ["#object"] );
      }else if ( sound[0][0] === presets[1] ){
	console.log( "Display random image of object" );
	$("#object").append( "<img src='images/objects/object.jpeg'></img>" );
	clearDivContents( ["#person"] );
      }else{
	clearDivContents( ["#person", "#object"] );
      }
      document.title =  "Sound Loop: " + sound[0][0];
      $("#question_item > ul").append( "<li>" + sound[0][0] + "?" + "</li>" );

      loop();
    }else{
      document.title =  "Sound Loop: End of Session.";
      $("#container").text( "End of Session." );
      clearDivContents( ["#person", "#object"] );
    }
    }, 5000);
  }

  loop();

});

