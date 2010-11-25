#######################################################################
# $Id: Module.pm,v 1.20 2010-11-25 02:35:32 dpchrist Exp $
#######################################################################
# package:
#----------------------------------------------------------------------

package Dpchrist::Module;

use strict;
use warnings;

our $VERSION  = sprintf "%d.%03d", q$Revision: 1.20 $ =~ /(\d+)/g;

#######################################################################
# end of code:
#----------------------------------------------------------------------

1;
__END__

#######################################################################

=head1 NAME

Dpchrist::Module - utilities for Perl modules


=head1 DESCRIPTION

This module includes:

=over

=item * Additional functionality for Makefile.PL used by ExtUtils::MakeMaker.

=item * Standard test scripts.

=back


=head1 INSTALLATION

    perl Makefile.PL
    make
    make test
    sudo make install
    make dist
    make mcpani
    make release
    make realclean


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
