soundManager.url = 'soundmanager/swf/';
soundManager.debugMode = false;

soundManager.onready(function(){
  function loop(){
    setTimeout(function(){
      var sound = sounds.splice( 0, 1 ),
	  clearDivContents = function( klasses ){
	    for( var i=0; i < klasses.length; i+=1 ){
	      $( klasses[i] ).children().detach();
	    }
	  },
          getRandomImage = function( images ){
            var max = images.length - 1,
                random_image_index = Math.floor(Math.random() * (max - 0 + 1)) + 0;
                console.log( "Displaying image : " + images[random_image_index] );
            return images[random_image_index];
	  },
          buildImageHtml = function( klass, src){
	      $( klass ).html( "<img></img>");
	      $( klass + " > img" ).attr("src", src);
	  };

    if( sound.length > 0 ){
      $("#container").text( sound[0][0] + "?" );
      console.log( "Playing : " + sound[0][1] );
      var mySound = soundManager.createSound({
	id: sound[0][0],
	  url: "/play?filename=" + sound[0][1]
      });
      mySound.play();

      if ( sound[0][0] === presets[0] ){
	if ( people.length > 0 ){
	  var person_to_display = getRandomImage ( people ),
	    person_img_src = "/images/people/" + person_to_display;

	  buildImageHtml( "#person", person_img_src )
	}else{
	  $("#person").html( "<div>Please populate your people folder in images</div>" );
	}
	clearDivContents( ["#object"] );

      }else if ( sound[0][0] === presets[1] ){
	if ( objects.length > 0 ){
	  var object_to_display = getRandomImage ( objects ),
	    object_img_src = "/images/objects/" + object_to_display;

	  buildImageHtml( "#object", object_img_src )
	}else{
	  $("#object").html( "<div>Please populate your objects folder in images</div>" );
	}
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

