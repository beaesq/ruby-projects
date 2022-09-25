def substrings(string, list)
  clean_string = string.downcase.gsub(/[^abcdefghijklmnopqrstuvwxyz ]/,'')
  count_hash = list.reduce(Hash.new(0)) do |count, current_word|
    num = tally_substring(clean_string, current_word)
    count[current_word] = num if num > 0
    count
  end  
end

def tally_substring(str, substr)
  arr = substr.chars
  str.each_char.each_cons(substr.size).count(arr)
end  

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
p substrings("Howdy partner, sit down! How's it going?", dictionary)