# -------------------------------------------------------------------------
# Package
#    backup.pl
#
# Dependencies
#    DBI Module
#
# Purpose
#    creates back ups for the provided database
#
# Date
#    31/08/2011
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------
package backup;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use utf8;
use strict;
use warnings;
use File::Basename;
use ElectricCommander;
use ElectricCommander::PropDB;
use ElectricCommander::PropMod;

# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant {
   ERROR   => 1,
};

my $ec = ElectricCommander->new();

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------
$::gBackupUtility   = ($ec->getProperty("commandLineUtility"))->findvalue('//value')->string_value;
$::gDbName          = ($ec->getProperty("DbName"))->findvalue('//value')->string_value;
$::gHostName        = ($ec->getProperty("Server"))->findvalue('//value')->string_value;
$::gPort            = ($ec->getProperty("Port"))->findvalue('//value')->string_value;
$::gDbEngine        = ($ec->getProperty("DbEngine"))->findvalue('//value')->string_value;
$::gDestinationPath = ($ec->getProperty("destinationPath"))->findvalue('//value')->string_value;
$::gBackupName      = ($ec->getProperty("backupName"))->findvalue('//value')->string_value;

sub main{
    my %configuration;
    my $configName  = ($ec->getProperty( "configName" ))->findvalue('//value')->string_value;
    # create args array
    my @args = ();
    
    if($configName && $configName ne ''){
        %configuration = getConfiguration($configName);
    }
    my $username = "";
    my $password = "";
    #store the configuration values into variables
    if(%configuration){
        if($configuration{'user'} ne '' && $configuration{'password'} ne ''){
            
           $username = $configuration{'user'};
           $password  = $configuration{'password'};
        }
    } else{
        exit ERROR;    
    }
    
    if($::gDbEngine eq "mysql"){
        @args = mysqlCommandLine($username,$password);
    }elsif($::gDbEngine eq "SQLServer"){
        @args = sqlserverCommandLine($username,$password);
    }elsif($::gDbEngine eq "SQLite"){
        @args = sqliteCommandLine();
    }elsif($::gDbEngine eq "Oracle"){
        @args = oracleCommandLine($username,$password);
    }elsif($::gDbEngine eq "Pg"){
        @args = postgresCommandLine($username,$password);
    }
    
    if(@args > 0){
        my $commandLine = join(" ", @args);
		print $commandLine."\n";
        my $result = qx{$commandLine};
        print $result;
    }else{
        print "Unable to backup the database";
        exit ERROR;
    }
    return;
}

###########################################################################
=head2 mysqlCommandLine
 
  Title    : mysqlCommandLine
  Usage    : mysqlCommandLine($user,$password);
  Function : Creates a command line to back up databases with the mysqldump utility
  Returns  : A command line ready to be executed
  Args     : named arguments:
           : -user => a valid database user
           : -password => the user's password
           :
=cut
###########################################################################
sub mysqlCommandLine{
    my $user = shift;
    my $password = shift;
    my $backuppath = ""; 
    my @args = ();
    
    if($::gBackupUtility && $::gBackupUtility ne ""){
        push(@args, '"' . $::gBackupUtility. '"');
    }
    
    if($::gHostName && $::gHostName ne ""){
        push(@args, qq{-h "$::gHostName"});
    }
    
    if($user && $user ne ''){
        push(@args, qq{-u "$user"});
    }
    
    if($password && $password ne ''){
        push(@args, qq{-p"$password"});
    }
    
    if($::gPort && $::gPort ne ''){
        push(@args, qq{-P $::gPort});
    }
    
    if($::gDbName && $::gDbName ne ''){
        push(@args, $::gDbName);
    }
    
    if($::gDestinationPath && $::gDestinationPath ne ''){
        $backuppath = $::gDestinationPath;
    }
    
    if($::gBackupName && $::gBackupName ne ''){
        $backuppath .= $::gBackupName.".sql";
    }else{
       $backuppath .= "backup.sql"; 
    }
    
    if($backuppath && $backuppath ne ''){
        push(@args, qq{> "$backuppath"});
    }

    return @args;
    
}

###########################################################################
=head2 sqlserverCommandLine
 
  Title    : sqlserverCommandLine
  Usage    : sqlserverCommandLine($user,$password);
  Function : Creates a command line to back up databases with the osql.exe utility
  Returns  : A command line ready to be executed
  Args     : named arguments:
           : -user => a valid database user
           : -password => the user's password
           :
=cut
###########################################################################
sub sqlserverCommandLine{
    my $user = shift;
    my $password = shift;
    my $backupStatement = "BACKUP DATABASE"; 
    my @args = ();
    
    if($::gBackupUtility && $::gBackupUtility ne ""){
        push(@args, '"' . $::gBackupUtility. '"');
    }
    if($user && $user ne ''){
        push(@args, qq{-U "$user"});
    }
    
    if($password && $password ne ''){
        push(@args, qq{-P "$password"});
    }
    
    if($::gDbName && $::gDbName ne ''){
        push(@args, qq{-d $::gDbName});
        $backupStatement .= " $::gDbName TO DISK = '";
    }
    
    if($::gHostName && $::gHostName ne ""){
        push(@args, qq{-S "$::gHostName"}); 
    }
    
    if($::gDestinationPath && $::gDestinationPath ne ''){
        $backupStatement .= $::gDestinationPath;
    }
    
    if($::gBackupName && $::gBackupName ne ''){
        $backupStatement .= $::gBackupName.".dat";
    }else{
       $backupStatement .= "backup.dat" 
    }
    
    if($backupStatement && $backupStatement ne ''){
        push(@args, qq{-Q "$backupStatement'"});
    }
    
    return @args; 
}

