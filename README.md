# [discourse-navigation][codiss-category]

[![Discourse on Codiss][codiss-badge]][codiss-category]

### About

Plugin to add a custom nav menu links to your Discourse website.


### Supported Menus

List of currently available locations where the custom menu links can be added.

* Top Main Menu ([_known issue_][issue-4])
* Hamburger Menu
 * General Links
 * Footer Links ([_known issue_][issue-3])

> [PR][issue-3] submitted in official Discourse repo to resolve `Footer Links` issue.


### Screenshot

![][screenshot]


### Installation

Repo is at: https://github.com/vinkas0/discourse-navigation

In your `app.yml` add:

```
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - mkdir -p plugins
          - git clone https://github.com/discourse/docker_manager.git
          - git clone https://github.com/vinkas0/discourse-navigation.git
```

And then rebuild the container:

```
./launcher rebuild app
```

### Configuration

You can easily add your custom menu links in `/admin/plugins/navigation` path.



[screenshot]: https://codiss.com/uploads/default/optimized/1X/c19632482295e2ea4e88672eb146627f23cf9abe_1_690x328.png

[issue-3]: https://github.com/vinkas0/discourse-navigation/issues/3
[issue-4]: https://github.com/vinkas0/discourse-navigation/issues/4

[codiss-category]: https://codiss.com/c/discourse-navigation
[codiss-badge]: https://img.shields.io/badge/discourse-on_Codiss-blue.svg?style=flat-square
