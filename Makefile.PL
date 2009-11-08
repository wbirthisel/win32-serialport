####    use ExtUtils::MakeMaker;
####    # See lib/ExtUtils/MakeMaker.pm for details of how to influence
####    # the contents of the Makefile that is written.
####    WriteMakefile(
####        'NAME'	=> 'SerialPort',
####        'VERSION_FROM' => 'SerialPort.pm', # finds $VERSION
####    );

my $version = "0.19";
my $file = "COM1";
if (@ARGV) {
    $file = shift @ARGV;
}

my $dfile = "t/DefaultPort.pm";
unlink $dfile;
print "\nCreating new $dfile\n";
open my $default, '>', $dfile or die "Can't create $dfile: $!\n";
print {$default} <<EOF;
package SerialJunk;
# Created by Makefile.PL

\$Makefile_Test_Port = "$file";
EOF

close $default;

print "\n             Win32::SerialPort and Win32API::CommPort\n";
print "                           VERSION $version\n";
print "                  No 'Makefile' will be created\n";
print "                  Test with:    perl test.pl\n";
print "                  Install with: perl install.pl\n\n";
print "              Test with nothing connected to $file\n";
print "           or for different port: perl test.pl PORT\n";
print "         Timeout tests can take up to 30 seconds per test\n\n";

$dfile = "test.pl";
unlink $dfile;
print "Creating new $dfile\n";
open my $default, '>', $dfile or die "Can't create $dfile: $!\n";

print {$default} <<"TEST4";
# Created by Makefile.PL
# VERSION $version

use Test::Harness;
runtests ("t/test1.t", "t/test2.t", "t/test3.t", "t/test4.t",
	  "t/test5.t", "t/test6.t", "t/test7.t");

print "\\nTo run individual tests, type:\\n";
print "    C:\\> perl t/test1.t Page_Pause_Time (0..5) [ $file ]\\n";
print "\\nContinue with 'perl t/test2.t' through 'perl t/test7.t'\\n";
print "See README and other documentation for additional information.\\n\\n";
TEST4

close $default;

$dfile = "install.pl";
unlink $dfile;
print "Creating new $dfile\n";
open my $default, '>', $dfile or die "Can't create $dfile: $!\n";

print {$default} <<"INST4";
# Created by Makefile.PL
# VERSION $version

BEGIN { require 5.004; }

use Config qw(\%Config);
use strict;
use ExtUtils::Install qw( install );

my \$FULLEXT = "Win32/SerialPort";
my \$INST_LIB = "./lib";
my \$HTML_LIB = "./html";

my \$html_dest = "";	# edit real html base here if autodetect fails

if (exists \$Config{installhtmldir} ) {
    \$html_dest = "\$Config{installhtmldir}";
}
elsif (exists \$Config{installprivlib} ) {
    \$html_dest = "\$Config{installprivlib}";
    \$html_dest =~ s%\\\\lib%\\\\html%;
}

if ( length (\$html_dest) ) {
    \$html_dest .= '\\lib\\site';
}
else {
    die "Can't find html base directory. Edit install.pl manually.\\n";
}

install({
	   read => "\$Config{sitearchexp}/auto/\$FULLEXT/.packlist",
	   write => "\$Config{installsitearch}/auto/\$FULLEXT/.packlist",
	   \$INST_LIB => "\$Config{installsitelib}",
	   \$HTML_LIB => "\$html_dest"
	  },1,0,0);

__END__
INST4

close $default;
