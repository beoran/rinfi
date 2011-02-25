module Rinfi
  class Parser
    
    def initialize(world)
      @world = world
    end
    
    # Tiny error class. Probably will become stand alone later.
    class Error
      attr_reader :text
      attr_reader :context 
      
      def initialize(text, context = nil)
        @text, @context = text, context
      end
      
      def call(*args)
        printf "#{@text} near #{@context ? @context : unknown}\n" 
      end
    end
    
    # Tiny result class Probably will become stand alone later.
    class Result
      def initialize(&block)
        @block = block
      end
      
      def call(*args)
        @block.call(*args) 
      end
    end  
    
    
    def error(text, context = nil)
      return Error.new(text, context)
    end
    
    def result(&block)
      return Result.new(&block)
    end

    
    # Normalises OS-dependend newlines (\r\n or \r) to \n.
    # Also removes escaped newlines, or newlines after comma's or semicolons
    # or colons.
    def self.normalize(str)
      # Replace non-unix newlines with unix newlines.
      aid = str.gsub(/(\r\n)|\r/, "\n")
      # Remove escaped newlines, even if there are spaces after the escape 
      aid.gsub!(/\\[ ]*\n/, ' ')
      # Remove newlines after commas, colons and semicolons,
      # even if there are spaces after those reading signs. 
      aid.gsub!(/([\,\;\:]+)([ ]*\n)/, '\1 ')
      # Remove escaped periods, even if there are spaces after the escape 
      aid.gsub!(/\\[ ]+./, ' ')
      return aid 
    end  
    
    
    # Splits normalized input text into paragraphs. 
    # Paragraphs are separated by at least 2 newlines, ignoring any spaces. 
    def split_paragraphs(input)
      return input.split(/\n[ ]*\n+/)
    end
    
    # Splits a paragraph into lines. Lines are delimited by periods or newlines
    # ignoring any spaces around them.
    # Escapes have already been removed by normalize.    
    def split_lines(input)
      return input.split(/[ ]*[\.\n]+[ ]*/)
    end
    
    # Splits a line in words, making separate words of ; : and !
    # xxx: probably needs improving.
    def split_words(line)
      return line.scan(%r{[,;:]+|[^;: ,]+|(?=[ ]+)}).reject { |e| e.empty? }
    end
    
    
    # Parses an action
    def parse_action(action, words)
      return lambda { action.run(@world, words) } 
    end
    
    # Parses a line
    def parse_line(line)
      words = split_words(line)
      return error("Sorry, I didn't understand that.", line) unless words
      actname = words.first 
      return error("Sorry, I didn't understand that.", line) unless actname 
      action  = @world ? @world.find_action(actname) : nil 
      if action
        return parse_action(action, words)
      else
        return error("I don't know the verb '#{actname}'", line)
      end
    end
    
    # Parses a paragraph.
    def parse_paragraph(input)
      lines     = split_lines(input)
      result    = []
      for line in lines do
        result << parse_line(line) 
      end
      return result
    end
    
    # Parses input. Returns an array of arrays of runnable objects.
    def parse(input)
      norm        = self.class.normalize(input)
      paragraphs  = split_paragraphs(input)
      result      = []
      for paragraph in paragraphs do
        result    << parse_paragraph(paragraph)
      end 
      return result
    end
  
  end
end