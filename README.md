**Jekyll added official support for [collections][] in [v2][]. I recommend you
use that instead.**

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
  Permalinks are always prepended with the collection name.
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

Each collection is added to a hash at `site.data['page_collections']` where the
key is the collection name, as specified in the configuration, and the value is
a `PageCollection` from which you can access `name`, `pages`, `categories`, and
`tags`.

Reference the collections from the `site.data['page_collections']` hash like so:

```
{% for project in site.data['page_collections']['projects'].pages %}
  <h3><a href="{{ project.url }}">{{ project.title }}</a></h3>
{% endfor %}
```

The `categories` and `tags` attributes of a `PageCollection` hold hashes of
category or tag names to lists of pages in the collection, similar to how `site`
holds hashes of categories and tags which key to lists of posts.

### `page_url` Tag

Just like the `post_url` tag can be used to generate links to posts without
having to hard-code them, this plugin registers a `page_url` tag.  The syntax is
similar but requires the name of the page collection before the name of the
page:

```
{% page_url projects 2014-03-05-jekyll-page-collections %}
```

### `previous` and `next`

Just like a post page has `previous` and `next` attributes that point to other
posts, page collection pages do too:

```
{% if page.previous %}
<p>Previous: <a href="{{ page.previous.url }}">{{ page.previous.title }}</a></p>
{% endif %}
{% if page.next %}
<p>Next: <a href="{{ page.next.url }}">{{ page.next.title }}</a></p>
{% endif %}
```

## What's missing?

Pagination.  I have not even tested to see if pagination works, but I get the
feeling it will not.

## Compatibility

`jekyll-page-collections` has been tested with Jekyll 1.4.3 on Ruby 1.9.3.

## Official Jekyll v2 Collections

Jekyll added [collections][] feature in [version 2][v2].  I would recommend using them
instead of this plugin.  If you are upgrading, the transition is easy:

1. Change `page_collections` to `collections` in `_config.yml`
2. Add `output: true` to each collection's configuration in `_config.yml`
3. Reference `site['collection-name']` instead of `site.data['page_collections']['collection-name']`
4. Hope that someone implements a `{% collection_url %}` [tag][tag] and pagination

[collections]: https://jekyllrb.com/docs/collections/
[v2]: https://github.com/jekyll/jekyll/blob/master/History.markdown#200--2014-05-06
[tag]: https://github.com/jekyll/jekyll/pull/4624
