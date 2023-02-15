# -------------------------------------------------------------------------
# Package
#    dbd.pm
#
# Dependencies
#    DBD Module
#
# Purpose
#    handles with sql database conections
#
# Date
#    23/08/2011
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

package dbd;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use DBI;
use JSON;
use utf8;
use strict;
use XML::Dumper;

#constructor
sub new {
    my $class = shift;
    #attributes
    my $self = {
        _dsn      => shift,
        _user     => shift,
        _password => shift,
        _format   => shift,
        _dbh      => undef,
    };
    bless $self, $class;
    return $self;
}

###########################################################################
=head2 Connect
 
  Title    : Connect
  Usage    : Connect();
  Function : creates and open a sql connection for the database
  Returns  : none
  Args     : named arguments:
           :
=cut
###########################################################################
sub Connect{
  my $self = shift;
  $self->{_dbh} = DBI->connect($self->{_dsn},$self->{_user},$self->{_password},{RaiseError=>1});
  return;
}

###########################################################################
=head2 Disconnect
 
  Title    : Disconnect
  Usage    : Disconnect();
  Function : disconnects the current db connection
  Returns  : none
  Args     : named arguments:
           :
=cut
###########################################################################
sub Disconnect{
  my $self = shift;
  $self->{_dbh}->disconnect;
  return;
}

###########################################################################
=head2 BeginTransaction
 
  Title    : BeginTransaction
  Usage    : BeginTransaction();
  Function : starts a sql transaction
  Returns  : none
  Args     : named arguments:
           :
=cut
###########################################################################
sub BeginTransaction{
  my $self = shift;
  $self->{_dbh}->begin_work();
  return;
}

###########################################################################
=head2 CommitTransaction
 
  Title    : CommitTransaction
  Usage    : CommitTransaction();
  Function : commit the current sql transaction
  Returns  : none
  Args     : named arguments:
           :
=cut
###########################################################################
sub CommitTransaction{
  my $self = shift;
  $self->{_dbh}->commit();
  return;
}

###########################################################################
=head2 RollBackTransaction
 
  Title    : RollBackTransaction
  Usage    : RollBackTransaction();
  Function : cancel the current sql transaction
  Returns  : none
  Args     : named arguments:
           :
=cut
###########################################################################
sub RollBackTransaction{
  my $self = shift;
  $self->{_dbh}->rollback();
  return;
}

###########################################################################
=head2 executeQuery
 
  Title    : executeQuery
  Usage    : executeQuery("select * from test;");
  Function : execute a query and prints it's results
  Returns  : result of the query
  Args     : named arguments:
           : query => sql query to run
           :
=cut
###########################################################################
sub executeQuery{
    my $self = shift;
    my $query = shift;
    return "you must specify a query" if !defined($query);
    if(defined($self->{_dbh})){
      my $results;
      eval{
        my $stmt = $self->{_dbh}->prepare(qq{$query});
        $stmt->execute();
        if($query =~ m/select/){
          my $rows = $stmt->fetchall_arrayref;
          if($self->{_format} && $self->{_format} ne ""){
            $results = ($self->{_format} eq "JSON") ? JSON->new->utf8(1)->pretty(1)->encode($rows) : pl2xml($rows);
          }
        }
      };
      warn "$DBI::errstr" if ($@);
      return $results;
    }
}

###########################################################################
=head2 executeQueryHtml
 
  Title    : executeQueryHtml
  Usage    : executeQueryHtml("select * from test");
  Function : execute a query and prints it's results using the html format
  Returns  : result of the query in html format
  Args     : named arguments:
           : query => sql query to run
           :
=cut
###########################################################################
sub executeQueryHtml{
    my $self = shift;
    my $query = shift;
    return "you must specify a query" if !defined($query);
    if(defined($self->{_dbh})){
        my $html;
        eval{
            my $stmt = $self->{_dbh}->prepare(qq{$query});
            $stmt->execute();
            $html = "<table>";
            my $rows = $stmt->fetchall_arrayref;
            foreach my $row (@{$rows}) {
                $html .= "<tr>";
                foreach my $column (@{$row}){
                  $html .= "<td>" . $column . "</td>";
                }
                $html .= "</tr>";
            }
            $html .= "</table>";
        };
        warn "$DBI::errstr" if ($@);
        return $html;
    }
}

###########################################################################
=head2 getError
 
  Title    : getError
  Usage    : getError();
  Function : return the last value of $DBI::errstr
  Returns  : a string contaning the last error description
  Args     : named arguments:
           :
=cut
###########################################################################
sub getError{
  my $self = shift;
  if($DBI::err && $DBI::err ne ''){
    if(defined($DBI::errstr)){
      return $DBI::errstr;
    }
  }
  return "";
}

1;