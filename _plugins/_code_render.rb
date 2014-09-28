module Jekyll
  module Converters
    class Markdown
      class RedcarpetParser
        module WithPygments
          def block_code(code, lang)
            require 'pygments'
            output = add_code_tags(Pygments.highlight(code, :lexer => lang, :options => { :encoding => 'utf-8', :startinline => true }), lang )
          end
        end
      end
    end
  end
end