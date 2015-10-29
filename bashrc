###(.bashrc)###################################################################
#H#
###############################################################################

if [ "$interactive" != "" ] ; then
    if [ "$OS" = "" ] ; then
       . $HOME/.sensesys
    fi
    . ~/.taylorsys

    umask 022
    stty kill '^u' erase '^?' intr '^c'
    #stty kill '^u' erase '^H' intr '^c'
fi

export SVN_EDITOR=vi
#export P4PORT=1666
#export P4USER=admin
#export P4CLIENT=mdm_home

export PS1='\h> '
export PS2='\h>> '
if [ `id -u` -eq  0 -o "$WENV_USERID" = "Admin" ]; then
  export PS1='\h# '
  export PS2='\h## '
fi

if [ "${TERM:0:5}" = "xterm" -o "$TERM_PROGRAM" = "Apple_Terminal" ] ; then
   export PROMPT_COMMAND='echo -n "]0;[$HOST:$USER]$PWD"'
   #export PROMPT_COMMAND='echo -n "]2;[$HOST:$USER]$PWD"'
elif [ "$TERM" = "cygwin" ] ; then
   export PROMPT_COMMAND='echo -n "]0;[$HOST:$USER]$PWD"'
else
   unset PROMPT_COMMAND
fi

export EXINIT='set sm noslow'
export PGPPATH=$HOME/.DOTS
export MANPATH=$MANPATH:$HOME/MAN
export PURIFYOPTIONS="-chain-length=14"
export MOZILLA_HOME=/usr/local/netscape
export PYTHONPATH=$HOME/DEV/PYTHON/LIB
export ANT_OPTS=-Xmx256m

#
#function @() { source $1.bash; }
function CRdel
    {
    for file in $*
        {
        tr -d "\015\026" < $file > $file.CRdel
        mv $file.CRdel $file
        }
    }
function Dcrypt
    {
    pgp $1
    if [ -e ${1%.pgp} ] ; then
         rm $1
    fi
    }
function Ecrypt
    {
    pgp -ea $1 Michael D. Marchionna -o $1.pgp;
    if [ -e $1.pgp ] ; then
        rm $1
    fi
    }
if [ -e /usr/local/gnu/bin/make ]; then
    alias    Make='/usr/local/gnu/bin/make -f Makefile'
else
    alias    Make='make -f Makefile'
fi
alias	 archie='rlogin quiche.CS.McGill.CA -l archie'
if [ -e /usr/local/gnu/bin/bash ]; then
    alias ccsv='exec cleartool setview -exec /usr/local/gnu/bin/bash'
else
    if [ -e /usr/local/bin/bash ]; then
        alias ccsv='exec cleartool setview -exec /usr/local/bin/bash'
    else
        alias ccsv='cleartool setview'
    fi
fi
alias	 cdconn='telnet cdconnection.com'
function CDpick
    {
    discs=`grep -v -e '^-' $HOME/MISC/CDdrawer | wc -l `
    let RND=$RANDOM%$discs+1
    head -$RND $HOME/MISC/CDdrawer | tail -1
    }
alias    cdlist="egrep -e '(^(>[^>]))|(^(>>[^>]))' $HOME/MISC/CDlist.sfh | sed -e 's/>>/	/g'"
alias 	 copy='cp'
if [ -e /usr/local/gnu/bin/ls ]; then
   alias dir='/usr/local/gnu/bin/ls -FlAsb'
   alias la='/usr/local/gnu/bin/ls -FAb'
   alias ls='/usr/local/gnu/bin/ls -Fb'
else
   alias dir='ls -FlAs'
   alias la='ls -FA'
   alias ls='ls -F'
fi
alias 	 dtpu='/usr/local/gnu/bin/emacs -nw -q -l $HOME/.DOTS/dtpu-edt.elc'
alias 	 dump='$HOME/TEST/dump'
if [ -e /usr/local/bin/gnu/emacs ]; then
   alias emacs /usr/local/bin/gnu/emacs
fi
alias 	 edt='emacs -nw -q -l $HOME/.DOTS/.edt.elc'
function ff { find . -name $1 -print; }
function fman { nroff -man $1 | more; }
function frame { export FMHOME='/usr/spl/cots/obj/frame2.1X'; /usr/spl/cots/obj/frame2.1X/bin/maker; }
alias 	 h='history'
#alias    home='cd $home'
alias    iruby='irb'
if [ "$OS" = "DARWIN" ]; then
    alias ldd='otool -L'
fi
alias    ldlist="egrep -e '^(>[^>])' $HOME/MISC/LDlist.sfh | sed -e 's/>>/ /g'"
alias 	 lpr16='lpr -Pwdl16'
alias    lpr19='lpr -Pwdl19'
alias    lpq16='lpq -Pwdl16'
alias 	 lpq19='lpq -Pwdl19'
alias 	 lse='emacs -nw -q -l $HOME/.DOTS/.lse.elc'
function Man { echo "[?5h"; man $*; echo "[?5l"; }
alias 	 mail='Mail'
function mak { make -f $1.mak; }
alias 	 mbox='Mail -f $HOME/mbox'
if [ "$OS" = "SOLARIS" ]; then
    alias mkdepend='make EXTRA_INCLUDES=-I/opt/SUNWspro/SC4.0/include/CC'
