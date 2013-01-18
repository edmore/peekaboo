Toy App for my daughter. Experimenting with Redis queuing and Text to speech synthesis.
Coded in Sinatra and JS. In browser playback using Sound Manager.

1. git clone https://github.com/edmore/peekaboo.git
2. start redis via a separate terminal [ redis-server ]
3. cd peekaboo
4. bundle install
5. ruby peekaboo.rb
6. browse http://localhost:4567

Dependencies:
- ruby >= 1.9.3
- Redis
- say and lame - Mac OS X
- espeak and lame - Linux
