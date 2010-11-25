#######################################################################
# $Id: Module.pm,v 1.21 2010-11-25 18:00:28 dpchrist Exp $
#######################################################################
# package:
#----------------------------------------------------------------------

package Dpchrist::Module;

use strict;
use warnings;

our $VERSION  = sprintf "%d.%03d", q$Revision: 1.21 $ =~ /(\d+)/g;

#######################################################################
# end of code:
#----------------------------------------------------------------------

1;

__END__

#######################################################################

=head1 NAME

Dpchrist::Module - utilities for Perl modules


=head1 DESCRIPTION

This documentation describes module revision $Revision: 1.21 $.


This is alpha test level software
and may change or disappear at any time.


This module includes:

=over

=item * Additional functionality for Makefile.PL used by ExtUtils::MakeMaker.

=item * Standard test scripts.

=back


=head1 INSTALLATION

    perl Makefile.PL
    make
    make test
    make install


=head1 DEPENDENCIES

    CPAN::Mini::Inject


=head1 SEE ALSO

    Dpchrist::Module::MakefilePL
    scripts in t/ directory


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
