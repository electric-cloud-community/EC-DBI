# -------------------------------------------------------------------------
# Package
#    client.pl
#
# Dependencies
#    DBI Module
#
# Purpose
#    intances the dbi module and execute sql queries
#
# Date
#    25/08/2011
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------
package client;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use utf8;
use Carp;
use strict;
use warnings;
use File::Basename;
use ElectricCommander;
use ElectricCommander::PropDB;
use ElectricCommander::PropMod;
use lib "$ENV{COMMANDER_PLUGINS}/@PLUGIN_NAME@/agent/lib";
use dbd;

# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant {
   ERROR   => 1,
};

sub main{
    my %configuration;
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    # -------------------------------------------------------------------------
    # Variables
    # -------------------------------------------------------------------------
    my $configName  = ($ec->getProperty( "configName" ))->findvalue('//value')->string_value;
    my $dbName      = ($ec->getProperty( "DbName" ))->findvalue('//value')->string_value;
    my $hostName    = ($ec->getProperty( "Server" ))->findvalue('//value')->string_value;
    my $port        = ($ec->getProperty( "Port" ))->findvalue('//value')->string_value;
    my $query       = ($ec->getProperty( "Query" ))->findvalue('//value')->string_value;
    my $sqlFile     = ($ec->getProperty( "SqlFile" ))->findvalue('//value')->string_value;
    my $format      = ($ec->getProperty( "Format" ))->findvalue('//value')->string_value;
    my $transaction = ($ec->getProperty( "EnableTransactions" ))->findvalue('//value')->string_value;
    my $dbEngine    = ($ec->getProperty( "DbEngine" ))->findvalue('//value')->string_value;
    my $out_prop    = ($ec->getProperty( "Result_outpp" ))->findvalue('//value')->string_value;
    
    
	if($dbEngine eq "SQLServer"){
		$dbEngine = "ODBC";
	}
    my $dsn = "dbi:$dbEngine";
    if ($dbEngine eq "ODBC"){
        $dsn .= ":$dbName";
    }elsif($dbEngine eq "mysql"){
        $dsn .= ":database=$dbName";
        if($hostName && $hostName ne ""){
            $dsn .= ";host=$hostName";
        }
        if($port && $port ne ""){
            $dsn .= ";port=$port";
        }
    }elsif($dbEngine eq "SQLite"){
        $dsn .= ":dbname=$dbName";
    }elsif($dbEngine eq "Oracle"){
        $dsn .= ":$dbName";
    }elsif($dbEngine eq "Pg"){
        $dsn .= ":dbname=$dbName";
        if($hostName && $hostName ne ""){
            $dsn .= ";host=$hostName"; 
        }
        if($port && $port ne ""){
            $dsn .= ";port=$port";
        }
    }
    
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
    
    my $dbConnection = dbd->new($dsn, $username."", $password."", $format);
    
    #We must call the Connect method to start
    eval{
        $dbConnection->Connect();
    };
    if($@){
        print "Unable to connect to the database:\n $@";
        exit ERROR;
    }
    #we validate if we have to use transactions or not
    if($transaction && $transaction ne ""){
        $dbConnection->BeginTransaction();
        print "Begin transaction\n";
    }
    #a variable to store possible results
    my $result = "";
    my $error = "";
    if($sqlFile && $sqlFile ne ""){
        #we read the file and store it's content into a temp variable
        my $filequery = ReadFile($sqlFile);
        if($format && $format eq "HTML"){
            $result = $dbConnection->executeQueryHtml($filequery);
        }else{
            $result = $dbConnection->executeQuery($filequery);
        }
        $error = $dbConnection->getError();
        if($error && $error ne ''){
            print   $error;
            if($transaction && $transaction ne ""){
                $dbConnection->RollBackTransaction();
                print "Rollback transaction";
            }
            $ec->setProperty("outcome", "error" );
            $dbConnection->Disconnect();
            exit ERROR;
        }
        
        if (defined($result)){
            #if results were found we print the output
            print $result;
        }
    }
    
    if($query && $query ne ""){
        if($format && $format eq "HTML"){
            $result = $dbConnection->executeQueryHtml($query);
        }else{
            $result = $dbConnection->executeQuery($query);
        }
        
        $error = $dbConnection->getError();
        if($error && $error ne ''){
            print   $error;
            if($transaction && $transaction ne ""){
                $dbConnection->RollBackTransaction();
                print "Rollback transaction";
            }
            $ec->setProperty("outcome", "error" );
            $dbConnection->Disconnect();
            exit ERROR;
        }
        
        if (defined($result)){
            #if results were found we print the output
            print $result;
        }
    }
    if($transaction && $transaction ne ""){
        $dbConnection->CommitTransaction();
        print "Commit transaction";
    }
    $dbConnection->Disconnect();
    
    #set the output property
    if($out_prop && $out_prop ne ""){
        $ec->setProperty($out_prop, $result );
    }
    
    return;
}

###########################################################################
=head2 ReadFile
 
  Title    : ReadFile
  Usage    : ReadFile("tmp.txt");
  Function : Reads a file and return it's content
  Returns  : a string containing the whole content of the file
  Args     : named arguments:
           : -file => path to a file to read
           :
=cut
###########################################################################
sub ReadFile{
    my $file = shift;
    my $filecontent = "";
    open my $FH, "<", $file or croak "Unable to open $file $!";
    while (my $line = <$FH>) {
        $filecontent .= $line;
    }
    close $FH;
    return $filecontent;
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