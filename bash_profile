# .bash_profile

. ~/.sensesys
. ~/.tailorsys

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
if [ -f ~/.tailorhost ]; then
  . ~/.tailorhost
fi

# User specific environment and startup programs
#export ENV=$HOME/.bashrc
export USERNAME=`whoami`


##set echo
##stty dec -tabs
#stty kill '^u' erase '' intr '^c'
##stty rows 40 cols 80
#setenv TERMCAP ~/.termcap
#setenv DISPLAY $HOST":0.0"
export MWMSHELL=/bin/csh
export EXINIT='set noslow sm'

##setenv HACKOPTIONS 'name:"El-Rayo-X-C",male,restonspace'
##setenv EMPIREHOST 128.178.120.5
##setenv EMPIREPORT 1617
#setenv MOZILLA_HOME /usr/local/netscape

#set ignoreeof
#set noclobber
#if ( $OS == HPUX ) then
#    set tty=`/bin/tty`
#else
#    set tty=`/usr/bin/tty`
#endif
#set filec
##biff y

if [ "$TERM" = "linux" ] ; then
    echo "Windowing:"
    echo "	1 - AfterStep under XFree86 X11R6 Server"
    echo "	2 - WindowMaker under XFree86 X11R6 Server"
    echo "	3 - FVWM under XFree86 X11R6 Server"
    echo "	4 - GNOME/Enlightenment Windor Manager under XFree86 X11R6 Server"
    echo "	5 - Motif Window Manager under X11R5 MIT Server"
    echo "	6 - Motif Window Manager under X11R6 MIT Server"
    echo "	x - Exit"
    echo -n "Selection: "
    read a
    case $a in
      1)
	setenv MANPATH /usr/man/:/usr/local/man:/usr/X11R6/man
        echo Afterstep > .wm_style
        startx
#	setenv LD_LIBRARY_PATH "/usr/lib:/usr/openwin/lib:/usr/local/X11/lib"
#	setenv XAPPLRESDIR /usr/local/X11/lib/X11/app-defaults
#	set path=(. $HOME/BIN/$ARCH/$OS /bin /usr/bin /usr/ucb /usr/openwin/bin /usr/local/X11/bin /usr/local/bin /usr/local/gnu/bin)
#	copy ~/.DOTS/xinitrc-X11-$ARCH-$OS ~/.xinitrc
#	openwin -noauth
	;;

      2)
	setenv MANPATH /usr/man/:/usr/local/man:/usr/X11R6/man
        echo WindowMaker > .wm_style
        startx
#	setenv LD_LIBRARY_PATH "/usr/local/X11/lib:/usr/lib:/usr/openwin/lib"
#	set path=(. $HOME/BIN/$ARCH/$OS /bin /usr/bin /usr/ucb /usr/local/X11/bin /usr/openwin/bin /usr/local/bin /usr/local/gnu/bin)
##	copy ~/.DOTS/xinitrc-X11-$ARCH-$OS ~/.xinitrc
#	xinit
	;;

      3)
	setenv MANPATH /usr/man/:/usr/local/man:/usr/X11R6/man
        echo fvwm > .wm_style
        startx
#	setenv LD_LIBRARY_PATH "/usr/local/X11R6/lib:/usr/lib:/usr/openwin/lib"
#	set path=(. $HOME/BIN/$ARCH/$OS /bin /usr/bin /usr/ucb /usr/local/X11R6/bin /usr/openwin/bin /usr/local/bin /usr/local/gnu/bin)
#	rm ~/.xinitrc
#	echo "xhost - 2>> /dev/null" > ~/.xinitrc
#	echo "xmodmap $HOME/.DOTS/xmodmap.sparc" >> ~/.xinitrc
#	echo "xset	c fp default s on s noblank s 300 30" >> ~/.xinitrc
#	echo "xbiff -geom =48x48+1030+0 &" >> ~/.xinitrc
#	echo "clock -geometry 64x64+1085+0 &" >> ~/.xinitrc
#	echo "xterm -C -n CONSOLE -T CONSOLE -iconic -geom =80x4+0+0 &" >> ~/.xinitrc
#	echo "xterm -geom =80x40+32+132 -fn 8x13 -T MDM-1 -n MDM-1 &" >> ~/.xinitrc
#	echo "xterm -geom =80x40+64+164 -fn 8x13 -T MDM-2 -n MDM-2 &" >> ~/.xinitrc
#	echo "xterm -geom =80x40+96+196 -fn 8x13 -T MDM-3 -n MDM-3 &" >> ~/.xinitrc
#	echo "vtwm" >> ~/.xinitrc
#	xinit
	;;

      4)
	setenv MANPATH /usr/man/:/usr/local/man:/usr/X11R6/man
        echo gnome-e > .wm_style
        startx
#	setenv LD_LIBRARY_PATH "/usr/openwin/lib"
#	echo $ARCH
#	cp ~/.DOTS/xinitrc-openwin-$ARCH-$OS ~/.xinitrc
#	openwin -noauth
#	clear
	;;

      5)
#	setenv LD_LIBRARY_PATH "/usr/local/X11/lib:/usr/lib:/usr/openwin/lib"
#	set path=(. $HOME/BIN/$ARCH/$OS /bin /usr/bin /usr/ucb /usr/local/X11/bin /usr/bin/X11 /usr/openwin/bin /usr/local/bin /usr/local/gnu/bin)
#        cp ~/.DOTS/xinitrc-Xm-$ARCH-$OS ~/.xinitrc
##	openwin -noauth
#	xinit
#	kbd_mode -a
#	clear
	;;

      6)
#	setenv LD_LIBRARY_PATH "/usr/local/X11R6/lib:/usr/lib:/usr/openwin/lib"
#	set path=(. $HOME/BIN/$ARCH/$OS /bin /usr/bin /usr/ucb /usr/local/X11R6/bin /usr/openwin/bin /usr/local/bin /usr/local/gnu/bin)
#	rm ~/.xinitrc
#	echo "xhost - 2>> /dev/null" > ~/.xinitrc
#	echo "xmodmap $HOME/.DOTS/xmodmap.sparc" >> ~/.xinitrc
#	echo "xset	c fp default s on s noblank s 300 30" >> ~/.xinitrc
#	echo "xbiff -geom =48x48+1030+0 &" >> ~/.xinitrc
#	echo "clock -geometry 64x64+1085+0 &" >> ~/.xinitrc
#	echo "xterm -C -n CONSOLE -T CONSOLE -iconic -geom =80x4+0+0 &" >> ~/.xinitrc
#	echo "xterm -geom =80x40+32+132 -fn 8x13 -T MDM-1 -n MDM-1 &" >> ~/.xinitrc
#	echo "xterm -geom =80x40+64+164 -fn 8x13 -T MDM-2 -n MDM-2 &" >> ~/.xinitrc
#	echo "xterm -geom =80x40+96+196 -fn 8x13 -T MDM-3 -n MDM-3 &" >> ~/.xinitrc
#	echo "mwm" >> ~/.xinitrc
#	xinit
	;;

      *)
#	set term = vt100
#	tset -e
#	reset
	;;
    esac

elif [ "$TERM" = "xterm" ] ; then
          set noglob
#          eval `tset -Q -s -i -e -k xterm`
#          eval `tset -Q -s xterm`
          unset noglob

elif [ "$TERM" = "sun" ] ; then
    set term = vt100
#    tset
#    reset
#    unsetenv DISPLAY
fi
