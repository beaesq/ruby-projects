def caesar_cipher(string, shift_factor)
  # for each char, convert via #ord, SHIFT, convert via #chr, glue chars together
  string_array = string.chars
  string_array.map! do |a|
    a = a.ord
    a = shift(a, shift_factor)
    a.chr
  end
  shifted_string = string_array.join
end 

def shift(ord, shift_factor)
  if ord >= 65 && ord <= 90
    if (ord + shift_factor > 90) 
      return 64 + ((ord + shift_factor) % 90) 
    else
      return ord + shift_factor 
    end
  elsif ord >= 97 && ord <= 122
    if (ord + shift_factor > 122) 
      return 96 + ((ord + shift_factor) % 122) 
    else
      return ord + shift_factor 
    end
  else 
    return ord
  end
end

p caesar_cipher("What a string!", 5)