###########################################################################
=head2 sqliteCommandLine
 
  Title    : sqliteCommandLine
  Usage    : sqliteCommandLine();
  Function : Creates a command line to back up databases
  Returns  : A command line ready to be executed
  Args     : named arguments:
           :
=cut
###########################################################################
sub sqliteCommandLine{
    my @args = ();
    if($^O eq "linux"){
        push(@args, "cp");
    }else{
        push(@args, "copy");
    }
    if($::gDbName && $::gDbName ne ''){
        push(@args, qq{"$::gDbName"});
    }
    if($::gDestinationPath && $::gDestinationPath ne ''){
        push(@args, qq{"$::gDestinationPath"});
    }
    return @args; 
}

###########################################################################
=head2 oracleCommandLine
 
  Title    : oracleCommandLine
  Usage    : oracleCommandLine($user,$password);
  Function : Creates a command line to back up databases with the exp utility
  Returns  : A command line ready to be executed
  Args     : named arguments:
           : -user => a valid database user
           : -password => the user's password
           :
=cut
###########################################################################
sub oracleCommandLine{
    my @args = ();
    my $user = shift;
    my $password = shift;
    my $backuppath = "";
    my $authString = "";
    if($::gBackupUtility && $::gBackupUtility ne ''){
        push(@args, '"' . $::gBackupUtility. '"');
    }
    
    if($user && $user ne ''){
        $authString = "userid=$user";
    }
    
    if($password && $password ne ''){
        if($::gHostName && $::gHostName ne ""){
            $authString .= "/$password@".$::gHostName;
        }else{
            $authString .= "/$password";
        }
    }
    
    if($authString && $authString ne ''){
        push(@args, $authString);
    }
    
    if($::gDestinationPath && $::gDestinationPath ne ''){
        $backuppath = $::gDestinationPath;
    }
    
    if($::gBackupName && $::gBackupName ne ''){
        $backuppath .= $::gBackupName.".dmp";
    }else{
       $backuppath .= "backup.dmp"; 
    }
    
    if($backuppath && $backuppath ne ''){
        # dump file
        push(@args, qq{file='$backuppath'});
        #log file
        if($backuppath =~ m/(\.dmp)/){
            $backuppath =~ s/.dmp/.log/;
            push(@args,qq{log='$backuppath'});
        }
    }
    
    if($user && $user ne ''){
        push(@args, "owner=$user");
    }
    
    push(@args, qq{statistics="none"});
    
    return @args;
    
}

###########################################################################
=head2 postgresCommandLine
 
  Title    : postgresCommandLine
  Usage    : postgresCommandLine($user,$password);
  Function : Creates a command line to back up databases with the pg_dump utility
  Returns  : A command line ready to be executed
  Args     : named arguments:
           : -user => a valid database user
           : -password => the user's password
           :
=cut
###########################################################################
sub postgresCommandLine{
    my @args = ();
    my $user = shift;
    my $password = shift;
    my $backuppath = "";
    
    if($::gBackupUtility && $::gBackupUtility ne ""){
        push(@args, '"' . $::gBackupUtility. '"');
    }
    
    if($::gHostName && $::gHostName ne ""){
        push(@args, qq{--host $::gHostName});
    }
    
    if($::gPort && $::gPort ne ''){
        push(@args, qq{--port $::gPort});
    }
    
    if($user && $user ne ''){
        push(@args, qq{--username $user});
    }
    
    if($password && $password ne''){
        #we need to set the PGPASSWORD environment variable
        $ENV{'PGPASSWORD'} = $password;
    }
    
    push(@args, "--format custom --blobs --verbose");
    
    if($::gDestinationPath && $::gDestinationPath ne ''){
        $backuppath = $::gDestinationPath;
    }
    
    if($::gBackupName && $::gBackupName ne ''){
        $backuppath .= $::gBackupName.".backup";
    }else{
       $backuppath .= "backup.backup"; 
    }
    
    if($backuppath && $backuppath ne ''){
        push(@args, qq{--file "$backuppath"});
    }
    
    if($::gDbName && $::gDbName ne ''){
        push(@args, qq{"$::gDbName"});
    }
    
    return @args;
}

###########################################################################
=head2 getConfiguration
 
  Title    : getConfiguration
  Usage    : getConfiguration("Configuration name");
  Function : get the information of the configuration given 
  Returns  : hash containing the configuration information
  Args     : named arguments:
           : -configName => name of the configuration to retrieve
           :
=cut
###########################################################################
sub getConfiguration{

    my ($configName) = @_;
    
    # get an EC object
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    
    my %configToUse;
    
    my $proj = "$[/myProject/projectName]";
    my $pluginConfigs = ElectricCommander::PropDB->new($ec,"/projects/$proj/Server_cfgs");
    
    my %configRow = $pluginConfigs->getRow($configName);
    
    # Check if configuration exists
    unless(keys(%configRow)) {
        exit ERROR;
    }
    
    # Get user/password out of credential
    my $xpath = $ec->getFullCredential($configRow{credential});
    $configToUse{'user'} = $xpath->findvalue("//userName");
    $configToUse{'password'} = $xpath->findvalue("//password");
    
    foreach my $c (keys %configRow) {    
        #getting all values except the credential that was read previously
        if($c ne "credential"){
            $configToUse{$c} = $configRow{$c};
        }
    }
    return %configToUse;
}

main();

1;