fi
function mtpu () { /LocalApps/Emacs.app/Contents/MacOS/Emacs $* & }
#alias mtpu='open -a /LocalApps/Emacs.app'
#mtpu()
#    {
#    echo '(load-file "~/.DOTS/osxtpu-edt21.elc")' > $HOME/.emacs
#    echo '(cd "'$PWD'")' >> $HOME/.emacs
#    # makes option key meta
#    #echo '(setq mac-command-key-is-meta nil)' >> $HOME/.emacs
#    echo '(setq inhibit-startup-message t)' >> $HOME/.emacs
#    while [ "$1" != "" ]; do
#        echo '(find-file "'$1'")' >> $HOME/.emacs
#        showBuf=`basename $1`
#        shift
#    done
#    if [ "$showBuf" != "" ]; then
#        echo '(switch-to-buffer (get-buffer "'$showBuf'"))' >> $HOME/.emacs
#    fi
#    open /LocalApps/Emacs.app
#    sleep 2
#    #rm $HOME/.emacs
#    }
function nn { cd /usr/local/sw/news/nn_6.4/bin; ./nn; cd; }
alias	 psds='ipr -Pwdl19 -Lultrascript -Dpageduplex'
alias 	 psl='ps -lx'
alias	 racl="for file in RCS/* ; do echo \$file ; rlog \$file | sed -e '1,/access list:/d' -e '/symbolic names:/,\$d' ; done"
alias 	 rheads="rlog RCS/* | egrep -e 'Working file:|head:'"
alias	 rlocks="rlog RCS/* | egrep -e 'RCS file:|locked by:'"
alias	 rsyms="for file in RCS/* ; do echo \$file ; rlog \$file | sed -e '1,/symbolic names:/d' -e '/comment leader:/,\$d' ; done"
if [ -e /usr/local/gnu/bin/rm ]; then
   alias rm='/usr/local/gnu/bin/rm -v'
fi
alias	 rmail="sedt -f rmail"
alias 	 sd='cd'
function sea { grep -i $2 $1; }
alias 	 sedt='emacs -nw -q -l $HOME/.DOTS/.sedt.elc'
alias 	 stpu='/usr/bin/emacs -nw -l $HOME/.DOTS/tpu-edt20.2.elc'
function setenv { export $1="$2"; }
function sha { alias | grep -i $1; }
function she { declare | grep -i $1; }
alias    sshec='ssh -L 1666:perforce:1666 -L 8001:doc:80 -L 8002:dev:80 -l mdm ssh.ecircles.com'
alias 	 taradd='tar -rvf'
alias 	 tarcre='tar -cvf'
alias 	 tarext='tar -xvf'
alias 	 tarlis='tar -tvf'
function tolower { echo $* | tr [A-Z] [a-z]; }
function toupper { echo $* | tr [a-z] [A-Z]; }
alias 	 tricmd='source /p0/tritools_7.0/tricmd.bash'
alias	 twoup='enscript -2rG'
alias 	 type='cat'
function up 
    { 
    if [ "$1" = "" ]; then
        let cdupLen=1
    else
        let cdupLen=$1;
    fi
    cdupCmd="cd ..";
    while [ $cdupLen -gt 1 ]; do
        cdupCmd="$cdupCmd/..";
        let cdupLen=$cdupLen-1;
    done;
    $cdupCmd
    }
alias 	 unZ='uncompress'
alias 	 vtbow='echo "[?5h"'
alias    vtdeckpam='echo "="'
alias    vtdeckpnm='echo ">"'
function vtlbl { echo "]0;"$1""; }
alias 	 vtp='$HOME/TEST/vtpause'
function vtssw { echo "[1;"$1"r"; clear; }
alias 	 vtwob='echo "[?5l"'
function which
    {
    if [ "$1" = "-a" ] ; then
        allpaths=Y
        shift
    fi
    pathdirs=`echo $PATH | sed -e "s/:/ /g"`
    for dir in $pathdirs
        {
        if [ -e $dir/$1 ]; then
            echo $dir/$1
            if [ -z "$allpaths" ] ; then
                return
            fi
        fi
        }
    }
function wtpu()
    {
    local tpuPath=`cygpath -w ~/.DOTS/win7tpu-edt23.elc`
    if [ "$*" != "" ]; then
      local filePaths=`cygpath -w $*`
    fi
    /DrvC/opt/emacs-24.3/bin/runemacs -g 80x48 -bg white -fg black -q -l $tpuPath $filePaths
    }
function xbash
    {
    bashpath=`which  bash`
    if [ -z "$bashpath" ] ; then
        printf "bash not found in path\n"
        return
    fi
    export SHELL=$bashpath
    exec $bashpath
    }
function xdsp { export DISPLAY="$1"":0.0"; }
function xetc { declare -x XAPPLRESDIR=/usr/local/X.V11R5/lib/X11/app-defaults ; /usr/local/X.V11R5/bin/x3270 a:mainframe; }
alias 	 xtpu='/sw/bin/emacs -bg white -fg black -q -l $HOME/.DOTS/xtpu-edt20.2.elc'
if [ -e /usr/local/gnu/bin/zcat ] ; then
   alias    zcat='/usr/local/gnu/bin/zcat'
fi
if [ -e /usr/local/bin/zcat ] ; then
   alias    zcat='/usr/local/bin/zcat'
fi
#alias 	 Z='compress'
