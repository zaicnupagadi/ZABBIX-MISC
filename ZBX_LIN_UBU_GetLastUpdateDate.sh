#!/usr/bin/perl

#------------------ subroutines --------------------

sub parseRecord {
my $sdate = "";
my $useful = 0;
my $packages = 0;
my $r = 0;
my @ptmp;
while (my $recordLine = shift() ) {
if ($recordLine =~ m/^Start-Date: ([\d\-]*).*/) {
$sdate = $1;
}
elsif ($recordLine =~ m/^Requested-By:/) {
$r = 1;
}
elsif ($recordLine =~ m/^Commandline:.*upgrade/) {
$useful = 1;
}
elsif ($recordLine =~ m/^Install: (.*)/) {
$recordLine =~ s/\([^\)]*\)//g;
@ptmp = split(/,/,$recordLine);
$packages = $packages + $#ptmp + 1;
}
elsif ($recordLine =~ m/^Upgrade: (.*)/) {
$recordLine =~ s/\([^\)]*\)//g;
@ptmp = split(/,/,$recordLine);
$packages = $packages + $#ptmp + 1;
}
}
if ($r && $useful) {
	return ($sdate,$packages)
}
else {
return ("0",0);
}
}
#------------------ main program --------------------
@lines = split(/\n/,`/bin/zcat -f /var/log/apt/history.log  /var/log/apt/history*gz`);
my %patchHash;
my $line;
my @inputLines;
my $pushDate = "";
my $pushNum = "";
my $req = "";
my @updatedates;
foreach $line (@lines) {
# all records separated by blank lines
if ($line !~ /./) {
# no-op
}
elsif ($line =~ m/^Start-Date: ([\d\-]*).*/) {
@inputLines = ();
push (@inputLines, $line);
}
elsif ($line =~ m/^End-Date: ([\d\-]*).*/) {
($pushDate, $pushNum) = parseRecord(@inputLines);
if ($pushNum != 0) {
$patchHash{$pushDate} += $pushNum;
}
}
else {
push (@inputLines, $line);
}
}

foreach $pushDate (sort(keys(%patchHash))) {
push @updatedates, $pushDate 
}
print "@updatedates[-1]";

#foreach $pushDate (sort(keys(%patchHash))) {
#print "$pushDate $patchHash{$pushDate}\n";
#}
