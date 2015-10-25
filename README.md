## USB Shenanigans

### For OS X with docker-machine provided via VirtualBox

We flash code onto Nordic devices via USB. Unfortunately it's a bit of a pain to expose the USB bus to a docker container which is running inside of a VirtualBox VM. Don't fear though, after following these step-by-step instructions you'll not have to think about USB again.

* create a docker machine using something like `docker-machine create dev --provider virtualbox`, if you haven't already
* shutdown your docker machine using something like `docker-machine stop dev`
* insert a Nordic dongle into one of your mac's USB ports
* configure the docker-machine VM to have access to the Nordic dongle:
  * Fire up the VirtualBox UI open up the settings for your docker machine VM
  * Select Ports, select USB
  * Check the Enable USB Controller box
  * Add a USB Device Filter for the SEGGER J-Link device
* remove the dongle
* start up the newly configured docker machine VM with something like `docker-machine start dev`
* insert the dongle

You should now be able to flash the dongle via the docker container. 

The only thing you need to remember going forward is that you need to **insert the USB dongle *after* starting up the docker-machine VM**. If you're having trouble flashing from a docker container try just removing and re-inserting the dongle.

To test whether your docker container has access to the Nordic device via USB, run `JLinkExe` from within the container. If you get a message saying `Can not connect to J-Link via USB.` then you have problems. Otherwise you're probably good to go.

# TODO list

* add a script to check whether USB is working and accessible from the container image
