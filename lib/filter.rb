require 'fftw3'

class ButterworthFilter
	
	def initialize image_matrix
		@image_matrix = image_matrix
		@rows = image_matrix.size
		@columns = image_matrix[0].size
		@row_split = image_matrix.size / 2 
		@col_split = image_matrix[0].size / 2 
	end

	def to_frequency_domain
		auxiliary_matrix = NArray.to_na(@image_matrix)
		fft_matrix = FFTW3.fft(auxiliary_matrix) / auxiliary_matrix.length
		converted_matrix = fft_matrix.to_a
		return converted_matrix
	end

	def to_spacial_domain smoothened_matrix
		auxiliary_matrix = NArray.to_na(smoothened_matrix)
		converted_matrix = FFTW3.ifft(auxiliary_matrix).real.to_a
		integer_pixels = converted_matrix.map { |arr| arr.map { |ele| ele.to_i } }
		return integer_pixels
	end

	def low_pass_filter n, cutoff_frequency, epsilon=1
		processed_matrix = self.to_frequency_domain
		processed_matrix.each_with_index do |current_row, xi|
			current_row.each_with_index do |element, yi|
				omega = Math.sqrt((xi - @row_split)**2 + (yi - @col_split)**2)
				base = 1 + epsilon * ((omega / cutoff_frequency) ** (2 * n))
				element *= 1 / base
			end
		end

		filtered_matrix = self.to_spacial_domain(processed_matrix)
		return filtered_matrix
	end

	def high_pass_filter n, cutoff_frequency, epsilon=1
		processed_matrix = self.to_frequency_domain

		processed_matrix.each_with_index do |current_row, xi|
			current_row.each_with_index do |element, yi|
				omega = Math.sqrt((xi - @row_split)**2 + (yi - @col_split)**2)
				base = 1 + epsilon * ((omega / cutoff_frequency) ** (2 * n))
				element *= 1 - (1 / base)
			end
		end

		filtered_matrix = self.to_spacial_domain(processed_matrix)
		return filtered_matrix
	end

end