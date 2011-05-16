require 'parslet'
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
  class Parser < Parslet::Parser
    
     def initialize(world=nil)
       super()
       @world = world
     end
    
    def stri(str)
      key_chars = str.split(//)
      aid       = key_chars.collect! do |char| 
        match["#{char.upcase}#{char.downcase}"] 
      end
      aid.reduce(:>>)
    end

    root(:clause)
    
    rule(:blanknldot)    { match[' \.\t\r\n']                              }
    
    # this is subtle: use this to state that a rule must be followed
    # only by anything that rule can parse, however, the tokens parsed by 
    # rule are not consumed
    def followed_by(rule)
      (rule.absent? >> any).absent?
    end
    
    KEYWORDS = %w{if then else when in of while until is and or not to thing 
                  being place it its with of}

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

    keywords *KEYWORDS
    
    rule(:ws1)           { match[' \t']  | cr_or_lf >> cr_or_lf.absent?()     }
    rule(:ws)            { ws1.repeat(1)                                      }
    rule(:ws?)           { ws1.repeat(0)                                      }
    rule(:crlf)          { match["\r"]  >> match["\n"]                        }
    rule(:cr)            { match["\r"]                                        }
    rule(:lf)            { match["\n"]                                        }
    rule(:cr_or_lf)      { lf  | crlf | cr                                    }
    
    IGNORED_WORDS = %w{a an the} 
    
    rule :ignore do 
      res = nil
      IGNORED_WORDS.each do |name|
        aid =  (stri(name.to_s) >> followed_by(blanknldot))
        if !res 
          res = aid
        else
          res = res | aid  
        end  
      end
      res # will be ignored because there is no .as rule
    end
    
    rule :keyword do
      res = nil
      KEYWORDS.each do |name|
        rule  = self.method("kw_#{name}".to_sym).call()
        aid   = rule
        # aid = (stri(name.to_s) >> followed_by(blanknldot))
        if !res 
          res = aid
        else
          res = res | aid  
        end  
      end
      res # will automatically return a keyword .as(:keyword)
    end
    
    rule :apo_s do
      str("'s").as(:apo_s)
    end
    
    rule :number do
      match([0-9]).repeat(1)
    end
    
    rule :plain_word do
      (match["A-Za-z"].repeat(1)).as(:word)
    end
    
    rule :apo_s_word do
      (plain_word >> ws? >> apo_s).as(:apo_s_word)
    end
    
    
    rule :word do
       number | keyword | ignore | apo_s_word | plain_word 
    end
    
    rule :word_nokw do
      keyword.absent? >> (number | ignore | apo_s_word | plain_word)
    end
    
    rule :no_kw_clause do
      (word_nokw >> (ws >> word_nokw).repeat(0)).as(:nokw_clause)
    end

    rule :builtin do
      ( kw_thing | kw_place | kw_being )
    end
    
    rule :word_nokwbi do
      word_nokw | builtin
    end
    
    rule :no_kwbi_clause do
      (word_nokwbi >> (ws >> word_nokwbi).repeat(0)).as(:nokwbi_clause)
    end

    rule :is_clause do
      (no_kw_clause >> ws >> kw_is >> ws >> no_kwbi_clause).as(:is_clause) 
    end
    
    rule :generic_clause do
      (word >> (ws >> word).repeat(0)).as(:clause)
    end

    rule :clause do
      is_clause         |
      generic_clause 
    end

    rule(:clause_end)  do
       ws? >> match['\;\:\,'] >> ws?
    end
    
    rule(:question_end) do 
      str('?').as(:sign) >> ws?
    end

    rule(:exclaim_end) do 
      str('!').as(:sign) >> ws?
    end
    
    rule(:sentence_end) do 
      str('.').as(:sign) >> ws?
    end
    
    rule(:clause_list) do
      (clause >> (clause_end >> clause).repeat(0))
    end
    

    rule :exclaim_sentence do
      clause_list.as(:exclaim)   >>  exclaim_end
    end

    rule :question_sentence do
      clause_list.as(:question)  >>  question_end
    end
   
    rule :normal_sentence do
      clause_list.as(:sentence)  >>  sentence_end
    end
   
    # Comments
    rule(:comment) do
      str('(') >> (str(')').absent? >> any).repeat.as(:comment) >> str(')') >> ws? 
    end
    
      
    rule :dqstring do
      str("\"") >>
      (
        (str('\\') >> any) |
        (str("\"").absent? >> any)
      ).repeat.as(:string) >>
      str("\"")
    end
  
    rule :sqstring do
      str("\'") >>
      (
        (str('\\') >> any) |
        (str("\'").absent? >> any)
      ).repeat.as(:string) >>
      str("\'")
    end
    
    rule(:string) do
      (dqstring | sqstring) >> ws?
    end

    
    rule :sentence do
      normal_sentence | question_sentence | exclaim_sentence | comment | string
    end
    
    rule :paragraph do
       (sentence >> (sentence).repeat(0)).as(:paragraph)
    end
    
    rule(:paragraph_end) { cr_or_lf.repeat(2) >> ws?                        }
    
    rule(:text) do
      (paragraph >> (paragraph_end >> paragraph).repeat(0)).as(:text)
    end


=begin


    
    
    
    
    

    
    
    
    rule (:paragraph) do
      ((sentence | comment | string).repeat.maybe).as(:paragraph)
    end
    
    
    

    
=end
  end
end