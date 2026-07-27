pawclient(1)

# NAME
pawclient - start new terminals in a paw server

# SYNOPSIS
*pawclient* [_OPTIONS_]++
*pawclient* [_OPTIONS_] <_command_> [_COMMAND OPTIONS_]

All trailing (non-option) arguments are treated as a command, and its
arguments, to execute (instead of the default shell).

# DESCRIPTION

*pawclient* is used together with *paw*(1) in *--server*
mode.

Running it without arguments will open a new terminal window (hosted
in the paw server), with your default shell. The exit code will be
that of the terminal. I.e *pawclient* does not exit until the
terminal has terminated.

# OPTIONS

*-t*,*--term*=_TERM_
	Value to set the environment variable *TERM* to (see *TERMINFO*
	and *ENVIRONMENT*). Default: _@default_terminfo@_.

*-T*,*--title*=_TITLE_
	Initial window title. Default: _paw_.

*-a*,*--app-id*=_ID_
	Value to set the *app-id* property on the Wayland window
	to. Default: _paw_ (normal mode), or _pawclient_ (server mode).

*--class*=_ID_
	Alias for *--app-id*.

*toplevel-tag*=_TAG_
	Value to set the *toplevel-tag* property on the Wayland window
	to. The compositor can use this value for session management,
	window rules etc. Default: _not set_

*-w*,*--window-size-pixels*=_WIDTHxHEIGHT_
	Set initial window width and height, in pixels. Default: _700x500_.

*-W*,*--window-size-chars*=_WIDTHxHEIGHT_
	Set initial window width and height, in characters. Default: _not set_.

*-m*,*--maximized*
	Start in maximized mode. If both *--maximized* and *--fullscreen*
	are specified, the _last_ one takes precedence.

*-F*,*--fullscreen*
	Start in fullscreen mode. If both *--maximized* and *--fullscreen*
	are specified, the _last_ one takes precedence.

*-L*,*--login-shell*
	Start a login shell, by prepending a '-' to argv[0].

*-D*,*--working-directory*=_DIR_
	Initial working directory for the client application. Default:
	_CWD of pawclient_.

*-s*,*--server-socket*=_PATH_
	Connect to _PATH_ instead of
	*$XDG\_RUNTIME\_DIR/paw-$WAYLAND\_DISPLAY.sock*.

*-H*,*--hold*
	Remain open after child process exits.

*-N*,*--no-wait*
	Detach the client process from the running terminal, exiting
	immediately.

*-o*,*--override*=[_SECTION_.]_KEY_=_VALUE_
	Override an option set in the configuration file. If _SECTION_ is not
	given, defaults to _main_.

*-E*,*--client-environment*
	The child process in the new terminal instance will use
	pawclient's environment, instead of the server's.

	Environment variables listed in the *Variables set in the child
	process* section will be overwritten by the paw server. For
	example, the new terminal will use *TERM* from the configuration,
	not pawclient's environment.

*-d*,*--log-level*={*info*,*warning*,*error*,*none*}
	Log level, used both for log output on stderr as well as
	syslog. Default: _warning_.

*-l*,*--log-colorize*=[{*never*,*always*,*auto*}]
	Enables or disables colorization of log output on stderr.

*-v*,*--version*
	Show the version number and quit

*-e*
	Ignored; for compatibility with *xterm -e*. See *paw*(1) for more
	details.

# EXIT STATUS

Pawclient will exit with code 220 if there is a failure in pawclient
itself (for example, the server socket does not exist).

If *-N*,*--no-wait* is used, pawclient exits with code 0 as soon as
the paw server has been instructed to open a new window.

If not, pawclient may also exit with code 230. This indicates a
failure in the paw server.

In all other cases the exit code is that of the client application
(i.e. the shell).

# TERMINFO

Client applications use the terminfo identifier specified by the
environment variable *TERM* (set by paw) to determine terminal
capabilities.

Paw has two terminfo definitions: *paw* and *paw-direct*, with
*paw* being the default.

The difference between the two is in the number of colors they
describe; *paw* describes 256 colors and *paw-direct* 16.7 million
colors (24-bit truecolor).

Note that using the *paw* terminfo does not limit the number of
usable colors to 256; applications can still use 24-bit RGB colors. In
fact, most applications work best with *paw* (including 24-bit
colors)). Using *\*-direct* terminfo entries has been known to crash
some ncurses applications even.

There are however applications that need a *\*-direct* terminfo entry
for 24-bit support. Emacs is one such example.

While using either *paw* or *paw-direct* is strongly recommended, it
is possible to use e.g. *xterm-256color* as well. This can be useful
when remoting to a system where paw's terminfo entries cannot easily
be installed.

Note that terminfo entries can be installed in the user's home
directory. I.e. if you do not have root access, or if there is no
distro package for paw's terminfo entries, you can install paw's
terminfo entries manually, by copying *paw* and *paw-direct* to
*~/.terminfo/f/*.

# ENVIRONMENT

## Variables used by pawclient

*XDG\_RUNTIME\_DIR*
	Used to construct the default _PATH_ for the *--server-socket*
	option, when no explicit argument is given (see above).

*WAYLAND\_DISPLAY*
	Used to construct the default _PATH_ for the *--server-socket*
	option, when no explicit argument is given (see above).

If the socket at default _PATH_ does not exist, *pawclient* will
fallback to the less specific path, with the following priority:
*$XDG\_RUNTIME\_DIR/paw-$WAYLAND\_DISPLAY.sock*,
*$XDG\_RUNTIME\_DIR/paw.sock*, */tmp/paw.sock*.

## Variables set in the child process

*TERM*
	terminfo/termcap identifier. This is used by client applications
	to determine which capabilities a terminal supports. The value is
	set according to either the *--term* command-line option or the
	*term* config option in *paw.ini*(5).

*COLORTERM*
	This variable is set to *truecolor*, to indicate to client
	applications that 24-bit RGB colors are supported.

*PWD*
	Current working directory (at the time of launching paw)

*SHELL*
	Set to the launched shell, if the shell is valid (it is listed in
	*/etc/shells*).

In addition to the variables listed above, custom environment
variables may be defined in *paw.ini*(5).

## Variables *unset* in the child process

*TERM_PROGRAM*
*TERM_PROGRAM_VERSION*
	These environment variables are set by certain other terminal
	emulators. We unset them, to prevent applications from
	misdetecting paw.

In addition to the variables listed above, custom environment
variables to unset may be defined in *paw.ini*(5).

# Signals

The following signals have special meaning in pawclient:

- SIGUSR1: switch to the dark color theme (*[colors-dark]*).
- SIGUSR2: switch to the light color theme (*[colors-light]*).

When sending SIGUSR1/SIGUSR2 to a pawclient instance, the theme is
changed in that instance only. This is different from when you send
SIGUSR1/SIGUSR2 to the server process, where all instances change the
theme.

Note: for obvious reasons, this is not supported when pawclient is
started with *--no-wait*.

# SEE ALSO

*paw*(1)
