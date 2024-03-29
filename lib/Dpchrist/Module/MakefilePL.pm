#######################################################################
# $Id: MakefilePL.pm,v 1.45 2010-11-27 07:13:06 dpchrist Exp $
#######################################################################
# package:
#----------------------------------------------------------------------

package Dpchrist::Module::MakefilePL;

use strict;
use warnings;

our $VERSION  = sprintf "%d.%03d", q$Revision: 1.45 $ =~ /(\d+)/g;

#######################################################################
# uses:
#----------------------------------------------------------------------

use Carp;
use Data::Dumper;
use File::Basename;
use File::Spec::Functions;

#######################################################################
# package variables:
#----------------------------------------------------------------------

our %import_args;
our $maxdump		= 240;

#######################################################################

=head1 NAME

Dpchrist::Module::MakefilePL - extend ExtUtils::MakeMaker Makefile.PL


=head1 DESCRIPTION

This documentation describes module revision $Revision: 1.45 $.


This is alpha test level software
and may change or disappear at any time.


This module adds functionality to Makefile.PL
used by ExtUtils::MakeMaker.
Options are enabled via the 'use' argument list --
option names are hash keys,
and option parameters are hash values.

=cut

#######################################################################

=head2 IMPORT OPTIONS

=cut

#######################################################################

=head3 -mcpani

    # Makefile.PL
    eval {
	require Dpchrist::Module::MakefilePL;
	import Dpchrist::Module::MakefilePL (
    	    -mcpani => EXPR,
    	);
    };
    warn $@ if $@;

Adds a Make target 'mcpani'
to the Makefile generated by ExtUtils::MakeMaker::WriteMakefile()
which adds the distribution tarball
to the MCPAN working directory (repository)
and pushes it to the MCPAN local directory
when the following commands are issued:

    $ make dist
    $ make mcpani

Note that you need to run 'make dist'
to create the distribution tarball
before running 'make mcpani'.

EXPR is used for the --authorid
parameter to 'mcpani'.
Default is 'NONE'.
I put my CPAN author id (DPCHRIST)
into an environment variable CPAN_AUTHORID in my .bash_profile:

    # .bash_profile
    export CPAN_AUTHORID=DPCHRIST

I then use this environment variable in Makefile.PL:

    # Makefile.PL
    -mcpani => $ENV{CPAN_AUTHORID},

You will need a working CPAN::Module::Inject installation
before running 'make mcpani'.  See the following for details:

    perldoc mcpani
    http://www.ddj.com/web-development/184416190
    http://www.stonehenge.com/merlyn/LinuxMag/col42.html

I set an environment variable in .bash_profile that points to my
mcpani configuration file:

    # .bash_profile
    export MCPANI_CONFIG=$HOME/.mcpanirc

Here is my configuration file:

    # .mcpanirc
    local: /mnt/z/mirror/MCPAN
    remote: ftp://ftp.cpan.org/pub/CPAN ftp://ftp.kernel.org/pub/CPAN
    repository: /home/dpchrist/.mcpani
    passive: yes
    dirmode: 0755

My staging directory is ~/.mcpani.

/mnt/z/mirror/MCPAN is directory on my web server
that is served as http://mirror.holgerdanske.com/MCPAN/.

I can then run cpan on my machines
and have them use the web mirror
(only need to do this once):

    $ sudo cpan
    cpan[1]> o conf urllist http://mirror.holgerdanske.com/MCPAN/
    cpan[2]> o conf commit
    cpan[3]> reload index

Whenever I inject a new or updated module via mcpani or 'make mcpani',
I need to reload the cpan index
before I install the module:

    $ sudo cpan
    cpan[1]> reload index
    cpan[2]> install MyModule

=cut

#----------------------------------------------------------------------

sub _mcpani
{
    my $authorid = $import_args{-mcpani} || 'NONE';

    confess join(' ',
	"Bad CPAN author ID for -mcpani option",
	Data::Dumper->Dump([$authorid, \%import_args],
			 [qw(authorid   *import_args)]),
    ) unless eval {
	ref \$authorid eq "SCALAR"
	&& $authorid =~ /^[A-Z]/
    };

    return <<EOF;

mcpani ::

	/usr/local/bin/mcpani --add \\
	--module \$(NAME) \\
	--authorid $authorid \\
	--modversion \$(VERSION) \\
	--file \$(DISTVNAME).tar.gz

	/usr/local/bin/mcpani --inject -v
EOF

}

#######################################################################

=head3 -pod2html

    # Makefile.PL
    eval {
	require Dpchrist::Module::MakefilePL;
	import Dpchrist::Module::MakefilePL (
	    -pod2html => [ LIST ]
	);
    };
    warn $@ if $@;

Adds a rule to the Make target 'all'
in the Makefile generated by ExtUtils::MakeMaker::WriteMakefile()
which will run 'pod2html' against the files in LIST
(e.g. Perl modules and scripts)
using the commands:

    pod2html FILE > PACKAGE-VERSION.html
    rm -f pod2htm?.tmp

PACKAGE and VERSION are determined by reading FILE:

* The namespace of the first 'package' decalaration found
is used for PACKAGE.
If no 'package' declaration is found,
File::Basename::basename(FILE) is used for PACKAGE.

* The argument of the first '$VERSION' variable assignment found
is evaluated and used for VERSION.


HTML files will be generated or updated
whenever the following commands are issued:

    $ make

Or,

    $ make all

=cut

#----------------------------------------------------------------------

