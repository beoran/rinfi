require 'test_helper'
require 'rinfi'

assert { Rinfi::Parser }
include Rinfi
assert { Parser } 
assert { Parser.normalize("Hello\rworld") == "Hello\nworld" } 
assert { Parser.normalize("Hello\\\rworld") == "Hello world" }
assert { Parser.normalize("Hello,  \nworld") == "Hello, world" }

parser = nil 
assert { parser = Parser.new(nil) } 
para = nil 
txt1 = %{Para 1 Line 1
Para 1 Line 2
 
Para 2 Line 1.      Para 2 Line 2
Para 2 Line 3
 
Para 3 Line 1 
} 
assert { para = parser.split_paragraphs(txt1) }
assert { para.size == 3 } 
assert { para.last == "Para 3 Line 1 \n" }
lines = nil 
assert { lines = parser.split_lines(para[1]) }
assert { lines.size == 3 } 
assert { lines.last == "Para 2 Line 3" } 
 
tst2 = "This line has several reading signs: the colon, the semicolon and the comma; but it should parse correctly and ignore extrateranous  spaces   like  these "

words = nil
assert { words = parser.split_words(tst2) }
p words
assert { words.size == 27 }
res = nil   
assert { res = parser.parse(tst2) }







