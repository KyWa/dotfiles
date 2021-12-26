# Python Virt-Viewer

```python
#!/usr/bin/python

# oVirt Engine 3.3 will send a user requesting a console a little
# ini-style file with the host/port/password information necessary
# for connecting to a VM via VNC. On a Mac, that file (typically
# named console.vv) is useless as-is. This script parses console.vv
# and passes a vnc:// URL to /usr/bin/open.
#
# A reasonable console.vv file will look something like this:

# [virt-viewer]
# type=vnc
# host=your.host.com
# port=5907
# password=ZOrRmRBNlzaK
# delete-this-file=1
# title=VNC
#
# From that file, this script will create a vnc url. The Mac
# Screen Sharing application will accept an old-style URL with
# a username:password prepended to the hostname; oVirt doesn't
# provide a username, so we leave that blank. In the example
# above, the resulting URL would be
#
#   vnc://:ZOrRmRBNlzaK@your.host.com:5907
#
# Since ovirt-assigned vnc passwords expire after 120 seconds, this
# script by default will delete the ini file after parsing it.
#
# ======================================================================

import ConfigParser, argparse, subprocess, sys, os.path

# open(1) knows how to deal with various file and string types
opener = "/usr/bin/open"
# define the correct section name in console.vv
header = "virt-viewer"
# the default location of the ini file; this can be overridden
# by passing the filename to the script
defaultvv = os.path.expandvars( "${HOME}/Downloads/console.vv" )

# set up the ArgumentParser
parser = argparse.ArgumentParser(
  description='Parse and execute virt-viewer VNC ini file',
  epilog='The console.vv file must have a [virt-viewer] heading, a type=vnc entry, and entries for host, port, and password to parse correctly.')
parser.add_argument( '-k', '--keep', action='store_true',
  help='keep vvfile after parsing (default is to delete it)')
parser.add_argument( 'vvfile',
  nargs='?',
  default=defaultvv,
  help='console.vv file from oVirt (default: ~/Downloads/console.vv)')
args = parser.parse_args()

# make sure the file is readable
if not os.path.isfile(args.vvfile):
  sys.stderr.write( args.vvfile + " is not readable or doesn't exist.\n" )
  parser.print_usage(file=sys.stderr)
  sys.exit()

### parse the config file
c = ConfigParser.ConfigParser()
try:
  c.read( args.vvfile )
except ConfigParser.Error:
  sys.stderr.write( args.vvfile + " doesn't parse correctly.\n" )
  sys.stderr.write( "Are you sure you got it from the right place?\n" )
  sys.exit()

# make sure we have a virt-viewer section
try:
  c.has_section( header )
except ConfigParser.NoSectionError:
  sys.stderr.write( "Cannot find necessary [" + header + "] section.\n" )
  sys.exit()

# make sure that, within the virt-viewer section, there's a type=vnc
# option
try:
  c.has_option( header, 'type' )
except ConfigParser.NoOptionError:
  sys.stderr.write( "Cannot find necessary 'type' option.\n" )
  sys.exit()

if not 'vnc' == c.get( header, 'type' ):
  sys.stderr.write( "'type' option option is not 'vnc'.\n" )
  sys.exit()

# grab the hostname.
try:
  rhost = c.get( header, 'host' )
except ConfigParser.NoOptionError:
  sys.stderr.write( "Cannot find host definition.\n" )
  sys.exit()

# grab the port value, make sure it's an integer, and test that it's
# roughly in the correct range (5900-5950) for VNC sessions
try:
  strport = c.get( header, 'port' )
except ConfigParser.NoOptionError:
  sys.stderr.write( "Cannot find port definition.\n" )
  sys.exit()

try:
  rport = int(strport)
except ValueError:
  sys.stderr.write( "The listed port is not an integer.\n" )
  sys.exit()

if rport < 5900:
  sys.stderr.write( "The port (" + strport + ") is an unexpected number.\n" )
  sys.exit()
if rport > 5950:
  sys.stderr.write( "The port (" + strport + ") is an unexpected number.\n" )
  sys.exit()

# grab the password
try:
  rpass = c.get( header, 'password' )
except ConfigParser.NoOptionError:
  sys.stderr.write( "Cannot find password definition.\n" )
  sys.exit()

# build old-style URL with password prepended to the hostname
vncurl = "vnc://:%s@%s:%d" % ( rpass, rhost, rport )

# remove the vvfile unless user has specfically asked to keep it
if not args.keep:
  os.remove( args.vvfile )

# whew. we got here. now launch the opener app.
subprocess.call( [opener, vncurl] )

#
# eof
#
```
