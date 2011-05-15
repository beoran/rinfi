require 'parselet'
=begin 
  A door is a thing.
  A color is a quality.
  Color can be red.
  Visible can only be true or false.
  A door has a color.
  Open can only be true or false.
  A door can be open.
  To open a door make the door's open true.
  To close a door make the door's open false.
  To open something make it's open true.
  To close something make it's open false.
  

=end


module Rinfi
  class Parser < Parselet::Parser
    
    def initialize(world)
      super()
      @world = world
    end
    
    def stri(str)
      key_chars = str.split(//)
      key_chars.
        collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
        reduce(:>>)
    end
    
    rule(:space)         { match[ \t].repeat }
    rule(:space?)        { space? }
    rule(:crlf)          { match['\r']  >> match['\n']                        }
    rule(:cr)            { match['\r']                                        }
    rule(:lf)            { match['\n']                                        }
    rule(:cr_or_lf)      { lf  | crlf | cr                                    }
    
    
    # Comments
    rule(:comment) do
      str('(') >> (str(')').absent? >> any).repeat.as(:comment) |
      str('(') >> comment >>  (str(')')
    end
    
      
    rule :dqstring do
      str('"') >>
      (
        (str('\\') >> any) |
        (str('"').absent? >> any)
      ).repeat.as(:string) >>
      str('"')
    end
  
    rule :sqstring do
      str("'") >>
      (
        (str('\\') >> any) |
        (str("'").absent? >> any)
      ).repeat.as(:string) >>
      str("'")
    end
    
    rule(:string) do
      qdstring || sqstringS
    end
    
    
    rule(:sentence_end)  { (str('.')| lf | crlf | cr) >> ws?                }
    rule(:paragraph_end) { cr_or_lf.repeat(2) >> ws?                        }
    
    rule (:paragraph) do
      ((sentence | comment | string).repeat.maybe).as(:paragraph) >> paragraph_end
    end
    
    rule(:text) do
      paragraph.repeat.maybe.as(:text)
    end
    
    rule(:blanknldot)    { match[' .\t\r\n']                              }
    
    # this is subtle: use this to state that a rule must be followed
    # only by anything that rule can parse, however, the tokens parsed by 
    # rule are not consumed
    def followed_by(rule)
      (rule.absent? >> any).absent?
    end
  
    def self.keywords(*names)
      names.each do |name|
        rule("kw_#{name}") do 
        # this is subtle: a keyword may be followed by blanks alone
        # so we say, not followe by(not blank followed by any character)
        # which means "followed by a blank character"
          stri(name.to_s).as(name) >> followed_by(blanknldot)
        end  
      end
    end

    keywords :if, :then, :else, :when, :in, :of, :while, :until, :is, :object

    def self.ignore_words(*names)
      rule("ignore_words") do 
        names.each do |name|
          str(name.to_s).as(name) >> followed_by(blanknldot)
        end  
      end
    end

  end
end