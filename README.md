PhotoImporter
=============

PhotoImporter is a small tool to import photos into the iOS simulator's Camera Roll.

PhotoImporter is similar to the tool here:

  http://aptogo.co.uk/2010/09/importing-photos/

but avoids the need to copy files into the simulator file system by hand.

Dependencies:
-------------

PhotoImporter depends on ruby and Sinatra on the development system as well as Xcode.

Usage:
------

First, on your development system run:

    $ <PhotoImporter Path>/tools/pi-instaweb photo1.jpg photo2.jpg ...
    == Sinatra/1.3.2 has taken the stage on 4567 for development with backup from Thin
    >> Thin web server (v1.4.1 codename Chromeo)
    >> Maximum connections set to 1024
    >> Listening on 0.0.0.0:4567, CTRL+C to stop

Take note of the address that Sinatra says it's listening on (0.0.0.0:4567 in the example above).  This will start a small web application that serves photo1.jpg, photo2.jpg, ... to PhotoImporter.

Next, run the PhotoImporter app on the simulator from within Xcode. When PhotoImporter starts add the address from Sinatra (i.e. 0.0.0.0:4567) and press go.

When done, press CTRL+C to stop pi-instaweb.

That's it!


