# Git Log

```
commit 0aae49afb10ec71a757dbcfa6169c81bec51f7c7
Author: Sebastian Sangervasi <ssangervasi@squareup.com>
Date:   Mon Jul 29 10:09:25 2019 -0700

    Copied in sourcerer code
```

# CLOC


cloc|github.com/AlDanial/cloc v 1.82  T=0.03 s (1138.4 files/s, 45564.8 lines/s)
--- | ---

Language|files|blank|comment|code
:-------|-------:|-------:|-------:|-------:
Ruby|28|186|180|850
Markdown|7|68|0|125
Bourne Again Shell|1|6|0|35
YAML|1|6|10|15
--------|--------|--------|--------|--------
SUM:|37|266|190|1025

# Spec Results
## Fam

```
No examples found.

Finished in 0.00017 seconds (files took 0.33262 seconds to load)
0 examples, 0 failures

```

## Boilerplate

```

Fam::CLI::Add::Parents
  when the child and parent names are given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when all names are missing
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::CLI::Add::Person
  when a name is given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when no name is provided
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::CLI::Get::Parents
  when a child name is given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when the child name is missing
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::CLI::Get::Person
  when a name is given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when the name is missing
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::File::Reader::JSONReader
  #read
    when the file does not exist
      raises an error
    when the file exists
      should be a kind of Hash

Fam::File::Writer::JSONWriter
  #write
    should be a kind of String
    modifies the specified file

Finished in 14.43 seconds (files took 0.49585 seconds to load)
20 examples, 0 failures

```

