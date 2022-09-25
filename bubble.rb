def bubble_sort(array)
  array.each_index do |current_index|

    array.each_index do |index_a|
      break if index_a + 1 > array.size - 1
      
      if array[index_a] > array[index_a + 1]
        swap(array, index_a, index_a + 1)
      end
    end  
   
  end  
  
end

def swap(array, index_a, index_b)
  array[index_a] = array[index_a] + array[index_b]
  array[index_b] = array[index_a] - array[index_b]
  array[index_a] = array[index_a] - array[index_b]
end

p bubble_sort([4,3,78,2,0,2])
