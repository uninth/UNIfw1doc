


[![Documentation][logo]][documentation]
[logo]: src/GAiA/UNIfw1doc-user-documentation.textbundle/assets/img/UNIfw1doc-coverpage.png
[documentation]: src/GAiA/UNIfw1doc-user-documentation.textbundle/UNIfw1doc.pdf

# UNIfw1doc - Readme

**UNIfw1doc** is a systems which detects changes to the configuration of a
Check Point firewall-1 running GAiA and produces updated documentation. It
checks every quarter for changes to the rulebase and the object database,
and publish new documentation on a web-server running on the firewall.

### Security

The package installs a separate user and starts a webserver on localhost port
9876 on the firewall. The binding address may be changed and access to the
service should be restricted by the firewall. The web-server software is 
provided as part of the base operating system.

## Deployment

The RPM and the installation instruction is found [in RPM](RPM).

## Documentation

[The documentation in pdf is here](src/GAiA/UNIfw1doc-user-documentation.textbundle/UNIfw1doc.pdf).

For recreating the pdf documentation see
[README-documentation](src/GAiA/UNIfw1doc-user-documentation.textbundle/README-documentation.md)
in src/GAiA/UNIfw1doc-user-documentation.textbundle.

## Development

The source is written in shell and changes should be easy to adapt. It is possible to choose between
different documentation packages (CPrules, cp_webviz_tool and cpdb2web), the package assumes
cpdb2web.

## License

The documentation packages are licenced separately - see LICENCE, while 
this rest is released under a
[modified BSD License](https://opensource.org/licenses/BSD-3-Clause). 


