# jekyll-page-collections

A Jekyll plugin to manage collections of pages that behave just like posts.

## Why would I want other pages just like posts?

Have you ever been building a Jekyll site that you wanted to have chronological
listings in addition to the regular posts that you have?  Well, that is
a perfect case for page collections.  They behave just like posts with all of
the niceties of posts.  You could use it for project listings, team member
listings, ideas, or whatever else you want.

## Install

Install the `page_collections.rb` file under your `_plugins` directory.
I prefer to use Git submodules to do this so that you can more easily keep track
of where the plugin came from as well as keep it up to date.

```
cd <jekyll-site-root>
git submodule add git@github.com:jeffkole/jekyll-page-collections.git _plugins/.jekyll-page-collections
cd _plugins
ln -s .jekyll-page-collections/page_collections.rb .
git add page_collections.rb
git commit
```

## Configuration & Files

Add to your configuration a new list called `page_collections` whose elements
are the names of the collections.  Each element can be a hash that offers the
following configuration options per collection:

* `permalink`: The permalink style, just like the main configuration option. The
  default value is the same as the value set for the site configuration.
* `source`: The name of the directory where the pages will be found.  The
  default is the name of the collection preceeded with an underscore.

Example:

```
page_collections:
- projects:
    permalink: pretty
- team
- miscellaneous:
    source: _misc
```

## Usage

Reference the collections from the `site.data` hash like so:

```
{% for project in site.data['projects'] %}
  <h3><a href="{{ project.url }}">{{ project.title }}</a></h3>
{% endfor %}
```

## What's missing?

Pagination.  I have not even tested to see if pagination works, but I get the
feeling it will not.

## Compatibility

`jekyll-page-collections` has been tested with Jekyll 1.4.3.
