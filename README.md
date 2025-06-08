# DependentsFinder

A tiny tool for Pharo 13 that is able to find probable dependants of packages (find packages that depend on our known packages).

It is not precise, false positives and false negatives are guaranteed. It mostly uses package names and StDependencyChecker.

It is just my one-time tool for a specific problem, it is also mostly untested and undocumented, but I decided to share it anyway.

Installation:

```Smalltalk
Metacello new
    baseline: 'DependentsFinder';
    repository: 'github://JanBliznicenko/DependentsFinder';
    load.
```
