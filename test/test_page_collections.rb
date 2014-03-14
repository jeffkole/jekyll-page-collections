require 'jekyll'
require 'test/unit'
require 'shoulda-context'

class TestPageCollections < Test::Unit::TestCase
  SOURCE_DIR = File.join(File.dirname(__FILE__), "source")
  DEST_DIR   = File.join(SOURCE_DIR, "_site")

  TEST_OPTIONS = {
    'source'         => SOURCE_DIR,
    'destination'    => DEST_DIR
  }

  context "Generating a site with page collections" do
    config = Jekyll.configuration(TEST_OPTIONS)
    site = Jekyll::Site.new(config)
    site.process

    should "create pages for each page" do
      assert_not_nil(site.data['page_collections'])
      site.config['page_collections'].each do |collection|
        assert_not_nil(site.data['page_collections'][collection_name(collection)])
      end
    end

    should "create directories for each collection" do
      site.config['page_collections'].each do |collection|
        assert(File.exists?(File.join(DEST_DIR, collection_name(collection))))
      end
    end

    should "honor the permalink style" do
      assert(File.exists?(File.join(DEST_DIR, "projects", "2014", "01", "01", "new-years-resolution", "index.html")))
      assert(File.exists?(File.join(DEST_DIR, "projects", "plugins", "jekyll",
                                    "2014", "03", "05", "jekyll-page-collections", "index.html")))
      assert(File.exists?(File.join(DEST_DIR, "team", "jeff-kolesky", "index.html")))
      assert(File.exists?(File.join(DEST_DIR, "miscellaneous", "2014", "03", "05", "some-miscellany.html")))
    end

    should "create category listings for each collection" do
      project_collection = site.data['page_collections']['projects']
      categories = project_collection.categories
      assert_equal(2, categories.size)
      assert_equal("Jekyll Page Collections", categories['plugins'].first.title)
      assert_equal("Jekyll Page Collections", categories['jekyll'].first.title)
    end

    should "create tag listings for each collection" do
      project_collection = site.data['page_collections']['projects']
      tags = project_collection.tags
      assert_equal(6, tags.size)
      assert_equal("New Year's Resolution", tags['resolutions'].first.title)
      assert_equal(2, tags['shared'].size)
      assert_equal(project_collection.pages, tags['shared'])
    end

    context "A collection with multiple pages" do
      should "have active previous and next attributes on each page" do
        project_collection = site.data['page_collections']['projects']
        projects = project_collection.pages
        assert_equal(2, projects.size)
        assert_nil(projects.first.previous)
        assert_equal(projects[-1], projects.first.next)
        assert_nil(projects[-1].next)
        assert_equal(projects.first, projects[-1].previous)
      end
    end
  end

  private

  def collection_name(collection)
    if collection.is_a?(Hash)
      collection.keys.first
    else
      collection.to_s
    end
  end
end
