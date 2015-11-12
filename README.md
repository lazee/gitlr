gitlr
=====

A Command Line Interface for managing and analyzing GitHub repositories within an organization.

This is work in progress : Features will be added upon request or when needed by me.

Install
-------
```
bundle install 
```

Config
------
You need to configure your organization at Github in the file ~/.config/gitlr/config.yaml

```
organization: <ORGANIZATION>
```

And you also need to setup GitHub login in your ~/.netrc file:

```
machine api.github.com
  login defunkt
  password <YOUR PERSONAL ACCESS TOKEN CREATED ON GITHUB.COM>
```


Run
---
```
bundle exec bin/gitlr
```

Examples
--------

Print ids for all projects within your organization that has Java as its main language
```
bundle exec bin/gitlr --format=id query org repos --language_filter java
```

Pretty print all projects within your organization that has Java as its main language
```
bundle exec bin/gitlr --format=pretty query org repos --language_filter java
```

CSV print all teams within your organization without CSV-header
```
bundle exec bin/gitlr --no-header --format=pretty query org teams
```

Run gitlr for a full overview of all the available features...



Useful resources
----------------
 * http://www.rubydoc.info/github/pengwynn/octokit/
 * http://www.ruby-doc.org/core-2.1.4/
 * http://bundler.io/
