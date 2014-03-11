module Jekyll
  class PageCollectionConfiguration
    attr_reader :name

    def initialize(site, name)
      @site_config = site.config
      @name = name
      @config = (@site_config['page_collections'].find { |c| c.keys.first == @name }[@name]) || {}
    end

    def permalink_style
      (@config['permalink'] || @site_config['permalink']).to_sym
    end

    def containing_dir
      @config['source'] || "_#{@name}"
    end
  end

  class CollectionPage < Post
    def initialize(site, source, dir, name, config)
      @config = config
      super(site, source, dir, name)
    end

    def containing_dir(source, dir)
      return File.join(source, dir, @config.containing_dir)
    end

    def relative_path
      File.join(@dir, @config.containing_dir, @name)
    end

    def inspect
      "<CollectionPage: #{self.id}"
    end

    def template
      style = case @config.permalink_style
              when :pretty
                "/:categories/:year/:month/:day/:title/"
              when :none
                "/:categories/:title.html"
              when :date
                "/:categories/:year/:month/:day/:title.html"
              when :ordinal
                "/:categories/:year/:y_day/:title.html"
              else
                @config.permalink_style.to_s
              end
      "/#{@config.name}#{style}"
    end

    def next
      pages = self.site.data[@config.name]
      pos = pages.index(self)

      if pos && pos < pages.length-1
        pages[pos+1]
      else
        nil
      end
    end

    def previous
      pages = self.site.data[@config.name]
      pos = pages.index(self)
      if pos && pos > 0
        pages[pos-1]
      else
        nil
      end
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
        config = PageCollectionConfiguration.new(site, name)
        pages = read_content(site, config, CollectionPage).sort
        site.pages.concat(pages)
        site.data[name] = pages
      end
    end

    private

    def read_content(site, config, klass)
      dir = ''
      site.get_entries(dir, config.containing_dir).map do |entry|
        klass.new(site, site.source, dir, entry, config) if klass.valid?(entry)
      end.reject do |entry|
        entry.nil?
      end
    end
  end
end
