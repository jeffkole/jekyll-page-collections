module Jekyll
  class CollectionPage < Post
    def initialize(site, source, dir, magic_dir, name, collection_name, collection_config)
      @magic_dir = magic_dir
      @collection_name = collection_name
      @collection_config = collection_config
      @permalink_style = ((collection_config && collection_config['permalink']) || site.config['permalink']).to_sym
      super(site, source, dir, name)
    end

    def containing_dir(source, dir)
      return File.join(source, dir, @magic_dir)
    end

    def relative_path
      File.join(@dir, @magic_dir, @name)
    end

    def inspect
      "<CollectionPage: #{self.id}"
    end

    def template
      style = case @permalink_style
              when :pretty
                "/:categories/:year/:month/:day/:title/"
              when :none
                "/:categories/:title.html"
              when :date
                "/:categories/:year/:month/:day/:title.html"
              when :ordinal
                "/:categories/:year/:y_day/:title.html"
              else
                @permalink_style.to_s
              end
      "/#{@collection_name}#{style}"
    end

    # Methods from Page

    def uses_relative_permalinks
      false
    end

    def html?
      output_ext == '.html'
    end
  end

  class PageCollectionGenerator < Generator
    def generate(site)
      collections = site.config['page_collections'] || []
      collections.each do |collection|
        name = collection.keys.first
        collection_config = collection[name]
        pages = read_content(site, '', "_#{name}", name, collection_config, CollectionPage)
        site.pages.concat(pages)
        site.data[name] = pages
      end
    end

    private

    def read_content(site, dir, magic_dir, collection_name, collection_config, klass)
      site.get_entries(dir, magic_dir).map do |entry|
        klass.new(site, site.source, dir, magic_dir, entry, collection_name, collection_config) if klass.valid?(entry)
      end.reject do |entry|
        entry.nil?
      end
    end
  end
end
