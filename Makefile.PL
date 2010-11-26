#######################################################################
# $Id: Makefile.PL,v 1.15 2010-11-26 18:13:38 dpchrist Exp $
#
# Copyright 2010 by David Paul Christensen dpchrist@holgerdanske.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307,
# USA.
#######################################################################

BEGIN {
    eval {
	require Dpchrist::Module::MakefilePL;
	
	import Dpchrist::Module::MakefilePL (
	    -mcpani		=> $ENV{CPAN_AUTHORID},
	    -pod2html	 	=> [qw(
		lib/Dpchrist/Module.pm
		lib/Dpchrist/Module/MakefilePL.pm
	    )],
	    -readme		=> 'lib/Dpchrist/Module.pm',
	    -release		=> $ENV{RELEASE_ROOT},
	);
    };
    warn "skipping Dpchrist::Module::MakefilePL: $@"
	if $@
}

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'Dpchrist::Module',
    VERSION_FROM	=> 'lib/Dpchrist/Module.pm',
    PREREQ_PM		=> {},
    ABSTRACT_FROM	=> 'lib/Dpchrist/Module.pm',
    AUTHOR		=>
	'David Christensen <dpchrist@holgerdanske.com>',
    clean		=> {
	FILES => q( *~tmp */*~tmp Dpchrist* ),
    },
);

#######################################################################
