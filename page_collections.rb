module Jekyll
  class CollectionPage < Post
  end

  class PageCollectionGenerator < Generator
    def generate(site)
      collections = site.config['page_collections'] || []
      collections.each do |collection|
        name = collection.keys.first
        collection_config = collection[name]
        pages = site.read_content('', "_#{name}", CollectionPage)
        site.data[name] = pages
      end
    end
  end
end
