# [discourse-navigation](https://codiss.com/c/discourse-navigation)

### About

Plugin to add a custom nav menu links to your Discourse website.


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

### Locations

List of currently available locations where the custom menu links can be added.

* Top Main Menu
* Hamburger Menu
 * General Links
 * Footer Links
