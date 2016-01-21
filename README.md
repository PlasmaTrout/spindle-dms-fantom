### Spindle Document Mangement System
The spindle document management system is a blend of a few different ideas into a solution for blogging, documentation management
and/or content management. The idea is to have a centralized deployed webserver, platform neutral, that loads and monitors
a specifically structured git repositories. Is uses these repositories to serve up static content as web content.

You can think of it vaguely as jekyl but with the content itself being stored in a git repository that the server monitors
and pull when publishes occur.

## Content Idea 
The main idea of content creation is to use a form of markdown to make creating the pages easier at the same time using
wordpress'esque plugin syntax to allow dynamic content and customizations.

CSS and Javascript deposited into a repository is auto loaded via directory naming conventions. For instance a css directory
at the root level applies that css to all generated documents. A css directory located in a posts directory will append specific
css to any content found in that directory.

## Repos
The repos directory of the server can have an unlimited set of repositories available. Each can then be accessed by:

``` http://server:port/reponame ```

The content nodes inside of the repo determine the path from there. For instance the file testdoc.fandoc (a fandoc type markdown)
is located in the repo named "test-repo" to access it we navigate to:

```
http://localhost:8080/test-repo/testdoc.fandoc
```

And thats the core tenant of how content is found.