sub _pod2html
{
    my $arg = $import_args{-pod2html};

    my @files = (   ref $arg eq "ARRAY"
		    ? @$arg
		    : ($arg)
		);

    my $frag;

    foreach my $file (@files) {

	confess join(' ',
	    'Bad file name for -pod2html option',
	    Data::Dumper->Dump([$file, \%import_args],
			     [qw(file   *import_args)]),
    	) unless eval {
    	    ref \$file eq "SCALAR"
    	    && -e $file
	};

	my $package;
	my $version;
	open(F, $file)
	    or confess join(' ',
		"Failed to open file '$file': $!",
	    );
	my $inpod = 0;
	while (<F>) {
    	    $inpod = 1 if $_ =~ /^=\w/;
	    $inpod = 0 if $_ =~ /^=cut/;
	    next if $inpod;

	    $package = $1
		if $_ =~ /^package\s+([\w\:]+);/;
	    $version = eval $1
		if $_ =~ /\$VERSION\s+=\s+(.+)/;
	    last if $package && $version;
	}
	close F
	    or confess "Failed to close file '$file': $!";

	$package = basename($file) unless $package;

	confess join(' ',
	    "Unable to find package name and/or version",
	    "for file '$file'",
	    Data::Dumper->Dump([$package, $version],
			     [qw(package   version)]),
	) unless $package && $version;

	$package =~ s/\:\:/-/g;

	my $html = $package . '-' . $version . '.html';

    	$frag .= <<EOF;

all :: $html

$html :: $file
	pod2html \$< > $html
	rm -f pod2htm?.tmp
EOF

    }

    return $frag;
}

#######################################################################

=head3 -readme

    # Makefile.PL
    eval {
	require Dpchrist::Module::MakefilePL;
	import Dpchrist::Module::MakefilePL (
	    -readme => FILE,
	);
    };
    warn $@ if $@;

Adds a rule to the Make target 'all'
in the Makefile generated by ExtUtils::MakeMaker::WriteMakefile()
which will run 'pod2text' against FILE
(e.g. Perl module)
using the command:

    pod2text FILE > README

The README file will be generated or updated
whenever the following commands are issued:

    $ make

Or,

    $ make all

=cut

#----------------------------------------------------------------------

sub _readme
{
    my $file = $import_args{-readme};

    confess join(' ',
	'Bad file name for -readme option',
	Data::Dumper->Dump([$file, \%import_args],
			 [qw(file   *import_args)]),
    ) unless eval {
	ref \$file eq "SCALAR"
	&& -e $file
    };

    my $frag = <<EOF;

all :: README

README :: $file
	pod2text \$< > README
EOF

    return $frag;
}

#######################################################################

=head3 -release

    # Makefile.PL
    eval {
	require Dpchrist::Module::MakefilePL;
	import Dpchrist::Module::MakefilePL (
	    -release => EXPR,
	);
    };
    warn $@ if $@;

Adds a Make target 'release'
to the Makefile generated by ExtUtils::MakeMaker::WriteMakefile()
which copies all *.tar.gz and *.html files
to a subdirectory under EXPR
that is named after the module
(changing double colons to a single dash)
when the following commands are issued:

    $ make dist
    $ make release

Note that you should run 'make dist'
to create the distribution tarball before running 'make mcpani'.

I set an environment variable in my .bash_profile:

    # .bash_profile
    export RELEASE_ROOT=/mnt/z/data/release

and use this environment variable in Makefile.PL:

    # Makefile.PL
    -release => $ENV{RELEASE_ROOT},

=cut

#----------------------------------------------------------------------

sub _release
{
    my $root = $import_args{-release};

    confess join(' ',
	"Bad directory name for -release option",
	Data::Dumper->Dump([$root, \%import_args],
			 [qw(root   *import_args)]),
    ) unless eval {
	ref \$root eq "SCALAR"
    };

    return <<EOF;

release ::
	/bin/mkdir -p $root/\$(DISTNAME)
	/bin/mv -i *.tar.gz *.html $root/\$(DISTNAME)
EOF
}

#######################################################################

=head2 CLASS METHOD OVERRIDES

=cut

#----------------------------------------------------------------------

=head3 import

=cut

sub import
{
    my $class = shift;

    confess join(' ',
	'Import arguments must be key => value pairs',
	Data::Dumper->Dump([$class, \@_], [qw(class *@)]),
    ) if @_ % 2 != 0;

    %import_args = @_;
}

#######################################################################

=head2 'MY' PACKAGE OVERRIDES

=cut

#----------------------------------------------------------------------

=head3 MY::postamble

=cut

sub MY::postamble
{
    my $retval = "";

    $retval .= _mcpani(@_)	if $import_args{-mcpani};

    $retval .= _pod2html(@_)	if $import_args{-pod2html};

    $retval .= _readme(@_)	if $import_args{-readme};

    $retval .= _release(@_)	if $import_args{-release};

    return $retval;
}

#######################################################################
# end of code:
#----------------------------------------------------------------------

1;

__END__

#######################################################################

=head2 EXPORT

    None.


=head1 INSTALLATION

Installed as part of Dpchrist::Module.


=head2 PREREQUISITES

See Makefile.PL in the source distribution root directory.


=head1 SEE ALSO

    mcpani
    Dpchrist::Module
    ExtUtils::MakeMaker
    ExtUtils::MM_Unix
    Programming Perl, 3 e., Ch. 29 "use" (pp. 822-823).


=head1 AUTHOR

David Paul Christensen  dpchrist@holgerdanske.com


=head1 COPYRIGHT AND LICENSE

Copyright 2010 by David Paul Christensen  dpchrist@holgerdanske.com

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307,
USA.

=cut

#######################################################################
