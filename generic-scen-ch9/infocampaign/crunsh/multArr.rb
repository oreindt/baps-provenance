class Array
	def mult(arr)
		if self.empty?
			return arr
			end

		result = []
		self.each do |el|
			arr.each do |el2|
				result << [el, el2]
				end
			end
		result
		end
	end
