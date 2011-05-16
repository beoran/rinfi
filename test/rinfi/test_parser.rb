require 'test_helper'
require 'rinfi'
require 'parslet'
require 'parslet/convenience'


def parse(rule, text)
  parser = Rinfi::Parser.new
  rule   = parser.send(rule.to_sym)
  return rule.parse_with_debug(text)
  rescue $! 
  p $!
  puts $!.backtrace.join("\n")
  return nil 
end

def noparse(rule, text)
  parser = Rinfi::Parser.new
  rule   = parser.send(rule.to_sym)
  rule.parse(text)
  return false
  rescue $! 
  # p $!
  return true 
end


assert { Rinfi::Parser }
include Rinfi
assert { Parser }
res = nil 
 

assert { parse :ws                  , "    "          }
assert { parse :ws                  , " \n\t"         }
assert { parse :ws                  , " 
       "  }
assert { noparse :ws                , "Hello"         }
assert { noparse :ws                , "n"             }
assert { noparse :ws                , "t"             }
assert { parse(:word                , "hello")        }
assert { noparse :word              , "   "           }
assert { noparse(:word              , "hello world")  }
assert { parse(:word_nokw           , "hello")        }
assert { noparse(:word_nokw         , "is")           }
assert { parse :no_kw_clause        , "open the gate" }
assert { noparse :no_kw_clause      , "door is thing" }
assert { res = parse :clause        , "hello world"   }
assert { res = parse :sentence_end  , ". "            }
assert { res = parse :exclaim_end   , "! "            }
assert { res = parse :question_end  , "? "            }
assert { res = noparse :sentence_end, " "             }
assert { tes = parse :is_clause     , "A door is a thing"        }
assert { res = parse :sentence      , "Hello world."             }
assert { res = parse :sentence      , "The door's size is ten."  }
assert { res = parse :sentence      , "The door's size is ten."  }
assert { res = parse :sentence      , "Hello world, this is me." }
assert { res = parse :paragraph     , %{Hello world, this is me!
Life should be, yeah, fun for everyone.   }
}

assert { res = parse :text          , %{Hello world, this is me!
Life should be, yeah, fun for everyone.

And it goes on here in another paragraph.
}
}

assert do res = parse :text          , %{I say hello to the world, this is me!
Life should be, yeah, fun for everyone. "And a String 
too"

And it goes on here in another paragraph.
(And there is comment)

The door's size is 10 .
}
end



=begin
assert { parse :sentence            , %{hello.}         }
assert { res = parse :sentence      , %{hello , world.} }
assert { parse(:comment             , "(hello comment)") }
assert { parse :sqstring            , %{'hello'}      }
assert { parse :dqstring            , %{"hello"}      }
assert { parse :string              , %{'hello'}      }
assert { parse :string              , %{"hello"}      }
=end


# assert { res = parse(:generic_clause, "hello world") }
p res

# assert { parse(:clause        , "hello world") }






# 
# assert { Parser.normalize("Hello\rworld") == "Hello\nworld" } 
# assert { Parser.normalize("Hello\\\rworld") == "Hello world" }
# assert { Parser.normalize("Hello,  \nworld") == "Hello, world" }
# 
# parser = nil 
# assert { parser = Parser.new(nil) } 
# para = nil 
# txt1 = %{Para 1 Line 1
# Para 1 Line 2
#  
# Para 2 Line 1.      Para 2 Line 2
# Para 2 Line 3
#  
# Para 3 Line 1 
# } 
# assert { para = parser.split_paragraphs(txt1) }
# assert { para.size == 3 } 
# assert { para.last == "Para 3 Line 1 \n" }
# lines = nil 
# assert { lines = parser.split_lines(para[1]) }
# assert { lines.size == 3 } 
# assert { lines.last == "Para 2 Line 3" } 
#  
# tst2 = "This line has several reading signs: the colon, the semicolon and the comma; but it should parse correctly and ignore extrateranous  spaces   like  these "
# 
# words = nil
# assert { words = parser.split_words(tst2) }
# p words
# assert { words.size == 27 }
# res = nil   
# assert { res = parser.parse(tst2) }







