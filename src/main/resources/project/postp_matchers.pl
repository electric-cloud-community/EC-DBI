@::gMatchers = (
  #missing DBI module
  {
   id =>        "db-missing-module",
   pattern =>          q{Can't locate DBD\/(.*) in @INC},
   action =>           q{&addSimpleMessage("db-missing-module", "The $1 module is required");setProperty("outcome", "error" );updateSummary();},
  },
  #affected rows
  {
   id =>        "sql-affected-rows",
   pattern =>          q{\((\d+) rows affected\)},
   action =>           q{addSimpleMessage("sql-affected-rows", "$1 rows affected");updateSummary();},
  },
  #constraint violation
  {
    id =>       "sql-constraint",
    pattern =>          q{The (.*) statement conflicted with the (.*) constraint (.*)},
    action  =>          q{addSimpleMessage("sql-constraint", "The $1 statement conflicted with the $2 constraint $3");setProperty("outcome", "error" );updateSummary();},
  },
  #update identity column
  {
    id =>       "sql-identity-col",
    pattern =>          q{Cannot update identity column (.*)},
    action  =>          q{addSimpleMessage("sql-identity-col", "Cannot update identity column $1");setProperty("outcome", "error" );updateSummary();},
  },
  #incorrect syntax
  {
    id =>       "sql-incorrect-syntax",
    pattern =>          q{Incorrect syntax near the keyword (.*)\(},
    action =>           q{addSimpleMessage("sql-incorrect-syntax", "Incorrect syntax near the keyword $1");setProperty("outcome", "error" );updateSummary();},
  },
  #datatype missing
  {
    id =>       "sql-data-type",
    pattern =>          q{The definition for column (.*) must include a data type.},
    action =>           q{addSimpleMessage("sql-incorrect-syntax", "The definition for column $1 must include a data type.");setProperty("outcome", "error" );updateSummary();},
  },
  #invalid object name
  {
    id =>       "sql-invalid-object",
    pattern =>          q{Invalid object name (.*)\(},
    action =>           q{addSimpleMessage("sql-invalid-object", "Invalid object name : $1");setProperty("outcome", "error" );updateSummary();},
  },
  #invalid column name
  {
    id =>       "sql-invalid-column",
    pattern =>          q{Invalid column name (.*)\(},
    action =>           q{addSimpleMessage("sql-invalid-column", "Invalid column name : $1");setProperty("outcome", "error" );updateSummary();},
  },
  #pk violation
  {
    id =>       "sql-pk-violation",
    pattern =>          q{insert duplicate key in object (.*)\(},
    action =>           q{addSimpleMessage("sql-pk-violation", "Cannot insert duplicate key in object $1");setProperty("outcome", "error" );updateSummary();},
  },
  #null violation
  {
    id =>       "sql-null-violation",
    pattern =>          q{Cannot insert the value NULL into column (.*)\(},
    action =>           q{addSimpleMessage("sql-null-violation", "Cannot insert the value NULL into column $1");setProperty("outcome", "error" );updateSummary();},
  },
  #login failed
  {
    id =>       "sql-login-failed",
    pattern =>          q{Login failed for user (.*)\(},
    action =>           q{addSimpleMessage("sql-login-failed", "Login failed for user $1");updateSummary();},
  },
  #invalid conversion
  {
    id =>       "sql-invalid-conversion",
    pattern =>          q{Conversion failed when converting the (.*) value (.*)},
    action =>           q{addSimpleMessage("sql-invalid-conversion", "Conversion failed when converting the $1 value $2");setProperty("outcome", "error" );updateSummary();},
  },
  #execute failed
  {
    id =>       "mysql-execute-error",
    pattern =>          q{execute failed: (.*) at},
    action =>           q{addSimpleMessage("mysql-execute-error", "$1");setProperty("outcome", "error" );updateSummary();},
  },
  #prepare failed
  {
    id =>       "mysql-prepare-error",
    pattern =>          q{prepare failed: (.*) at},
    action =>           q{addSimpleMessage("mysql-prepare-error", "$1");setProperty("outcome", "error" );updateSummary();},
  },
);

sub addSimpleMessage {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub updateSummary() {
 
    my $summary = (defined $::gProperties{"db-missing-module"}) ? $::gProperties{"db-missing-module"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-affected-rows"}) ? $::gProperties{"sql-affected-rows"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-constraint"}) ? $::gProperties{"sql-constraint"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-identity-col"}) ? $::gProperties{"sql-identity-col"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-incorrect-syntax"}) ? $::gProperties{"sql-incorrect-syntax"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-data-type"}) ? $::gProperties{"sql-data-type"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-invalid-object"}) ? $::gProperties{"sql-invalid-object"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-invalid-column"}) ? $::gProperties{"sql-invalid-column"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-pk-violation"}) ? $::gProperties{"sql-pk-violation"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-null-violation"}) ? $::gProperties{"sql-null-violation"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-login-failed"}) ? $::gProperties{"sql-login-failed"} . "\n" : "";
    $summary .= (defined $::gProperties{"sql-invalid-conversion"}) ? $::gProperties{"sql-invalid-conversion"} . "\n" : "";
    $summary .= (defined $::gProperties{"mysql-execute-error"}) ? $::gProperties{"mysql-execute-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"mysql-prepare-error"}) ? $::gProperties{"mysql-prepare-error"} . "\n" : "";
    setProperty ("summary", $summary);
}