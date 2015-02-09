gitlr
=====

A Command Line Interface for managing and analyzing GitHub repositories within an organization.

Install
-------
bundle install 

Config
------
You need to configure your rganization at Github in the file ~/.config/gitlr/config.yaml

```
organization: amedia
```

And you also need to setup GitHub login in your ~/.netrc file:

```
machine api.github.com
  login defunkt
  password <YOUR PERSONAL ACCESS TOKEN CREATED ON GITHUB.COM>
```


Run
---
bundle exec bin/gitlr

Useful resources
----------------
 * http://www.rubydoc.info/github/pengwynn/octokit/
 * http://www.ruby-doc.org/core-2.1.4/
 * http://bundler.io/
