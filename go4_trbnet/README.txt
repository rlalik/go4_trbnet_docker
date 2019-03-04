##################################################
##                 Introduction                 ##
##################################################



## The idea: ##

I want to:

  - install all necessary software to run
    a TRB3 data acquisition system all in one go.

By necessary software I mean:

  - root6 + dabc + stream + go4
  - trbnettools
  - daqtools
  - all libraries/packages required to run the above

Furthermore:

  - All components should compile without problems
  - All components should be compatible to each other
  - I want to start with a stable system
  - I want to make changes/updates
  - I want to revert changes if they break my running system


## The solution: ##

We put all software components in a Docker container.
Such a container (named "go4_trbnet")
has been prepared for you and is ready to use!

If you know what Docker is then skip the next section.


##################################################
##             Docker in a nutshell             ##
##################################################


What is a docker container?

  - It is sort of a virtual machine ... but not really.
  - It is a sealed "sandbox", i.e. a virtual container where
    "guest software" is separated from the host system.
  - The container includes its own minimal linux distribution
  - There are no software dependencies between the software
    in the container and the host system.
  - However, the container uses the kernel of the host system,
    (so it is rather an elaborate chroot environment than a
    virtual machine)
  - Performance of the software in the container is comparable
    to natively running processes on the host system.
  - Two or more containers can be started at the same time
  - An entire container can be dumped to a single file and can
    be started on another host
  - Containers can be conveniently shared via the docker cloud
    (which is a free service)
  - All described functionality is provided/managed by the docker daemon


How are such containers created/managed?

  - A container is compiled from a so-called Dockerfile
  - A Dockerfile is similar to a shell script,
    i.e. it contains commands which are executed line by line.
  - It starts with a "FROM" statement which tells docker which
    base system to start from (e.g. a minimal ubuntu/opensuse/fedora
    distribution, in our opensuse leap 15.0).
    The base image is pulled from the docker cloud.
  - The ensuing RUN statements are executed already inside the
    new container. They can be used to execute any command
    known to the system in the container, e.g. to install
    system packages with the package manager, download
    source packages, compile and install software
  - During container build time, if a RUN statement executes
    successfully (exit 0),
    then a new "layer" is added to the binary image of the
    container. Otherwise the compilation process breaks.
  - A Dockerfile can be extended. When compiled again,
    already successfully processed RUN statements are skipped
    (as the resulting binary layers already exist)
  - If RUN statements are removed at the end of the Dockerfile,
    the container returns to an earlier state. This takes practically
    no time, as docker simply removes some binary layers from
    the image.
  - Think of a docker container as a "binary SVN" of a 
    small linux distro. Each command in the Dockerfile is like
    a commit.
  - As a by-product of setting up your container,
    you get a fool-prof/tested/certified
    step-by-step compilation/installation manual (the Dockerfile)
    for the software collection running in the container.
    This might be useful to have, even if you decide to install
    your software natively, without using a container.


Typical use:
  - A container is started and stopped like an application,
    much unlike a virtual machine.
  - Once the container is built/compiled from the Dockerfile,
    it can be started in a matter of seconds.
  - When its job is done, the container is destroyed again.
  - On destruction, the container forgets everything that
    happened while it was running. On the next start, it is
    exactly in the last state defined by the Dockerfile.


How can I get files in and out of my container?
  - Host system directories can be easily mounted inside the
    container. (docker run -v /host/dir/:/container/dir/)
  - Those directories can be read and written from host and
    container side.


##################################################
##                  get Docker                  ##
##################################################



-- step 1 --
install docker with your package manager

(ubuntu/debian)   $ sudo apt-get install docker
(opensuse)        $ sudo zypper install docker

-- step 2 --
add your user to the docker group:
$ sudo usermod -a -G docker <username>

(you might need to log out and back in for the changes
to become effective)

-- step 3 --
start docker daemon:
$ sudo service docker start



##################################################
##             get/start go4_trbnet             ##
##################################################


-- step 1 --
get the go4_trbnet dockerfiles
$ git clone git://jspc29.x-matter.uni-frankfurt.de/projects/dockerfiles.git
$ cd dockerfiles/go4_trbnet

when you read this README, you have already done this step


-- step 2 --
Now you have three options:

  - Option 1: Start with a minimal opensuse leap 15.0, compile all TRB3 software from sources:
    Use stable commits/revisions of the source repositories.
    $ cd go4_trbnet_leap_15.0_stable_2019-03-01

  - Option 2: Start with a completely prebuilt container from the cloud. Speeds up things ...
    $ cd go4_trbnet_leap_15.0_stable_2018-03-01_prebuilt
    ### RECOMMENDED ###

  - Option 3: Like Option 1 but use newest sources (bleeding edge)
    $ cd go4_trbnet_leap_15.0_bleeding
    ### DISCOURAGED ###

  NOTE: You can start with a stable build and easily update individual components later.

-- step 3 --

In this directory you find:

  - the Dockerfile (go ahead, look inside, it is not scary)

  - two directories "conf/" and "workdir/". Both directories will be
    mounted in the container. Those directories wil NOT be reset
    when the container is stopped.

  - conf/
    contains conf.sh (and some other shell scripts and config files)
    to set environment variables
    (e.g. DAQOPSERVER, TRB3_SERVER ... ),
    and to start (or not start) certain services:
      - trbnetd
      - CTS gui backend + DAQ control webserver
      - vncserver (for Go4 and other graphical applications)
      - dhcp server for setting the IP address of your TRB
    (look at conf.sh it is pretty straightforward, adapt to your needs)
    
  - workdir/ 
    ... this will be your workdir ...
    it contains an example start.sh,
    which starts a tmux session and in it some applications (dabc, go4, a browser).
    (look at start.sh it is pretty straightforward, adapt to your needs)


-- step 4 --
Build and run your container:

$ ./build_and_run.sh 

enjoy! When everything compiled and started correctly, you will be presented with
a tmux session displaying an info text about the started services
and a list of the most important tmux hotkeys to navigate your session.

If enabled in conf.sh, a vnc server is started on port 5902 hosting a firefox window
displaying the DAQ Control overview website. (connect with vncviewer localhost:5902)


-- step 5 --
You want additional system packages or other software in my container?
You want to update to the latest versions of trbnettools/daqtools/go4 ?

no problem.

Look at your Dockerfile. At the end, there are some commented out codeblocks,
showing you how to install additional software or update TRB3-related
software.

Go ahead, extend your Dockerfile. You cannot break anything.
If you delete/comment out changes again, the container will revert exactly
to its previous state.


If you don't like my init script stuff, simply remove it and have it your own way.



##################################################
##               about / contact                ##
##################################################
##                                              ##
##         Michael Wiebusch 2019-03-03          ##
##             antiquark@gmx.net                ##
##                                              ##
##################################################

