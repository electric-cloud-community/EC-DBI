@::gMatchers = (
  #mysqldump error
  {
    id =>        "mysql-error",
    pattern =>          q{mysqldump: (.*)},
    action =>           q{&addSimpleMessage("mysql-error", "$1");setProperty("outcome", "error" );updateSummary();},
  },
  #sqlserver error
  {
    id =>       "osql-error",
    pattern =>          q{Cannot open backup device (.*)},
    action =>           q{&addSimpleMessage("osql-error", "Cannot open backup device: $1");setProperty("outcome", "error" );updateSummary();},
  },
  #abnormally backup
  {
    id =>       "sql-backupfailed",
    pattern =>          q{BACKUP DATABASE is terminating abnormally.},
    action =>           q{&addSimpleMessage("sql-backupfailed", "BACKUP DATABASE is terminating abnormally.");setProperty("outcome", "error" );updateSummary();},
  },
  #invalid path
  {
    id =>       "sqlite-invalid-path",
    pattern =>          q{The system cannot find the path specified.},
    action =>           q{&addSimpleMessage("sqlite-invalid-path", "The system cannot find the path specified.");setProperty("outcome", "error" );updateSummary();},
  },
  #sqlite file copied
  {
    id =>       "sqlite-copied-file",
    pattern =>          q{(\d+) file\(s\) copied.},
    action =>           q{&addSimpleMessage("sqlite-copied-file", "$1 file(s) copied");updateSummary();},
  },
  #oracle errors
  {
    id =>       "oracle-error",
    pattern =>          q{EXP-(\d+): (.*)},
    action =>           qq{&addSimpleMessage("oracle-error", "$2 error code: $1");setProperty("outcome", "error");updateSummary();},
  },
  #postgres errors
  {
    id =>       "pg-errors",
    pattern =>          q{FATAL: (.*)},
    action =>           qq{&addSimpleMessage("pg-errors", "$1");setProperty("outcome", "error");updateSummary();},
  },
);

sub addSimpleMessage {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub updateSummary() {
 
    my $summary = (defined $::gProperties{"mysql-error"}) ? $::gProperties{"mysql-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"osql-error"}) ? $::gProperties{"osql-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-backupfailed"}) ? $::gProperties{"sql-backupfailed"} . "\n" : "";
    $summary .= (defined $::gProperties{"sqlite-invalid-path"}) ? $::gProperties{"sqlite-invalid-path"} . "\n" : "";
    $summary .= (defined $::gProperties{"sqlite-copied-file"}) ? $::gProperties{"sqlite-copied-file"} . "\n" : "";
    $summary .= (defined $::gProperties{"oracle-error"}) ? $::gProperties{"oracle-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"pg-errors"}) ? $::gProperties{"pg-errors"} . "\n" : "";
    setProperty ("summary", $summary);
}