module Jekyll
  class TagIndex < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      tag_title_prefix = site.config['tag_title_prefix'] || 'Posts Tagged &ldquo;'
      tag_title_suffix = site.config['tag_title_suffix'] || '&rdquo;'
      self.data['title'] = "#{tag_title_prefix}#{tag}#{tag_title_suffix}"
    end
  end

  class TagPool < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['title'] = "Browse All tags"
      self.data['tag_bags'] = []
      self.data['tag_url'] = File.join(site.config['url'], site.config['tag_dir'])
    end

    def load_tag_bag(bags)
      self.data['tag_bags'] = bags
    end
  end

  class TagGenerator < Generator
    safe true
    def generate(site)
      if site.layouts.key? 'tag'
        dir = site.config['tag_dir'] || 'tag'
        bags = []

        # generate tag pool
        site.tags.keys.sort.each_slice(3) do |tag_bag|
          bags << tag_bag
        end

        write_tags_pool(site, 'tags', bags)

        # generate tag pages
        site.tags.keys.each do |tag|
          write_tag_index(site, File.join(dir, tag), tag)
        end
      end
    end
    def write_tag_index(site, dir, tag)
      index = TagIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
    def write_tags_pool(site, dir, tag_bags)
      tagger = TagPool.new(site, site.source, dir)
      tagger.load_tag_bag(tag_bags)
      tagger.render(site.layouts, site.site_payload)
      tagger.write(site.dest)
      site.pages << tagger
    end
  end
end