# Perl DBI links

More information can be found in the [Perl DBI documentation](http://dbi.perl.org/).

# Perl DBD links

Perl DBD modules can be found in the  [CPAN documentation](http://search.cpan.org/).

# Setting up the plugin configuration

For all parameter descriptions below, required parameters are shown in
<span class=".required">bold italics</span>.

Plugin configurations are sets of parameters that apply across some or
all of the plugin’s procedures. They reduce repetition of common values,
create predefined sets of parameters for end users, and securely store
credentials where needed. Each configuration is given a unique name that
is entered in designated parameters on procedures that use them.

# Plugin configuration parameters

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Configuration Name</p></td>
<td style="text-align: left;"><p>Provide a unique name for the
configuration. (Required)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>User Name</p></td>
<td style="text-align: left;"><p>Provide the user login ID for your
database connection. (Required)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Password</p></td>
<td style="text-align: left;"><p>Provide the user-specified password.
(Required)</p></td>
</tr>
</tbody>
</table>

# Plugin procedures

# ExecuteQuery

This procedure creates a database connection through the Perl DBI module
and a Perl DBD module to execute an SQL statement against the
corresponding database.

You can access any database indirectly by using a preconfigured ODBC.

Additional Perl modules are required for the following databases:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Database</th>
<th style="text-align: left;">Module name</th>
<th style="text-align: left;">CPAN reference</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Oracle</p></td>
<td style="text-align: left;"><p>DBD-Oracle</p></td>
<td style="text-align: left;"><p><a href="http://search.cpan.org/~pythian/DBD-Oracle-1.30/Oracle.pm">DBD-Oracle at CPAN</a></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SQLite</p></td>
<td style="text-align: left;"><p>DBD-SQLite</p></td>
<td style="text-align: left;"><p><a href="http://search.cpan.org/~adamk/DBD-SQLite-1.33/lib/DBD/SQLite.pm">DBD-SQLite
at CPAN</a></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Postgres</p></td>
<td style="text-align: left;"><p>DBD-Pg</p></td>
<td style="text-align: left;"><p><a href="http://search.cpan.org/dist/DBD-Pg/Pg.pm">DBD-Pg at
CPAN</a></p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Database engine</p></td>
<td style="text-align: left;"><p>Choose the database engine you want to
connect to. Available options are: SQLServer, MySql, Oracle, Sqlite,
Postgres, or an ODBC connection to any database. (Required)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Database name</p></td>
<td style="text-align: left;"><p>The name of the database you want to
use. (Required)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Server</p></td>
<td style="text-align: left;"><p>Database server name.
(Required)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Port</p></td>
<td style="text-align: left;"><p>Database port. Common default ports
are:</p>
<ul>
<li><p>3306 (Mysql)</p></li>
<li><p>1433 (SQLServer)</p></li>
<li><p>1521 (Oracle)</p></li>
<li><p>5432 (Postgres)</p></li>
</ul></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Enable transactions</p></td>
<td style="text-align: left;"><p>If checked, this option protects your
data in case of errors.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Display format</p></td>
<td style="text-align: left;"><p>Choose a display format.
(Required)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Sql query</p></td>
<td style="text-align: left;"><p>The query to run against the
database.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Sql file</p></td>
<td style="text-align: left;"><p>Absolute path to a SQL script.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Configuration name</p></td>
<td style="text-align: left;"><p>Name of the configuration that contains
the database user and password. (Required)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Result (output property path)</p></td>
<td style="text-align: left;"><p>Property name used to store the result
of queries.</p></td>
</tr>
</tbody>
</table>

# BackUpDB

Creates a backup for the specified database.

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Database engine</p></td>
<td style="text-align: left;"><p>Choose the database engine you want to
connect to. Available options are: SQLServer, MySql, Oracle, Postgres
and Sqlite. (Required)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Command Line Utility</p></td>
<td style="text-align: left;"><p>Absolute path to a backup command
utility. (Required):</p>
<ul>
<li><p><code>mysqldump</code> (Mysql)</p></li>
<li><p><code>osql</code> (SQLServer)</p></li>
<li><p><code>exp</code> (Oracle)</p></li>
<li><p><code>pg_dump</code> (Postgres)</p></li>
</ul></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Database name</p></td>
<td style="text-align: left;"><p>The name of the database to back up.
(Required)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Server</p></td>
<td style="text-align: left;"><p>Database server name.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Port</p></td>
<td style="text-align: left;"><p>Database port. Some of the default
ports are:</p>
<ul>
<li><p>3306 (Mysql)</p></li>
<li><p>1433 (SQLServer)</p></li>
<li><p>1521 (Oracle)</p></li>
<li><p>5432 (Postgres)</p></li>
</ul></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Configuration name</p></td>
<td style="text-align: left;"><p>Name of the configuration that contains
the database user and password. (Required)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Name of the backup file</p></td>
<td style="text-align: left;"><p>Name of the backup file (without
extension). If you leave the field blank, the file name is
"backup".</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Destination path</p></td>
<td style="text-align: left;"><p>The path where you want to store your
backup file. (Required)</p></td>
</tr>
</tbody>
</table>

# Examples and use cases

The following example shows how to create a configuration:

![screenshot](htdocs/images/dbi-1.png)

The following example shows a list of server configurations:

![screenshot](htdocs/images/dbi-2.png)

The following example shows a completed ExecuteQuery parameter form:

![screenshot](htdocs/images/dbi-3.png)

The following example shows output for ExecuteQuery:

![screenshot](htdocs/images/dbi-4.png)

The following example shows a completed MySql backup parameter form:

![screenshot](htdocs/images/dbi-5.png)

The following example shows output for a MySQL backup:

![screenshot](htdocs/images/dbi-6.png)

The following example shows a completed Oracle backup parameter form:

![screenshot](htdocs/images/dbi-7.png)

The following example shows output for an Oracle backup:

![screenshot](htdocs/images/dbi-8.png)

The following example shows a completed SQL Server backup parameter
form:

![screenshot](htdocs/images/dbi-9.png)

The following example shows output for a SQL Server backup:

![screenshot](htdocs/images/dbi-10.png)

# Release notes

## EC-DBI 2.0.4

-   The documentation has been migrated to the main documentation site.

## EC-DBI 2.0.3

-   Added metadata that is required for 9.0 release.

## EC-DBI 2.0.2

-   Fixed issue with configurations being cached for Internet Explorer(R).

## EC-DBI 2.0.1

-

## EC-DBI 2.0.0

-   The result (output property path) parameter was added.

-   JSON and XML formats for results were added.

## EC-DBI 1.0.2

-   Procedure names were changed in the step picker section.

## EC-DBI 1.0.1

-   XML parameter panels were added.

-   The Help page was updated.

## EC-DBI 1.0.0

-   Initial release.
